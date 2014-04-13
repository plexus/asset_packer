require 'spec_helper'

describe AssetPackager::Processor do
  let(:cwd) { AssetPackager::ROOT }
  let(:processor) { AssetPackager::Processor.new(cwd) }
  let(:fixture_pathname) { AssetPackager::ROOT.join 'spec/fixtures/section.css' }

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
      let(:uri) { fixture_pathname.relative_path_from(AssetPackager::ROOT).to_s }
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
  end
end
