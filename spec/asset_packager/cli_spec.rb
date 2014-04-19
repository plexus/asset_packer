require 'spec_helper'

describe AssetPackager::CLI do
  describe '.run' do
    let(:cli) { double(run: nil) }
    let(:argv) { [] }
    subject { described_class.run(argv) }

    before do
      expect(described_class).to \
        receive(:create_from_args)
        .with(argv)
        .and_return(cli)
    end

    context 'with a succesful run' do
      it 'should return EXIT_SUCCESS' do
        expect(subject).to eq 0
      end
    end

    shared_examples_for 'a non-succesful run' do
      before do
        allow(cli).to receive(:run, &run_impl)
        orig_stderr, $stderr  = $stderr, StringIO.new
        @result               = subject
        $stderr, @captured_io = orig_stderr, $stderr
      end

      it 'should output the exception message to $stderr' do
        expect(@captured_io.string).to eq message
        expect(@result).to eq exit_code
      end

    end

    context 'when receiving an ExitEarly exception' do
      let(:run_impl)   { ->{ raise described_class::ExitEarly.new('mezage', 123) } }
      let(:message)    { "mezage\n" }
      let(:exit_code)  { 123 }

      it_should_behave_like 'a non-succesful run'
    end

    context 'when receiving another exception' do
      let(:run_impl)   { ->{ raise ArgumentError, 'foo bar' } }
      let(:message)    { "foo bar\n" }
      let(:exit_code)  { 1 }

      it_should_behave_like 'a non-succesful run'
    end
  end


  describe '.create_from_args' do
    subject(:cli)  { described_class.create_from_args(argv) }
    let(:argv) { %w[file1 file2] }

    its(:infile) { should eq 'file1' }
    its(:outfile) { should eq 'file2' }
    its(:standalone) { should eq false }

    context 'given the --standalone flag' do
      let(:argv) { %w[ --standalone file1 file2 ] }
      its(:standalone) { should eq true }

      it 'should not alter ARGV' do
        orig_argv = argv.dup
        cli
        expect(argv).to eq orig_argv
      end
    end

    context 'given --help' do
      let(:argv) { %w[ --help ] }

      it 'should display the help information' do
        expect { cli }.to raise_error {|error|
          expect(error.message).to match /Usage: asset_packager/
          expect(error.exit_code).to eq 0
        }
      end
    end

    context 'given --version' do
      let(:argv) { %w[ --version ] }

      it 'should display the help information' do
        expect { cli }.to raise_error {|error|
          expect(error.message).to match /asset_packager-\d+\.\d+\.\d+/
          expect(error.exit_code).to eq 0
        }
      end
    end

    shared_examples_for 'illegal arguments' do |argv|
      it 'should display the help information' do
        expect { described_class.create_from_args(argv) }.to raise_error {|error|
          expect(error.message).to match /Usage: asset_packager/
          expect(error.exit_code).to eq 1
        }
      end
    end

    include_examples 'illegal arguments', %w[]
    include_examples 'illegal arguments', %w[only_one_filename]
    include_examples 'illegal arguments', %w[three file names]

  end
end
