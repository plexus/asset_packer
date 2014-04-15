require 'spec_helper'

describe AssetPackager::Processor::Local do
  with_fixture 'index.html', ['section.css']
  subject(:local) { described_class.new(source_path) }

  describe '#asset_dir' do
    subject { super().asset_dir }
    let(:target_dir) { directory.join('index_assets') }

    it { should eq target_dir }
    it { should exist }

    it 'should work when the directory already exists' do
      target_dir.mkdir
      expect(subject).to eq target_dir
    end
  end

  describe '#save_asset' do
    let(:target_path) { local.asset_dir.join('4056951747637c9c22a635e09da36fea.css') }

    it 'should compute the path based on md5 digest and extension' do
      expect(local.save_asset('section.css', 'css')).to eq target_path
    end

    it "should retrieve the asset's content" do
      local.save_asset('section.css', 'css')
      expect(target_path.read).to eq 'section { color: blue; }'
    end

    it "should reuse existing assets with identical digest" do
      File.write(target_path, 'foobar')
      expect(local.save_asset('section.css', 'css').read).to eq 'foobar'
    end
  end
end
