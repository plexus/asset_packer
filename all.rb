# asset_packer file.html
# asset_packer --standalone file.html
# asset_packer --help

module AssetPacker
  class CLI
    EXIT_SUCCESS = 0
    EXIT_FAILURE = 1

    class ExitEarly < StandardError
      attr_reader :exit_code

      def initialize(message, exit_code = 0)
        super(message)
        @exit_code = exit_code
      end
    end

    attr_reader :infile, :outfile

    def initialize(infile, outfile)
      @infile  = infile
      @outfile = Pathname(outfile).expand_path
    end

    def self.run(argv)
      create_from_args(argv).run
      EXIT_SUCCESS
    rescue ExitEarly => exception
      $stderr.puts(exception)
      exception.exit_code
    rescue => exception
      $stderr.puts(exception)
      EXIT_FAILURE
    end

    def self.create_from_args(argv)
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: asset_packer [options] input_file.html output_file.html"
        opts.on('--version', 'Print asset_packers version') do |name|
          raise ExitEarly, "asset_packer-#{AssetPacker::VERSION}"
        end.on('--help', 'Display help on command line usage') do
          raise ExitEarly, opts
        end
      end

      opts.parse!(argv)

      if argv.length != 2
        raise ExitEarly.new(opts, EXIT_FAILURE)
      end

      new(*argv)
    end

    def run
      asset_dir = outfile.dirname.join("#{outfile.basename(outfile.extname)}_assets")
      local     = Processor::Local.new(infile, asset_dir, outfile)
      doc = Hexp.parse(local.retrieve_asset(infile))
      File.write(outfile, local.(doc).to_html)
    end

  end
end
module AssetPacker
  class Processor
    class Chain
      def initialize(processors)
        @processors = processors
      end

      def call(doc)
        @processors.inject(doc) {|doc, proc| proc.(doc) }
      end
    end
  end
end
module AssetPacker
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
      uri = URI.join(source_uri, uri)
      case
      when %w[http https].include?(uri.scheme)
        Net::HTTP.get(uri)
      when uri.scheme.eql?('file')
        File.read(uri.path)
      end
    end

  end
end
require 'pathname'
require 'net/http'
require 'base64'
require 'optparse'

require 'hexp'
require 'mime/types'

module AssetPacker
  ROOT = Pathname(__FILE__).dirname.parent
end

require 'asset_packer/version'
require 'asset_packer/cli'
require 'asset_packer/processor'
require 'asset_packer/processor/local'
require 'asset_packer/processor/chain'
module AssetPacker
  VERSION = '0.1.0'
end
