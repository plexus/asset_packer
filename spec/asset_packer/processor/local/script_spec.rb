require 'spec_helper'

describe AssetPacker::Processor::Local::Script do
  with_fixture 'has_script.html', 'script.js' => 'scripts/script.js'
  let(:doc) { Hexp.parse(source_uri.read) }

  it_behaves_like 'a local asset', '7d2ac8ea2ea878a64bb26221bc358d76.js', '/*javascript*/'

  describe '#call' do
    it 'should replace the script source' do
      result = processor.call(doc)
      expect(result.select('script[src="7d2ac8ea2ea878a64bb26221bc358d76.js"]').count).to eq 1
    end
  end
end
