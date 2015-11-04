require 'sinatra'
require_relative './init/models'

set :port, 3002

get '/' do
  @concerts = Concert.all
  erb :index
end