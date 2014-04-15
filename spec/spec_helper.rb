$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tmpdir'
require 'fileutils'

require 'asset_packager'

shared_context 'copy fixtures to tmpdir' do
  before do
    FileUtils.cp fixture_src_dir.join(html_file), directory.join(html_file)

    assets.each do |src, dst|
      dst ||= src
      dst = directory.join(dst)
      Dir.mkdir(dst.dirname) unless dst.dirname.exist?
      FileUtils.cp fixture_src_dir.join(src), dst
    end
  end

  after do
    #FileUtils.rm_rf directory if directory.exist?
  end
end

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
end
