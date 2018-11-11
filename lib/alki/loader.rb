require 'alki/support'
require 'alki/loader/registry'
require 'alki/loader/entry'
require 'alki/loader/core_ext/kernel'

module Alki
  module Loader
    LoaderError = Class.new(StandardError)

    @registry = Alki::Loader::Registry.new

    def self.registered_paths
      @registry.paths
    end

    def self.translate(name)
      entry = @registry.lookup_name(name)
      if entry
        entry.path + name[entry.name.size..-1]
      end
    end

    def self.lookup_name(path)
      path_name @registry.lookup_path(path), path
    end

    def self.build(path,builder=nil,data=nil,&blk)
      entry = @registry.lookup_path(path)
      unless entry
        raise LoaderError.new("No path registered for #{path}")
      end
      builder ||= entry.data[:builder]
      unless builder
        raise LoaderError.new("No builder registered for #{path}")
      end
      name = path_name(entry, path) or
        raise LoaderError.new("Path not registered with name or in $LOAD_PATH #{path}")
      data ||= entry.data
      builder = Alki::Support.load builder
      builder.build data.merge(name: name, constant_name: Alki::Support.classify(name)), &blk
    end

    def self.register(path,**data)
      unless path.start_with? '/'
        caller_dir = File.dirname(caller_locations(1,1)[0].absolute_path)
        path = File.expand_path(path,caller_dir)
      end
      @registry.add Entry.new(path,data)
    end

    private

    def self.path_name(entry,path)
      if entry && entry.name
        name = entry.name + path[entry.path.size..-1]
      else
        dir = load_dir_for_path path
        unless dir
          return nil
        end
        name = path[File.join(dir,'').size..-1]
      end
      name.chomp!('.rb')
      name
    end

    def self.load_dir_for_path(path)
      $LOAD_PATH.each do |dir|
        if Dir.exist? dir
          real_dir = File.realpath dir
          return real_dir if path.start_with?(File.join(real_dir,''))
        end
      end
      nil
    end
  end
end
