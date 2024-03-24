require 'discordrb'
require 'dotenv'

Dotenv.load('./.env')

TOKEN = ENV['DISCORD_BOT_TOKEN']
MEMBERS = ENV['MEMBERS'].split(',')
CHANNEL = '#bot'

bot = Discordrb::Bot.new token: TOKEN

puts "This bot's invite URL is #{bot.invite_url}"
puts 'Click on it to invite it to your server.'
bot.message(from: MEMBERS, in: CHANNEL) do |event|
  p event
  event.respond "Event handler was activated!"
end

bot.message(from: not!(MEMBERS), in: CHANNEL) do |event|
  event.respond 'Only authorized members can control my server.'
end

bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
