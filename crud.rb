require 'json'
require_relative 'personagem'

DATABASE_PATH = 'database.json'

def carregar_personagens
  if File.exist?(DATABASE_PATH)
    JSON.parse(File.read(DATABASE_PATH), symbolize_names: true)
  else
    []
  end
end

def salvar_personagens(personagens)
  File.write(DATABASE_PATH, JSON.pretty_generate(personagens))
end

def gerar_id(personagens)
  personagens.empty? ? 1 : personagens.map { |p| p[:id] }.max + 1
end

def criar_personagem
  personagens = carregar_personagens

  print "Nome do personagem: "
  nome = gets.chomp

  puts "Raças disponíveis: #{RAÇAS.keys.join(', ')}"
  print "Raça: "
  raca = gets.chomp.downcase

  puts "Classes disponíveis: #{CLASSES.keys.join(', ')}"
  print "Classe: "
  classe = gets.chomp.downcase

  puts "Armas disponíveis: #{ARMAS.keys.join(', ')}"
  print "Primeira arma: "
  arma1 = gets.chomp.downcase
  print "Segunda arma: "
  arma2 = gets.chomp.downcase

  id = gerar_id(personagens)

  personagem = Personagem.new(id, nome, raca, classe, arma1, arma2)
  personagens << personagem.to_h

  salvar_personagens(personagens)

  puts "\nPersonagem '#{nome}' criado com sucesso!\n"
end

def listar_personagens
  personagens = carregar_personagens
  if personagens.empty?
    puts "Nenhum personagem cadastrado."
  else
    personagens.each do |p|
      puts "[#{p[:id]}] #{p[:nome]} - #{p[:classe].capitalize} #{p[:raca].capitalize}"
    end
  end
end

def deletar_personagem
  personagens = carregar_personagens
  print "ID do personagem a deletar: "
  id = gets.chomp.to_i

  antes = personagens.size
  personagens.reject! { |p| p[:id] == id }

  if personagens.size < antes
    salvar_personagens(personagens)
    puts "Personagem removido."
  else
    puts "ID não encontrado."
  end
end

def buscar_personagem_por_id(id)
  carregar_personagens.find { |p| p[:id] == id }
end
