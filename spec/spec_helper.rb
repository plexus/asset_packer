$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tmpdir'
require 'fileutils'

require 'asset_packer'
require_relative 'shared'

module FixtureHelpers
  def with_fixture(html_file, assets = [])
    subject(:processor) { described_class.new(source_uri.to_s, dst_dir.to_s, destination.to_s) }

    let(:html_file)       { html_file }
    let(:assets)          { assets }
    let(:fixture_dir)     { AssetPacker::ROOT.join('spec/fixtures') }
    let(:src_dir)         { Pathname(Dir.mktmpdir()) }
    let(:dst_dir)         { Pathname(Dir.mktmpdir()) }
    let(:source_uri)      { src_dir.join(html_file) }
    let(:destination)     { dst_dir.join(html_file) }

    include_context 'copy fixtures to tmpdir'
  end
end

RSpec.configure do |rspec|
  rspec.extend FixtureHelpers

  rspec.backtrace_exclusion_patterns = [] if ENV['FULLSTACK']
end
