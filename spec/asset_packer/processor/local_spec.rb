require 'spec_helper'

describe AssetPacker::Processor::Local do
  with_fixture 'index.html', ['section.css']

  describe '#save_asset' do
    let(:target_path) { processor.asset_dir.join('4056951747637c9c22a635e09da36fea.css') }

    it 'should compute the path based on md5 digest and extension' do
      expect(processor.save_asset('section.css', 'css')).to eq Pathname('4056951747637c9c22a635e09da36fea.css')
    end

    it "should retrieve the asset's content" do
      processor.save_asset('section.css', 'css')
      expect(target_path.read).to eq 'section { color: blue; }'
    end

    it "should reuse existing assets with identical digest" do
      File.write(target_path, 'foobar')
      processor.save_asset('section.css', 'css')
      expect(target_path.read).to eq 'foobar'
    end

    describe "with an asset directory that doesn't exist" do
      let(:dst_dir)         { Pathname(Dir.mktmpdir()).join('assets') }
      let(:destination)     { dst_dir.join(html_file).join('..', html_file) }

      it 'should create the asset directory' do
        processor.save_asset('section.css', 'css')
        expect(dst_dir).to exist
      end
    end
  end

  describe '#call' do
    with_fixture 'has_all.html',
      'dummy.png' => 'images/dummy.png',
      'script.js' => 'scripts/script.js',
      'style.css' => 'assets/style.css'

    let(:result) { processor.call(Hexp.parse(source_uri.read)) }

    it 'should delegate to its subclasses' do
      expect(result.select('script[src="7d2ac8ea2ea878a64bb26221bc358d76.js"]').count).to eq 1
      expect(result.select('img[src="900150983cd24fb0d6963f7d28e17f72.png"]').count).to eq 1
      expect(result.select('link[href="383296b94213ea174c8bee073ea59733.css"]').count).to eq 1
    end
  end
end
