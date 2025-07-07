require_relative 'crud'
require_relative 'batalha'

def menu
  loop do
    puts "\n=== MENU PRINCIPAL ==="
    puts "1 - Criar novo personagem"
    puts "2 - Listar personagens"
    puts "3 - Deletar personagem"
    puts "4 - Simular batalha"
    puts "0 - Sair"
    print "> "

    escolha = gets.chomp

    case escolha
    when "1"
      criar_personagem
    when "2"
      listar_personagens
    when "3"
      deletar_personagem
    when "4"
      simular_batalha
    when "0"
      puts "Encerrando o programa."
      break
    else
      puts "Opção inválida. Tente novamente."
    end
  end
end

menu
