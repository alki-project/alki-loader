module Kernel
  alias_method :__alki_loader_original_require, :require

  def require(name)
    __alki_loader_original_require name
  rescue LoadError => e
    translated = Alki::Loader.translate(name)
    if translated
      __alki_loader_original_require translated
    else
      raise e
    end
  end

  def Alki(builder=nil,data=nil,&blk)
    if blk
      path = caller_locations(1,1)[0].absolute_path
      Alki::Loader.build path, builder, data, &blk
    end
    ::Alki
  end
end
