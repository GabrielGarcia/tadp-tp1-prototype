require 'spec_helper'
require 'prototyped_object'

describe 'tadp 4.1' do

  it 'Un guerrrero recibe una nueva propiedad' do
    #Inicialización de un guerrero
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)
  end

  it 'Se ataca un clon de un guerrero' do

    #Inicialización de un guerrero
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
                                          if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
                                            otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                                          end
                                        })
    guerrero.set_method(:recibe_danio, proc { |diferencia| self.energia = self.energia - diferencia })
    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
  end

  it 'Se le asigna un prototypo a un espadachin' do
    #Inicialización de un guerrero
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
                                          if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
                                            otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                                          end
                                        })
    guerrero.set_method(:recibe_danio, proc { |diferencia| self.energia = self.energia - diferencia })

    #Inicialización de un espachin
    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia =  30
    espadachin.potencial_defensivo = 10
    espadachin.potencial_ofensivo = 20

    espadachin.set_method(:potencial_ofensivo, proc { @potencial_ofensivo + self.potencial_espada * self.habilidad })

    espadachin.atacar_a(guerrero)
    expect(guerrero.energia).to eq(75)
  end

end
