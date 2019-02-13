require "yaml"

module Cask
  class Cmd
    class Changelog < AbstractCommand

      def initialize(*)
        super
        raise CaskUnspecifiedError if args.empty?
      end

      def run
        if casks.none?
          odebug "Opening project changelog"
          self.class.open_url "https://github.com/Homebrew/homebrew-cask/releases"
        else
          changelogs = YAML.load_file "#{__dir__}/../cask.yml"

          casks.map(&-> cask {
            odebug "Opening changelog for Cask #{cask}"

            homepage, url, appcast, version = cask.to_h.values[1..-1].map &:to_s

            changelog = changelogs[cask.token]
            changelog = changelogs[changelog] || changelog

            case
            when changelog =~ /^http/ then changelog
            when version == "latest"|| appcast.empty? then homepage
            when appcast =~ /\.(php|rss|xml)$/ then homepage
            else appcast.chomp ".atom"
            end
          }).each &self.class.method(:open_url)
        end
      end

      def self.open_url(url)
        SystemCommand.run!(OS::PATH_OPEN, args: ["--", url])
      end

      def self.help
        "opens the changelog of the given Cask"
      end
    end
  end
end

ARGV.shift
Cask::Cmd::Changelog.run *ARGV
