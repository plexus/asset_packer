module AssetPackager
  class Processor
    class StandAlone < self

      def data_uri(uri)
        base64 = Base64.strict_encode64(retrieve_asset uri)
        type   = MIME::Types.type_for(uri).first

        "data:#{type};base64,#{base64}"
      end

      class Image < self
        def call(doc)
          doc.replace('img') do |img|
            img.attr(:src, data_uri(img[:src]))
          end
        end
      end

    end
  end
end
