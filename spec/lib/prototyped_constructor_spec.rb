require 'spec_helper'
require 'prototyped_constructor'

describe 'PrototypedConstructor' do

  let(:protype) { PrototypedObject.new }
  let(:protyped_constructor) { PrototypedConstructor.clone }
  let(:proc) { Proc.new { |self_instance, property | self_instance.property = property } }


  context 'when the new method is called with a protype and a proc' do

    let(:constructed_prototype) { protyped_constructor.new(protype, proc) }

    it 'returns a class' do
      expect(constructed_prototype).to respond_to(:class)
    end

/
    it 'adds the prototype to the new class' do
      binding.pry
      expect(constructed_prototype.class_variable_get(:@@prototype)).to be(prototype)
    end

    it 'adds the initialize block to the new class' do
      expect(constructed_prototype.class_variable_get(:@@initilize_block)).to be(proc)
    end
/
  end

end
