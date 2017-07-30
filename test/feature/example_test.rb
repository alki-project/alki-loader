require 'alki/feature_test'

$example_path = File.expand_path('../../fixtures/example',__FILE__)
$LOAD_PATH.unshift File.join($example_path,'lib')

describe 'Example' do
  describe 'one' do
    it 'should use translater and loader' do
      Alki::Support.load('example/files/one').must_equal :one
    end

    it 'lookup should work' do
      name = Alki::Loader.lookup_name File.join($example_path,'files','one.rb')
      name.must_equal 'example/files/one'
    end
  end

  describe 'two' do
    it 'should use translater based on directory' do
      Alki::Support.load('example/files/two').must_equal :two
    end
  end

  describe 'three' do
    it 'should use builder based on directory' do
      Alki::Support.load('example/files/three').must_equal :three
    end

    it 'lookup should work' do
      name = Alki::Loader.lookup_name File.join($example_path,'lib','example','files','three.rb')
      name.must_equal 'example/files/three'
    end
  end
end
