require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new

task :default => :spec

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{AssetPackager::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/asset_packager-#{AssetPackager::VERSION}.gem"
end

task :mutant do
  result = Mutant::CLI.run(%w[-Ilib -rasset_packager --use rspec --score 100 AssetPackager*])
  fail unless result == Mutant::CLI::EXIT_SUCCESS
end
