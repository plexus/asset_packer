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

    def data_uri(uri)
      base64 = Base64.strict_encode64(retrieve_asset uri)
      type   = MIME::Types.type_for(uri).first

      "data:#{type};base64,#{base64}"
    end

    class StandAlone < self

      class Image < self

      end
    end
  end
end
