require 'spec_helper'

describe AssetPackager::Processor::StandAlone::Image, '#call' do
  let(:document) do
    Hexp.parse('<html><body><img src="dummy.png" /></body></html>')
  end

  subject(:processor) { described_class.new(AssetPackager::ROOT.join('spec/fixtures/foo.html')) }

  it 'should convert to data URI' do
    expect(processor.(document)).to eq H[:html, H[:body, H[:img, src: 'data:image/png;base64,YWJj']]]
  end
end
