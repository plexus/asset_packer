# asset_packager file.html
# asset_packager --standalone file.html
# asset_packager --help

module AssetPackager
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

    attr_reader :infile, :outfile, :standalone

    def initialize(infile, outfile, standalone)
      @infile, @outfile, @standalone = infile, outfile, standalone
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
      argv = argv.dup
      standalone = false

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: asset_packager [options] input_file.html output_file.html"
        opts.on('--standalone', 'Include all assets inline') do |d|
          standalone = true
        end.on('--version', 'Print asset_packagers version') do |name|
          raise ExitEarly, "asset_packager-#{AssetPackager::VERSION}"
        end.on('--help', 'Display help on command line usage') do
          raise ExitEarly, opts
        end
      end

      opts.parse!(argv)

      if argv.length != 2
        raise ExitEarly.new(opts, EXIT_FAILURE)
      end

      new(*argv, standalone)
    end

    def run
    end

  end
end
