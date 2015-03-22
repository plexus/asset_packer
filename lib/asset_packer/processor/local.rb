module AssetPacker
  class Processor
    class Local < self

      def call(doc)
        Chain.new([Image, Script, Stylesheet].map {|klz|
          klz.new(source_uri, asset_dir, destination)
        }).(doc)
      end

      def save_asset(uri, extension)
        return uri if uri =~ /^data:/
        asset_dir.mkdir unless asset_dir.directory?
        content = retrieve_asset(uri)
        content = yield(content) if block_given?
        digest  = Digest::MD5.hexdigest(content)
        target  = asset_dir.join(extension ? digest + '.' + extension : digest)
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
            link.attr(:href, save_asset(link[:href], 'css', &extract_css_links(link[:href])))
          end
        end

        def extract_css_links(base_url)
          ->(content) do
            content.gsub(/url\(['"]?([^\)'"]*)['"]?\)/) {
              uri = URI.join(full_source_uri, base_url, $1)
              puts uri
              ext = File.extname($1)[1..-1]
              # TODO check for media type, not URL
              # using regex instead of checking ext because
              # google font files don't work otherwise
              block = extract_css_links(uri) if uri.to_s =~ /css/
              "url(../#{ save_asset(uri, ext, &block) })"
            }
          end
        end
      end
    end
  end
end
