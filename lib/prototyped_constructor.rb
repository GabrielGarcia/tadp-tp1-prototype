class PrototypedConstructor
  class << self
    def new(prototype, proc = nil )
      Class.new(PrototypedObject) do
        @@prototype =  prototype
        @@initilize_block = proc
        def initialize(*args)
          set_prototype(@@prototype)
          @@initilize_block ? @@initilize_block.call(self, *args) : set_properties(*args)
        end
      end
    end

    def copy(prototype)
      new(prototype, Proc.new { |new_class| new_class.set_properties(prototype_variables(prototype)) })
    end

    def extend()

    end

    def prototype_variables(prototype)
      variables = prototype.instance_variables
      Hash[ variables.map { |variable| [variable[1..-1].to_sym, prototype.send(variable[1..-1].to_sym)] }]
    end
  end
end

