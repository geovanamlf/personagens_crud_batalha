require 'sinatra'
require 'json'

require_relative 'classes'
require_relative 'racas'
require_relative 'armas'
require_relative 'crud'

require 'sinatra/reloader' if development?

set :port, 4567


get '/' do
  redirect '/personagens'
end

get '/personagens' do
  @personagens = carregar_personagens
  erb :lista
end
require 'sinatra/reloader' if development?

get '/novo' do
  @classes = CLASSES.keys
  @racas = RAÇAS.keys
  @armas = ARMAS.keys
  erb :novo
end

post '/personagens' do
  nome = params[:nome]
  raca = params[:raca]
  classe = params[:classe]
  arma1 = params[:arma1]
  arma2 = params[:arma2]

  personagens = carregar_personagens
  id = gerar_id(personagens)

  personagem = Personagem.new(id, nome, raca, classe, arma1, arma2)

  personagens << personagem.to_h
  salvar_personagens(personagens)

  redirect '/personagens'
end

get '/batalha' do
  @personagens = carregar_personagens
  erb :batalha
end

post '/batalha' do
  personagens = carregar_personagens

  id1 = params[:id1].to_i
  id2 = params[:id2].to_i

  if id1 == id2
    return "Selecione dois personagens diferentes."
  end

  p1 = buscar_personagem_por_id(id1)
  p2 = buscar_personagem_por_id(id2)

  if p1.nil? || p2.nil?
    return "IDs inválidos."
  end

  @lutador1 = p1.dup
  @lutador2 = p2.dup
  @log = []

  ordem = [@lutador1, @lutador2].sort_by { |p| -p[:velocidade] }

  while @lutador1[:vida] > 0 && @lutador2[:vida] > 0
    atacante, defensor = ordem

    tipo = atacante[:inteligencia] > atacante[:forca] ? :inteligencia : :forca
    dano_bruto = atacante[tipo] - defensor[:defesa]
    dano = dano_bruto > 0 ? dano_bruto : 5

    defensor[:vida] -= dano
    defensor[:vida] = 0 if defensor[:vida] < 0

    @log << "#{atacante[:nome]} ataca com #{tipo} causando #{dano} de dano. #{defensor[:nome]} agora tem #{defensor[:vida]} de vida."

    break if defensor[:vida] <= 0

    ordem.reverse!
  end

  @vencedor = @lutador1[:vida] > 0 ? @lutador1 : @lutador2

  erb :resultado_batalha
end

get '/personagens/:id/deletar' do
  id = params[:id].to_i
  personagens = carregar_personagens
  personagem = personagens.find { |p| p[:id] == id }

  if personagem
    personagens.reject! { |p| p[:id] == id }
    salvar_personagens(personagens)
    redirect '/personagens'
  else
    "Personagem não encontrado."
  end
end
