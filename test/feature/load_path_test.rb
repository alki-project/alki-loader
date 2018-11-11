require 'alki/feature_test'

describe 'Load Path' do
  describe 'that contains a symlink' do
    before do
      @dir = Dir.mktmpdir('alki-loader-test')
      dir_lib = File.join(@dir,'lib')
      FileUtils.ln_s example_lib_path, dir_lib
      setup_example dir_lib
    end

    after do
      unload_example
      FileUtils.rmtree @dir
    end

    it 'should still be able to load builders' do
      Alki::Support.load('example/files/three').must_equal :three
    end
  end

  describe 'that contains a directory which does not exist' do
    before do
      @non_existent_dir = File.join(example_lib_path,'not_real_dir')
      $LOAD_PATH.unshift @non_existent_dir
      setup_example
    end

    after do
      $LOAD_PATH.delete @non_existent_dir
      unload_example
      undef_const :Example
    end

    it 'should still be able to load builders' do
      Alki::Support.load('example/files/three').must_equal :three
    end
  end
end
