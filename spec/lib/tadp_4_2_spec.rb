require 'spec_helper'
require 'prototyped_object'
require 'prototyped_constructor'

describe 'tadp 4.2' do

  let(:guerrero) do
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
    guerrero
  end

  it 'Se inicializa un objeto en base a un prototipo, inicializando su estado con parámetros' do


    Guerrero = PrototypedConstructor.new(guerrero,
     proc do |guerrero_nuevo, una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      guerrero_nuevo.energia = una_energia
      guerrero_nuevo.potencial_ofensivo = un_potencial_ofensivo
      guerrero_nuevo.potencial_defensivo = un_potencial_defensivo
    end )


    un_guerrero = Guerrero.new(100, 30, 10)
    expect(un_guerrero.energia).to eq(100)

  end

  it 'se inicializa un guerrero con un mapa' do

    OtroGuerrero = PrototypedConstructor.new(guerrero)

    un_guerrero = OtroGuerrero.new({ energia: 100, potencial_ofensivo: 30, potencial_defensivo: 10 })
    expect(un_guerrero.potencial_ofensivo).to eq(30)
  end


  it 'Se crea un guerrero mediante Copy' do
    GuerreroCopy = PrototypedConstructor.copy(guerrero)
    un_guerrero = GuerreroCopy.new
    binding.pry
    expect(un_guerrero.potencial_defensivo).to eq(10)
  end

  it 'Se extiende la clase Guerrero' do

/    Espadachin = Guerrero.extended { |espadachin, habilidad, potencial_espada|
      espadachin.set_property(:habilidad, habilidad)
      espadachin.set_property(:potencial_espada, potencial_espada)
      espadachin.set_method(:potencial_ofensivo, proc { @potencial_ofensivo + self.potencial_espada * self.habilidad })
    }

    espadachin = Espadachin.new(100, 30, 10, 0.5, 30)
    expect(espadachin.potencial_ofensivo).to eq(45)
/
  end
end
