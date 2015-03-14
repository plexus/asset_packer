module AssetPacker
  class Processor
    attr_reader :source_uri, :full_source_uri, :asset_dir, :destination

    # source_uri: location of the original document, used to retrieve relative URI's
    # asset_dir: location where assets will be stored
    # destination: file that will be generated, used to create relative URI's from
    def initialize(source_uri, asset_dir, destination)
      @source_uri  = source_uri
      @full_source_uri = URI(source_uri)
      if @full_source_uri.relative?
        source_file = Pathname(source_uri).expand_path
        @full_source_uri = URI("file://#{source_file}")
        @cache_dir  = source_file.dirname.join('.asset_cache')
        FileUtils.mkdir_p @cache_dir unless @cache_dir.exist?
      end
      @asset_dir   = Pathname(asset_dir)
      @destination = Pathname(destination)
    end

    def retrieve_asset(uri)
      uri = URI.join(full_source_uri, uri)
      cache(uri) do
        case
        when %w[http https].include?(uri.scheme)
          Net::HTTP.get(uri)
        when uri.scheme.eql?('file')
          File.read(uri.path)
        end
      end
    end

    def cache(uri)
      return yield if @cache_dir.nil? || uri.scheme == 'file'
      hash = Digest::SHA256.hexdigest(uri.to_s)
      cache_path = @cache_dir.join(hash)
      cache_path.write(yield) unless cache_path.exist?
      cache_path.read || ''
    end

  end
end
