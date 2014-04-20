require 'spec_helper'

describe AssetPacker::Processor::Local::Stylesheet, '#call' do
  with_fixture 'has_stylesheet.html', 'style.css' => 'assets/style.css'
  let(:doc) { Hexp.parse(source_uri.read) }

  it_behaves_like 'a local asset', '383296b94213ea174c8bee073ea59733.css', '/*style*/'

  describe '#call' do
    it 'should replace the styleheet href' do
      result = processor.call(doc)
      expect(result.select('link[href="383296b94213ea174c8bee073ea59733.css"]').count).to eq 1
    end
  end

end
