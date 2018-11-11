require 'alki/loader'

Alki::Test.feature_exec do
  def example_path
    File.expand_path('../fixtures/example',__FILE__)
  end

  def example_lib_path
    File.join(example_path,'lib')
  end

  def setup_example(lib_dir=example_lib_path)
    @example_lib_dir = lib_dir
    $LOAD_PATH.unshift lib_dir
  end

  def unload_example
    $LOADED_FEATURES.delete_if do |path|
      path.start_with? example_lib_path
    end
    $LOAD_PATH.delete @example_lib_dir
    undef_const :Example
  end

  def undef_const(const)
    if Object.const_defined? const
      Object.send :remove_const, const
    end
  end
end

