require 'spec_helper'

describe AssetPackager::Processor::Local::Image, '#call' do
  with_fixture 'has_img.html', 'dummy.png' => 'images/dummy.png'
  subject(:processor) { described_class.new(source_path) }
  let(:doc) { Hexp.parse(source_path.read) }

  it_behaves_like 'a local asset', 'has_img_assets/900150983cd24fb0d6963f7d28e17f72.png', 'abc'

  describe '#call' do
    it 'should replace the image source' do
      result = processor.call(doc)
      expect(result.select('img[src$="has_img_assets/900150983cd24fb0d6963f7d28e17f72.png"]').count).to eq 1
    end
  end

end
