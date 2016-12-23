module Alki
  module Loader
    class Entry
      attr_reader :path
      attr_reader :data

      def initialize(path,data)
        @path = path.chomp('/')
        @data = data
      end

      def name
        @data[:name]
      end

      def build(blk)
        Alki::Support.load_class(@builder).build @data, &blk
      end
    end
  end
end
