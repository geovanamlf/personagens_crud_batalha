require 'sinatra'
require 'json'
require_relative 'crud'

set :port, 4567

get '/' do
  redirect '/personagens'
end

get '/personagens' do
  @personagens = carregar_personagens
  erb :lista
end
