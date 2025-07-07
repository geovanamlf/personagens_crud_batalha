require_relative "racas"
require_relative "classes"
require_relative "armas"

class Personagem
  attr_accessor :id, :nome, :raca, :classe, :arma1, :arma2
  attr_accessor :vida, :forca, :defesa, :inteligencia, :velocidade

  def initialize(id, nome, raca, classe, arma1, arma2)
    @id = id
    @nome = nome
    @raca = raca.downcase
    @classe = classe.downcase
    @arma1 = arma1.downcase
    @arma2 = arma2.downcase

    raise "Raça inválida" unless RAÇAS.key?(@raca)
    raise "Classe inválida" unless CLASSES.key?(@classe)
    raise "Arma inválida" unless ARMAS.key?(@arma1) && ARMAS.key?(@arma2)

    aplicar_atributos_base
    aplicar_modificadores_de_raca
    aplicar_bonus_das_armas
  end

  def aplicar_atributos_base
    base = CLASSES[@classe]
    @vida = base[:vida]
    @forca = base[:forca]
    @defesa = base[:defesa]
    @inteligencia = base[:inteligencia]
    @velocidade = base[:velocidade]
  end

  def aplicar_modificadores_de_raca
    mods = RAÇAS[@raca]
    @vida = (@vida + (@vida * mods[:vida])).to_i
    @forca = (@forca + (@forca * mods[:forca])).to_i
    @defesa = (@defesa + (@defesa * mods[:defesa])).to_i
    @inteligencia = (@inteligencia + (@inteligencia * mods[:inteligencia])).to_i
    @velocidade = (@velocidade + (@velocidade * mods[:velocidade])).to_i
  end

  def aplicar_bonus_das_armas
    [@arma1, @arma2].each do |arma|
      bonus = ARMAS[arma]
      @forca += bonus[:forca]
      @inteligencia += bonus[:inteligencia]
      @velocidade += bonus[:velocidade]
    end
  end

  def to_h
    {
      id: @id,
      nome: @nome,
      raca: @raca,
      classe: @classe,
      arma1: @arma1,
      arma2: @arma2,
      vida: @vida,
      forca: @forca,
      defesa: @defesa,
      inteligencia: @inteligencia,
      velocidade: @velocidade
    }
  end
end
