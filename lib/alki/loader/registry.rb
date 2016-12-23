module Alki
  module Loader
    class Registry
      def initialize
        clear
      end

      def clear
        @paths = []
        @paths_sorted = true
        @names = []
        @names_sorted = true
        @configs_loaded = false
      end

      def paths
        load_configs!
        @paths.map{|e| e.path }
      end

      def add(entry)
        @paths.delete_if{|e| e.path == entry.path }
        @paths << entry
        if entry.name
          @names.delete_if{|e| e.path == entry.path }
          @names << entry
        end
      end

      def lookup_name(name)
        load_configs!
        unless @names_sorted
          @names.sort! {|a,b| b.name <=> a.name }
          @names_sorted = true
        end
        @names.find do |e|
          name.start_with?(e.name) &&
            (name.size == e.name.size || name[e.name.size] == '/')
        end
      end

      def lookup_path(path)
        load_configs!
        unless @paths_sorted
          @paths.sort! {|a,b| b.path <=> a.path }
          @paths_sorted = true
        end
        @paths.find do |e|
          path.start_with?(e.path) &&
            (path.size == e.path.size || path[e.path.size] == '/')
        end
      end

      def load_configs!
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
