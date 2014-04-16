require 'spec_helper'

describe AssetPackager::Processor::Local::Stylesheet, '#call' do
  with_fixture 'has_stylesheet.html', 'style.css' => 'assets/style.css'
  subject(:processor) { described_class.new(source_path) }
  let(:doc) { Hexp.parse(source_path.read) }

  it_behaves_like 'a local asset', 'has_stylesheet_assets/383296b94213ea174c8bee073ea59733.css', '/*style*/'

  describe '#call' do
    it 'should replace the styleheet href' do
      result = processor.call(doc)
      expect(result.select('link[href="has_stylesheet_assets/383296b94213ea174c8bee073ea59733.css"]').count).to eq 1
    end
  end

end
