require_relative 'crud'

def simular_batalha
  personagens = carregar_personagens

  if personagens.size < 2
    puts "É necessário pelo menos dois personagens para batalhar."
    return
  end

  puts "\n=== Personagens Disponíveis ==="
  listar_personagens

  print "\nID do primeiro personagem: "
  id1 = gets.chomp.to_i
  print "ID do segundo personagem: "
  id2 = gets.chomp.to_i

  if id1 == id2
    puts "Escolha dois personagens diferentes."
    return
  end

  p1 = buscar_personagem_por_id(id1)
  p2 = buscar_personagem_por_id(id2)

  unless p1 && p2
    puts "ID inválido."
    return
  end

  puts "\nIniciando batalha entre #{p1[:nome]} e #{p2[:nome]}..."

  lutador1 = p1.dup
  lutador2 = p2.dup

  ordem = [lutador1, lutador2].sort_by { |p| -p[:velocidade] }

  while lutador1[:vida] > 0 && lutador2[:vida] > 0
    atacante, defensor = ordem

    tipo = atacante[:inteligencia] > atacante[:forca] ? :inteligencia : :forca
    dano_bruto = atacante[tipo] - defensor[:defesa]
    dano = dano_bruto > 0 ? dano_bruto : 5  # mínimo de dano

    defensor[:vida] -= dano

    puts "#{atacante[:nome]} ataca com #{tipo.to_s}, causando #{dano} de dano a #{defensor[:nome]} (vida restante: #{[defensor[:vida], 0].max})"

    break if defensor[:vida] <= 0

    ordem.reverse!
  end

  vencedor = lutador1[:vida] > 0 ? lutador1 : lutador2
  puts "\n🏆 Vitória de #{vencedor[:nome]}!\n"
end
