module AssetPackager
  class Processor
    class Local < self
      def asset_dir
        directory.join("#{name}_assets").tap do |dir|
          dir.mkdir unless dir.directory?
        end
      end

      # def save_asset(uri)
      # end

      class Image < self
        # def call(doc)
        #   doc.replace('img') do |img|
        #   end
        # end
      end
    end
  end
end
