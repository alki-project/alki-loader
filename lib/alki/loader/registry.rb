require 'thread'

module Alki
  module Loader
    class Registry
      def initialize
        @lock = Monitor.new
        clear
      end

      def clear
        @lock.synchronize do
          @paths = []
          @names = []
          @configs_loaded = false
        end
      end

      def paths
        load_configs!
        @paths.map{|e| e.path }
      end

      def add(entry)
        @lock.synchronize do
          @paths.delete_if{|e| e.path == entry.path }
          @paths << entry
          @names.sort!{|a,b| b.path <=> a.path}
          if entry.name
            @names.delete_if{|e| e.path == entry.path }
            @names << entry
            @names.sort!{|a,b| b.name <=> a.name}
          end
        end
      end

      def lookup_name(name)
        load_configs!
        @names.find do |e|
          name.start_with?(e.name) &&
            (name.size == e.name.size || name[e.name.size] == '/')
        end
      end

      def lookup_path(path)
        load_configs!
        @paths.find do |e|
          path.start_with?(e.path) &&
            (path.size == e.path.size || path[e.path.size] == '/')
        end
      end

      def load_configs!
        @lock.synchronize do
          path_hash = $LOAD_PATH.hash
          return if @configs_loaded == path_hash
          @configs_loaded = path_hash
          Gem.find_files_from_load_path('alki_loader.rb').each do |config_path|
            require config_path
          end
        end
      end
    end
  end
end
