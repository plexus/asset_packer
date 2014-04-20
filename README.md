[![Gem Version](https://badge.fury.io/rb/asset_packer.png)][gem]
[![Build Status](https://secure.travis-ci.org/plexus/asset_packer.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/plexus/asset_packer.png)][codeclimate]

[gem]: https://rubygems.org/gems/asset_packer
[travis]: https://travis-ci.org/plexus/asset_packer
[codeclimate]: https://codeclimate.com/github/plexus/asset_packer

# Asset Packager

Given a HTML file (local or remote), asset packager will download all assets (images, stylesheets, scripts) to a local folder, and rewrite the HTML file to point to the local files. The result can be easily copied onto a USB stick and used off-line.

Asset Packager is part of [Slippery](https://github.com/plexus/slippery), a tool for creating presentations with Markdown, but can also be used stand-alone.

## Command line usage

```
asset_packer file.html target.html
asset_packer http://example.org/file.html target.html
```

This will create `target.html`, and a directory `target_assets` containing all the assets.

## Hexp usage

Asset Packager is at its core a Hexp transformation, it transform one HTML DOM tree into another. While doing so it creates some files. To use it directly on a Hexp document you need to pass it a bit of extra information

* the source URI, needed to resolve relative URI's
* the asset directory, where assets will be stored. Will be created if it doesn't exist
* the destination HTML file name, used to calculate new relative URI's for the assets

```ruby
doc = Hexp.parse(...)
doc = AssetPacker::Processor::Local.new('http://foo/bar', '/tmp/assets', '/tmp/result.html').call(doc)
File.write('/tmp/result.html', doc.to_html)
```

## Transformations

So far, the following assets are recognized

* img[src]
* link[rel="stylesheet"][href]
* script[src]

## Mutation Testing

Asset Packager has 100% mutation coverage using [Mutant](https://github.com/mbj/mutant). It is a rewrite of functionality originally included in Slippery, used to demonstrate the concept of mutation testing for an article for Sitepoint.

## Contributing

Use a feature branch, make sure `rake mutant` tells you all is fine, then send a pull request.

## License

Copyright 2014 Arne Brasseur

Available under the MIT license, see LICENSE file for details.