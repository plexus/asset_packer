module AssetPacker
  class Processor
    attr_reader :source_uri, :asset_dir, :destination

    # source_uri: location of the original document, used to retrieve relative URI's
    # asset_dir: location where assets will be stored
    # destination: file that will be generated, used to create relative URI's from
    def initialize(source_uri, asset_dir, destination)
      @source_uri  = URI(source_uri)
      if @source_uri.relative?
        @source_uri  = URI("file://#{Pathname(source_uri).expand_path}")
      end
      @asset_dir   = Pathname(asset_dir)
      @destination = Pathname(destination)
    end

    def retrieve_asset(uri)
      uri = absolute_uri(uri)
      case
      when %w[http https].include?(uri.scheme)
        Net::HTTP.get(uri)
      when uri.scheme.eql?('file')
        File.read(uri.path)
      end
    end

    def absolute_uri(relative_uri)
      URI.join(source_uri, relative_uri)
    end

  end
end
