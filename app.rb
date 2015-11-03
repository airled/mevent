require 'sinatra'
require_relative './init/models'

get '/' do
  @concerts = Concert.all
  erb :index
end