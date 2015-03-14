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
      local = Processor::Local.new(infile, asset_dir, outfile)
      doc = Hexp.parse(local.retrieve_asset(infile))
      File.write(outfile, local.(doc).to_html)
    end

  end
end
