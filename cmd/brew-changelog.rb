require "yaml"

changelogs = YAML.load_file "#{__dir__}/../brew.yml"

exec_browser *ARGV.formulae.map(&-> formula {
  case
  when changelog = changelogs[formula.name]
    return changelogs[changelog] || changelog
  when formula.downloader.url =~ %r{^https?://github\.com(/[^/]+){2}}
    return "#{$&}/releases"
  else formula.homepage
  end
})
