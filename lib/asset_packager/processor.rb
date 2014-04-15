module AssetPackager
  class Processor
    attr_reader :source_path

    def initialize(source_path)
      @source_path = source_path
    end

    def name
      source_path.basename(source_path.extname).to_s
    end

    def directory
      source_path.dirname
    end

    def retrieve_asset(uri)
      uri = URI(uri)
      case
      when %w[http https].include?(uri.scheme) || uri.scheme.nil? && uri.host
        Net::HTTP.get(uri)
      when uri.scheme.nil? || uri.scheme == 'file'
        File.read(directory.join(uri.path))
      end
    end

    class StandAlone < self

      def data_uri(uri)
        base64 = Base64.strict_encode64(retrieve_asset uri)
        type   = MIME::Types.type_for(uri).first

        "data:#{type};base64,#{base64}"
      end

      class Image < self
        def call(doc)
          doc.replace('img') do |img|
            H[:img, img.attributes.merge(src: data_uri(img[:src]))]
          end
        end
      end

    end
  end
end
