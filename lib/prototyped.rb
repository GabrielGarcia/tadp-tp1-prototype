module Prototyped

  def set_property(property_name, value)
    singleton_class.send(:define_method,
                          "#{property_name}=",
                          proc { |new_value| instance_variable_set "@#{property_name}".to_sym, new_value } )

    singleton_class.send(:define_method,
                          property_name,
                          proc { instance_variable_get("@#{property_name.to_s}") })

    send("#{property_name}=".to_sym, value)
  end

  def set_method(method_name, proc)
    singleton_class.send(:define_method,
                         "#{method_name}_get_proc".to_sym,
                         Proc.new { proc })

    singleton_class.send(:define_method,
                         method_name,
                         proc)
  end

  def set_prototype(prototype)
    set_property(:prototype, prototype)
    set_prototype_instanse_variables(prototype.instance_variables)
  end

  def set_prototype_instanse_variables(instance_variables)
    instance_variables.each { |v| set_property(v[1..-1], nil) }
  end

  def method_missing(method_name, *arguments, &block)
    call_protype_method(method_name, *arguments, &block) || super
  end

  def call_protype_method(method_name, *arguments, &block)
    set_prototype_instanse_variables(@prototype.instance_variables - self.instance_variables)
    set_method(method_name, @prototype.send("#{method_name}_get_proc".to_sym))
    send(method_name, *arguments)
  end

  def respond_to_missing?(method_name, include_private = false)
    @prototype.methods.include? method_name || super
  end
end



