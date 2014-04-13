module AssetPackager
  class Processor
    attr_reader :cwd

    def initialize(cwd)
      @cwd = cwd
    end

    def retrieve_asset(uri)
      uri = URI(uri)
      case
      when %w[http https].include?(uri.scheme) || uri.scheme.nil? && uri.host
        Net::HTTP.get(uri)
      when uri.scheme.nil? || uri.scheme == 'file'
        File.read(cwd.join(uri.path))
      end
    end
  end
end
