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
