module AssetPackager
  class Processor
    class Local < self

      def call(doc)
        Chain.new([Image, Script, Stylesheet].map {|klz|
          klz.new(source_uri, asset_dir, destination)
        }).(doc)
      end

      def save_asset(uri, extension)
        asset_dir.mkdir unless asset_dir.directory?
        content = retrieve_asset(uri)
        digest  = Digest::MD5.hexdigest(content)
        target  = asset_dir.join(digest + '.' + extension)
        File.write(target, content) unless target.exist?
        target.relative_path_from(destination.dirname)
      end

      class Image < self
        def call(doc)
          doc.replace('img') do |img|
            uri = img[:src]
            extension = File.extname(uri).sub(/^\./, '')
            img.attr(:src, save_asset(uri, extension))
          end
        end
      end

      class Script < self
        def call(doc)
          doc.replace('script[src]') do |script|
            script.attr(:src, save_asset(script[:src], 'js'))
          end
        end
      end

      class Stylesheet < self
        def call(doc)
          doc.replace('link[rel=stylesheet]') do |link|
            link.attr(:href, save_asset(link[:href], 'css'))
          end
        end
      end
    end
  end
end
