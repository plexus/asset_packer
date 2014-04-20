[![Gem Version](https://badge.fury.io/rb/asset_packager.png)][gem]
[![Build Status](https://secure.travis-ci.org/plexus/asset_packager.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/plexus/asset_packager.png)][codeclimate]

[gem]: https://rubygems.org/gems/asset_packager
[travis]: https://travis-ci.org/plexus/asset_packager
[codeclimate]: https://codeclimate.com/github/plexus/asset_packager

# Asset Packager

Given a HTML file (local or remote), asset packager will download all assets (images, stylesheets, scripts) to a local folder, and rewrite the HTML file to point to the local file. The result can be easily copied onto a USB stick and used off-line.

Asset Packager is part of [Slippery](https://github.com/plexus/slippery), a tool for creating presentations with Markdown, but can also be used stand-alone.

## Command line usage

```
asset_packager file.html target.html
```

This will create `target.html`, and a directory `target_assets` containing all the assets.

## Hexp usage

Asset Packager is at it's core a Hexp transformation, it transform one HTML DOM tree into another. While doing so it creates some files. To use it directly on a Hexp document you need to pass it a bit of extra information

* the source URI, needed to resolve relative URI's
* the asset directory, where assets will be stored
* the destination HTML file name, used to calculate new relative URI's for the assets

```ruby
doc = Hexp.parse(...)
doc = AssetPackager::Processor::Local.new('http://foo/bar', '/tmp/assets', '/tmp/result.html').call(doc)
File.write('/tmp/result.html', doc.to_html)
```

## Transformations

The following assets are recognized

* img[src]
* link[rel="stylesheet"][href]
* script[src]

## Mutation Testing

Asset Packager has 100% mutation coverage using [Mutant](https://github.com/mbj/mutant). It is a rewrite of functionality originally included in Slippery, used to demonstrate the concept of mutation testing for an article for Sitepoint.

## Contributing

Use a feature branch, make sure `rake mutant` tells you all is fine, then send a pull request.