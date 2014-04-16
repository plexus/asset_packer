shared_examples 'a local asset' do |filename, contents|
  let(:destination) { directory.join(filename) }

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
    FileUtils.cp fixture_src_dir.join(html_file), directory.join(html_file)

    assets.each do |src, dst|
      dst ||= src
      dst = directory.join(dst)
      Dir.mkdir(dst.dirname) unless dst.dirname.exist?
      FileUtils.cp fixture_src_dir.join(src), dst
    end
  end

  after do
    FileUtils.rm_rf directory if directory.exist?
  end
end
