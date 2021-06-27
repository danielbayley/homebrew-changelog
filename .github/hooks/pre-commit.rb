#! /usr/bin/ruby
# frozen_string_literal: true

require "yaml"
require "io/console"
require "net/http"
require "pathname"

COLUMNS = (ENV["CI"] ? 80 : IO.console.winsize.last).freeze

width = 20 # %
indent = COLUMNS / 100.0 * width

staged = ARGV.any? ? ARGV : nil
staged ||= `git diff --staged --name-only --diff-filter ACM`.lines.map(&:chomp)

exit 0 if staged.empty?

def error(token, url, portion)
  raise ArgumentError, "`#{token}: #{url}` URL should not contain #{portion}"
end

staged.each do |yml|
  yaml = YAML.load_file Pathname(__dir__).parent.parent + yml

  yaml.each_with_index do |pair, i|
    *, url = pair

    error(*pair, "trailing `/`") if url.end_with? "/"

    if url != yaml.to_a[i - 1].last
      error(*pair, "`https://`") if url.start_with? "https"
      url.prepend "https://" unless url.start_with? "http:"
    end

    uri = URI.parse url
    error(*pair, "`www.`") if uri.host.start_with?("www.") && Pathname(uri.path).extname.empty?

    next puts "OK".ljust(indent.to_i) + "\t#{url}" unless ENV["CI"]

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme == "https"
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request

    raise url, response.error! if response.code.to_i.between? 400, 599

    puts "#{response.msg.ljust indent.to_i}\t#{url}"
  end
end
