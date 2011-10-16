class BaseDrop < Liquid::Drop
  def initialize(object)
    @object = object unless object.respond_to?(:visible?) && !object.visible?
  end
  attr_reader :object

  # Defines a Liquid method on the drop that is allowed to call the
  # Ruby method directly. Best used for attributes.
  #
  # Based on Module#liquid_methods
  def self.allowed_methods(*allowed_methods)
    class_eval do
      allowed_methods.each do |sym|
        define_method sym do
          @object.send(:try, sym)
        end
        liquid_keys << sym
      end
    end
  end

  def invoke_drop(method_or_key)
    # make sure we only allow explicitly allowed methods, don't provide
    # default or internal methods to the frontend liquid.
    if self.class.liquid_keys.include? method_or_key.to_s.to_sym
      super
    else
      before_method(method_or_key)
    end
  end
  alias :[] :invoke_drop

  def self.liquid_keys
    @liquid_keys ||= [:liquid_keys]
  end

  def liquid_keys
    self.class.liquid_keys.collect(&:to_s).sort
  end
end
