describe AssetPackager::Processor::StandAlone do
  let(:source_path)      { AssetPackager::ROOT.join('foo.html') }
  let(:processor)        { described_class.new(source_path) }
  let(:fixture_pathname) { source_path.dirname.join 'spec/fixtures/section.css' }

  describe '#data_uri' do
    it 'should create a base64 encoded data URI' do
      expect(processor.data_uri(fixture_pathname.to_s)).to eq 'data:text/css;base64,c2VjdGlvbiB7IGNvbG9yOiBibHVlOyB9'
    end
  end
end
