shared_examples 'a local asset' do |filename, contents|
  let(:destination) { dst_dir.join(filename) }

  it 'should save the file to an MD5 digest based file name' do
    processor.call(doc)
    expect(destination).to exist
  end

  it 'should save the asset with the correct contents' do
    processor.call(doc)
    expect(destination.read).to eq contents
  end
end

shared_context 'copy fixtures to tmpdir' do
  before do
    FileUtils.cp fixture_dir.join(html_file), src_dir.join(html_file)

    assets.each do |src, dst|
      dst ||= src
      dst = src_dir.join(dst)
      Dir.mkdir(dst.dirname) unless dst.dirname.exist?
      FileUtils.cp fixture_dir.join(src), dst
    end
  end

  after do
    FileUtils.rm_rf src_dir if src_dir.exist?
    FileUtils.rm_rf dst_dir if dst_dir.exist?
  end
end
