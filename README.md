_[Homebrew]_ `changelog`
=======================
Following on from [Homebrew/brew#3399], this is an effort to introduce a `changelog` _[stanza]_ into Home`brew` _[formula]e_ and _[Cask]s_.

Hopefully this will follow the process of the [`desc`]ription stanza, and so initially this will be in the from of an [external command], made available with this _[tap]_…

Note that a `/changelogs.y`[`a`]`ml` file can be added to the [`Formula`/`Casks`] folder of any tap to also work with this command.

Install
-------
~~~ sh
brew tap danielbayley/changelog
brew changelog #formula #cask
~~~

Contribute
----------
Contributions for `changelog` URLs are very welcome, and extremely easy to add! Just a line of _[YAML]_ in either [`formulae.yml`] or [`casks.yml`]. Be sure to remove the `http`[`s`]`://`[`www.`] portion, and any trailing `/` or `.html` suffix from the URL, unless necessary, as these will automatically be resolved.

`git config core.hooksPath .github/hooks`

License
-------
[MIT] © [Daniel Bayley]

[MIT]:                LICENSE.md
[Daniel Bayley]:      https://github.com/danielbayley

[homebrew]:           https://brew.sh
[formula]:            https://docs.brew.sh/Formula-Cookbook
[cask]:               https://docs.brew.sh/Cask-Cookbook
[stanza]:             https://docs.brew.sh/Cask-Cookbook#stanzas
[`desc`]:             https://docs.brew.sh/Cask-Cookbook#stanza-desc
[tap]:                https://docs.brew.sh/Taps
[external command]:   https://docs.brew.sh/External-Commands

[YAML]:               https://yaml.org
[`formulae.yml`]:     formulae.yml
[`casks.yml`]:        casks.yml

[Homebrew/brew#3399]: https://github.com/Homebrew/brew/issues/3399#issuecomment-340488771
