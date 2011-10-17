module ChiliProject
  module Liquid
    module LiquidExt
      ::Liquid::Block.send(:include, Block)
    end
  end
end
