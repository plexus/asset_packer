$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tmpdir'
require 'fileutils'

require 'asset_packager'
require_relative 'shared'

module FixtureHelpers
  def with_fixture(html_file, assets = [])
    let(:html_file)       { html_file }
    let(:assets)          { assets }
    let(:fixture_src_dir) { AssetPackager::ROOT.join('spec/fixtures') }
    let(:directory)       { Pathname(Dir.mktmpdir()) }
    let(:source_path)     { directory.join(html_file) }

    include_context 'copy fixtures to tmpdir'
  end
end

RSpec.configure do |rspec|
  rspec.extend FixtureHelpers

  rspec.backtrace_exclusion_patterns = [] if ENV['FULLSTACK']
end
