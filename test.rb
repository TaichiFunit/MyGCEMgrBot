require 'dotenv'
require './server.rb'

Dotenv.load('./.env')

server = Server.new

p server.status

p server.stop
