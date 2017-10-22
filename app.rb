require 'sinatra'
require 'socket'
require 'resolv-replace'
require 'json'
require 'httparty'
require "sinatra/activerecord"
require './lib/angle'
require './lib/game'
require './lib/response'

set :database, {adapter: "sqlite3", database: "nexup.sqlite3"}
set :bind, '0.0.0.0'

before do
  content_type :json
end

get '/' do
  last_gif = Dir.glob("/home/pi/app/public/*.gif").sort.last.gsub(/^.+\//, '')
  "<a href='#{last_gif}'>#{last_gif}</a>"
end

# Initial Command
post '/slack' do
  puts params
  request_text = params['text'].strip.downcase
  return HelpResponse.new.to_json if request_text.match(/help/)

  requested_game = Game.find_by_name(request_text)
  requested_game = Game.default unless requested_game

  Thread.new do
    $stdout.print "./py_scripts/servo.py #{request_game.angle.pivot} #{request_game.angle.zoom_x} #{request_game.angle.zoom_y} #{request_game.angle.zoom_w} #{request_game.angle.zoom_h}\n"

    puts "./py_scripts/gifcam.py #{filename}"

    if requested_game.default?
      HTTParty.post params['response_url'], body: DefaultGifResponse.new(filename).to_json
    else
      HTTParty.post params['response_url'], body: GifResponse.new(filename).to_json
    end
  end

  DefaultResponse.new.to_json
end

post '/play' do
  {
    text: 'Prepair to die',
    replace_original: false,
    response_type: 'In Channel'
  }.to_json
end

get '/ip' do
  ip_address
end

def ip_address
  @ip ||= Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
end

def epoch_timestamp
  Time.now.strftime('%s')
end

def filename
  @filename ||= epoch_timestamp + '.gif'
end

class Game < ActiveRecord::Base
end
