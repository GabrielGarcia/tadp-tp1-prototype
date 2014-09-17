require 'spec_helper'
require 'prototyped_object'

describe 'PrototypedObject' do

  let(:prototype) { PrototypedObject.new }
  let(:prototyped) { PrototypedObject.new }
  let(:property) { :new_property }
  let(:value) { 50 }
  let(:method) { :new_method }
  let(:block) { proc { puts 'test bloc' } }

  context 'when a new property is added through set_property' do

    before { prototype.set_property(property, value) }
        
    it 'creates an instance variable' do  
      expect(prototype.instance_variables).to include("@#{property}".to_sym)
    end     

    it 'creates an accessor' do
      expect(prototype.methods).to include(property)
    end

    it 'has the given value' do
      expect(prototype.send(property)).to eq(value)
    end
  end

  context 'when a new method is added through set_method' do
    
    before { prototype.set_method(method, block) }
    
    it 'creates the method' do
      expect(prototype.respond_to? method).to be_truthy
    end
  end

  context 'when an instance is prototyped through set_prototype' do
    before { prototyped.set_prototype(prototype) }

    it 'implements its prototype methods' do
      prototype.set_method(method, block)
      expect(prototyped.respond_to? method).to be_truthy
    end
    
  end

end
