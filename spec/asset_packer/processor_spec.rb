require 'spec_helper'

describe AssetPacker::Processor do
  with_fixture 'index.html', ['section.css']

  let(:fixture_pathname) { src_dir.join 'section.css' }

  its(:full_source_uri) { should eq URI("file://#{source_uri}") }

  describe '#initialize' do
    let(:subject)     { described_class.new('/tmp/source/file.html', '/asset_dir', '/dest.html') }
    its(:full_source_uri)  { should eq URI('file:///tmp/source/file.html') }
    its(:asset_dir)   { should eq Pathname('/asset_dir') }
    its(:destination) { should eq Pathname('/dest.html') }

    context 'with absolute URI' do
      let(:subject)     { described_class.new('http://source/file.html', '/asset_dir', '/dest.html') }
      its(:full_source_uri)  { should eq URI('http://source/file.html') }
    end

    context 'with a relative file name' do
      let(:subject)     { described_class.new('foo/bar.html', '/asset_dir', 'dest.html') }
      its(:full_source_uri)  { should eq URI("file://#{AssetPacker::ROOT.join('foo/bar.html')}") }
    end
  end

  describe '#retrieve_asset' do
    subject(:asset) { processor.retrieve_asset(uri) }

    shared_examples 'local files' do
      it 'should load the file from the local file system' do
        expect(asset).to eq 'section { color: blue; }'
      end
    end

    describe 'with a file URI' do
      let(:uri) { "file://#{fixture_pathname}" }
      include_examples 'local files'
    end

    describe 'with an absolute path' do
      let(:uri) { fixture_pathname.to_s }
      include_examples 'local files'
    end

    describe 'with a relative path' do
      let(:uri) { 'section.css' }
      include_examples 'local files'
    end

    shared_examples 'remote URIs' do |uri|
      it 'should retrieve the file through Net::HTTP' do
        expect(Net::HTTP).to receive(:get).with(URI(uri)).and_return('abc')
        expect(processor.retrieve_asset(uri)).to eq 'abc'
      end
    end

    include_examples 'remote URIs', 'http://foo.bar/baz'
    include_examples 'remote URIs', 'https://foo.bar/baz'

    describe 'with an unrecognized protocol' do
      let(:uri) { 'ftp://example.com' }

      it 'should return nil' do
        expect(Net::HTTP).to_not receive(:get)
        expect(asset).to eql ""
      end
    end
  end

end
