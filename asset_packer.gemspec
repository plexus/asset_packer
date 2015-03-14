# encoding: utf-8

require File.expand_path('../lib/asset_packer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'asset_packer'
  gem.version     = AssetPacker::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Create an offline version of a HTML file.'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/asset_packer'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md LICENSE]

  gem.bindir           = 'bin'
  gem.executables      << 'asset_packer'

  gem.add_runtime_dependency 'hexp'       , '~> 0.4.6'
  gem.add_runtime_dependency 'mime-types' , '~> 2.2'

  gem.add_development_dependency 'rake'         , '~> 10.2'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-its'
  gem.add_development_dependency 'mutant-rspec'
end
