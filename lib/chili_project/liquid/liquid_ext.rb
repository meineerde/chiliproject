module ChiliProject::Liquid
  module LiquidExt
    module StripNewlines
      def render_all(list, context)
        # Remove the leading newline in a block's content
        list[0].sub!($/, "") if list[0].start_with?($/)
        super
      end
    end
  end
end

# TODO: This is bad hack which could be alleviated by using either
# alias_method_chain or Module#prepend (http://redmine.ruby-lang.org/issues/1102)
# which is either bad style or not yet available.
::Liquid::Block.instance_eval do
  def inherited subclass
    subclass.send :include, ChiliProject::Liquid::LiquidExt::StripNewlines
  end
end
ObjectSpace.each_object(Class).select{|klass| klass < ::Liquid::Block}.each{|klass|
  klass.send :include, ChiliProject::Liquid::LiquidExt::StripNewlines
}
