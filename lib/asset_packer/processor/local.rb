module AssetPacker
  class Processor
    class Local < self

      def call(doc)
        Chain.new([Image, Script, Stylesheet].map {|klz|
          klz.new(source_uri, asset_dir, destination)
        }).(doc)
      end

      def save_asset(uri, extension)
        print "Saving #{uri} ... "
        asset_dir.mkdir unless asset_dir.directory?
        content = retrieve_asset(uri)
        content = yield(content) if block_given?
        digest  = Digest::MD5.hexdigest(content)
        target  = asset_dir.join(digest + '.' + extension)
        File.write(target, content) unless target.exist?
        puts "done"
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
            href = save_asset(link[:href], 'css') do |content|
              content.gsub(/url\("?(.*?)"?\)/) do
                rel_uri    = $1
                abs_uri    = absolute_uri(rel_uri)
                extension = Pathname(abs_uri.path).extname.sub(/^\./, '')
                ['url(', save_asset(abs_uri, extension), ')'].join
              end
            end
            link.attr(:href, href)
          end
        end
      end
    end
  end
end
