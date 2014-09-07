module Prototyped
  
  def set_property(property_name, value)
    set_method("#{property_name}=", proc { |new_value| instance_variable_set "@#{property_name}".to_sym, new_value })
    set_method(property_name, proc { instance_variable_get("@#{property_name.to_s}") })
    send("#{property_name}=".to_sym, value)
  end

  def set_method(method_name, proc)
    self.singleton_class.send(:define_method, method_name, proc)
  end

  def set_prototype(prototype)
    set_property(:prototype, prototype)
  end

  def call_prototype_method(*arguments, proc)
    proc.call(*arguments)
  end

  def method_missing(method_name, *arguments, &block)
    call_prototype_method(*arguments, @prototype.method(method_name).to_proc) || super
  end 
  
  def respond_to_missing?(method_name, include_private = false)
    @prototype.methods.include? method_name || super 
  end
end
