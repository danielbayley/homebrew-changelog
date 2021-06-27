# frozen_string_literal: true

require "net/http"
require "cmd/home"

module Homebrew
  module_function

  def changelog_args
    Homebrew::CLI::Parser.new do
      description <<~EOS
        Open a <formula> or <cask>'s changelog in a browser, or open
        Homebrew's own release notes if no argument is provided.
      EOS
      switch "--formula", "--formulae", description: "Treat all named arguments as formulae."
      switch "--cask", "--casks", description: "Treat all named arguments as casks."
      switch "-l", "--list", description: "List changelog URLs only."
      switch "-f", "--fast", description: "Skip slower checks for changelogs on GitHub URls."

      conflicts "--formula", "--cask"

      named_args [:formula, :cask]
    end
  end

  def changelog
    args = changelog_args.parse

    return exec_browser "#{HOMEBREW_WWW}/blog" if args.no_named?

    type = if args.casks? then "casks"
    elsif args.formulae? then "formulae"
    else
      concat = `cat #{__dir__}/../{casks,formulae}.yml`
      changelogs = YAML.safe_load concat, [String], aliases: true
    end
    changelogs ||= YAML.load_file "#{__dir__}/../#{type}.yml"

    open = args.named.to_formulae_and_casks.map do |formula|
      yaml, = Dir["#{formula.tap.path}/{Casks,Formula}/changelogs.y*ml"]
      changelogs.merge! YAML.load_file yaml if yaml

      token = formula.try(:token) || formula.name
      if (changelog = changelogs[token])
        changelog.prepend "https://" unless changelog.start_with? "http:"
        next args.list? ? puts(changelog) : changelog
      end

      if formula.livecheckable?
        livecheck = formula.livecheck.url
        changelog ||= URI.parse case livecheck
        when :stable, :head then formula.downloader.url
        when :homepage, :url then formula.send(livecheck).to_s
        else livecheck
        end
      end

      if (head = formula.try(:head)&.url)
        changelog ||= URI.parse head
      end

      changelog ||= formula.try(:appcast)&.uri

      skip = %w[rss xml]
      if changelog&.path&.end_with?(*skip) then changelog = nil
      elsif changelog&.query&.end_with? "atom" then changelog.query = nil
      end

      changelog ||= URI.parse formula.homepage

      path = Pathname changelog.path
      case path.extname
      when ".git" then changelog.path.delete_suffix! path.extname
      when *UnpackStrategy.from_extension(path.extname)&.extensions
        changelog.path = path.parent unless changelog.host == "github.com"
      end

      if changelog.host == "github.com"
        folders = changelog.path.split File::SEPARATOR
        changelog.path = File.join(*folders.first(3)) if path.extname.present?

        glob = "{CHANGELOG,ChangeLog}{.{md,{tx,rs}t},}"
        logs = `echo #{glob}`.split
        logs += logs.map(&:downcase) + logs.map(&:capitalize)

        server = "8.8.8.8"
        if !args.fast? && system_command("ping -c 1 -t 1 #{server}", print_stderr: false)
          http = Net::HTTP.new changelog.host, changelog.port
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER

          logs.find do |log|
            log.prepend "/blob/master/"
            request = Net::HTTP::Get.new changelog.request_uri + log
            response = http.request request
            changelog.path += log unless response.code.to_i.between? 400, 599
          end
        end

        changelog.path += "/releases" if folders.compact_blank.count == 2 && !changelog.path.end_with?(*logs)
        changelog.fragment = nil if changelog.fragment == "readme"
      end

      next puts changelog if args.list?

      puts "Opening changelog for #{name_of formula}"
      next changelog
    end

    exec_browser(*open) if open.any?
  end
end
