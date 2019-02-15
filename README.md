[Homebrew] `changelog`
======================
Following on from [Homebrew/brew#3399], this is an effort to introduce a `changelog` _[stanza]_ into Home`brew` and `cask`.

Hopefully this will follow the process of the [`desc`]ription stanza, and so initially this will be in the from of an [external command], made available with a _[tap]_:
~~~ sh
brew tap danielbayley/changelog
brew changelog #formula
brew cask changelog #cask
~~~

Contribute
----------
Contributions for `changelog` URLs are very welcome, and extremely easy to add; just a line of _[YAML]_ in either [`brew`.yml], or [`cask`.yml].

License
-------
[MIT] © [Daniel Bayley]

[MIT]:                LICENSE.md
[Daniel Bayley]:      https://github.com/danielbayley

[homebrew]:           https://brew.sh
[tap]:                https://docs.brew.sh/Taps
[external command]:   https://docs.brew.sh/External-Commands
[stanza]:             https://github.com/Homebrew/homebrew-cask/blob/master/doc/cask_language_reference/readme.md#the-cask-language-is-declarative
[`desc`]:             https://docs.brew.sh/Formula-Cookbook#fill-in-the-homepage

[YAML]:               https://yaml.org
[`brew`.yml]:         brew.yml
[`cask`.yml]:         cask.yml

[Homebrew/brew#3399]: https://github.com/Homebrew/brew/issues/3399#issuecomment-340488771
