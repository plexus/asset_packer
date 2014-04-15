require 'spec_helper'

describe AssetPackager::Processor::Local do
  with_fixture 'index.html'
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
end
