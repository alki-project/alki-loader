class ExampleBuilder
  def self.build(data,&blk)
    Alki::Support.create_constant data[:constant_name], blk.call
  end
end
