require 'spec_helper'

describe AssetPackager::Processor do
  with_fixture 'index.html', ['section.css']

  let(:fixture_pathname) { directory.join 'section.css' }
  subject(:processor)    { described_class.new(source_path) }

  its(:name)      { should eq 'index' }
  its(:directory) { should eq directory }

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
    include_examples 'remote URIs', '//foo.bar/baz'

    describe 'with an unrecognized protocol' do
      let(:uri) { 'ftp://example.com' }

      it 'should return nil' do
        expect(Net::HTTP).to_not receive(:get)
        expect(asset).to be_nil
      end
    end
  end

end
