require 'sinatra'
require 'socket'
require 'resolv-replace'
require 'json'
require 'httparty'
require "sinatra/activerecord"
require './lib/angle'
require './lib/game'

set :database, {adapter: "sqlite3", database: "nexup.sqlite3"}
set :bind, '0.0.0.0'

get '/' do
  last_gif = Dir.glob("/home/pi/app/public/*.gif").sort.last.gsub(/^.+\//, '')
  "<a href='#{last_gif}'>#{last_gif}</a>"
end

post '/slack' do
  puts params
  requested_game = Game.find_by_name(params['text'].strip.downcase)
  requested_game = Game.default unless requested_game
  Thread.new do
    `./py_scripts/servo.py #{request_game.angle.pivot} #{request_game.angle.zoom_x} #{request_game.angle.zoom_y} #{request_game.angle.zoom_w} #{request_game.angle.zoom_h}`
    `./py_scripts/gifcam.py #{filename}`
    body = {
      text: "<http://nexup-hackathon.ngrok.io/images/gifs/#{filename}|Current game room status!!!>",
      response_type: 'in_channel',
      attachments: [
        {
          title: 'Do you want to pwn someone?',
          callback_id: 'http://nexup-hackathon.ngrok.io/play',
          fallback: 'You device does not support this type of message',
          actions: [
            {
              name: 'yes',
              text: 'Of course',
              type: 'button'
            }, {
              name: 'no',
              text: 'I will let them live another day',
              type: 'button',
              style: 'danger'
            }
          ]
        }
      ]
    }.to_json

    HTTParty.post params['response_url'], body: body
  end

  content_type :json
  {
    text: 'Please wait while we get in position and create some awesomeness',
    response_type: 'in_channel'
  }.to_json
end

post '/play' do
  content_type :json
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
