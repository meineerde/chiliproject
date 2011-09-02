class BaseDrop < Liquid::Drop
  def initialize(object)
    @object = object unless object.respond_to?(:visible?) && !object.visible?
  end

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
      end
    end
  end

protected
  def object
    @object
  end
end
