require 'discordrb'
require 'dotenv'
require './lib/gce_instance.rb'

Dotenv.load('./.env')

TOKEN = ENV['DISCORD_BOT_TOKEN']
MEMBERS = ENV['MEMBERS'].split(',')
CHANNEL = ENV.fetch('CHANNEL', '#pal-bot')

ADMIN_COMMANDS = %w(start stop)
STD_COMMANDS = %w(status)

bot = Discordrb::Bot.new token: TOKEN
instance = GCEInstance.new

puts "This bot's invite URL is #{bot.invite_url}"
puts 'Click on it to invite it to your server.'

bot.message(in: CHANNEL) do |event|
  message = event.message.content

  if STD_COMMANDS.include?(message)
    res = case event.message.content
      when 'status' then server.status
    end

    event.respond res
  end
end

bot.message(from: MEMBERS, in: CHANNEL) do |event|
  message = event.message.content

  if ADMIN_COMMANDS.include?(message)
    res = case message
      when 'start' then server.invoke
      when 'stop'  then server.stop
    end

    event.respond res
  end
end

bot.message(from: not!(MEMBERS), in: CHANNEL) do |event|
  message = event.message.content

  if ADMIN_COMMANDS.include?(message)
    event.respond 'Only authorized members can operate my server.'
  end
end

bot.run
