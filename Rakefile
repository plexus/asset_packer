########################################
# Testing

require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new

task :default => :mutant

task :mutant do
  pattern = ENV.fetch('PATTERN', 'AssetPacker*')
  result  = Mutant::CLI.run(%w[-Ilib -rasset_packer --use rspec --score 100] + [pattern])
  fail unless result == Mutant::CLI::EXIT_SUCCESS
end

########################################
# Packaging

require 'rubygems/package_task'
spec = Gem::Specification.load(File.expand_path('../asset_packer.gemspec', __FILE__))
gem = Gem::PackageTask.new(spec)
gem.define


desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{AssetPacker::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/asset_packer-#{AssetPacker::VERSION}.gem"
end
