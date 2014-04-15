module AssetPackager
  class Processor
    class Local < self
      def asset_dir
        directory.join("#{name}_assets").tap do |dir|
          dir.mkdir unless dir.directory?
        end
      end

      def save_asset(uri, extension)
        content = retrieve_asset(uri)
        digest  = Digest::MD5.hexdigest(content)
        target  = asset_dir.join(digest + '.' + extension)
        File.write(target, content) unless target.exist?
        target
      end

      class Image < self
        # def call(doc)
        #   doc.replace('img') do |img|
        #   end
        # end
      end
    end
  end
end
