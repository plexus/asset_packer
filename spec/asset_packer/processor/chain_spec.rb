require 'spec_helper'

describe AssetPacker::Processor::Chain do
  it 'should functionally compose' do
    chain = described_class.new([
        ->(x) { x + 1 },
        ->(x) { x * 5 }
      ])
    expect(chain.call(2)).to eq 15
  end
end
