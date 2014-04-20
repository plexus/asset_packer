require 'spec_helper'

describe AssetPackager::Processor::Local::Image, '#call' do
  with_fixture 'has_img.html', 'dummy.png' => 'images/dummy.png'
  let(:doc) { Hexp.parse(source_uri.read) }

  it_behaves_like 'a local asset', '900150983cd24fb0d6963f7d28e17f72.png', 'abc'

  describe '#call' do
    it 'should replace the image source' do
      result = processor.call(doc)
      expect(result.select('img[src="900150983cd24fb0d6963f7d28e17f72.png"]').count).to eq 1
    end
  end

end
