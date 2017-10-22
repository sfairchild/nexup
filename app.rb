require 'sinatra'
require 'socket'
require 'faker'
require 'resolv-replace'
require 'json'
require 'httparty'
require "sinatra/activerecord"
require './lib/angle'
require './lib/game'
require './lib/response'
require './lib/battle'
require './lib/battle_user'

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
  battle = Battle.where("lower(name) LIKE lower(?)", "%#{request_text}%").last unless requested_game || request_text.empty?

  unless battle || requested_game
    requested_game = Game.default
  end

  unless battle
    Thread.new do
      filename = epoch_timestamp + '.gif'
      `./py_scripts/servo.py #{requested_game.angle.pivot}`

      `./py_scripts/gifcam.py #{filename} #{requested_game.angle.zoom_x} #{requested_game.angle.zoom_y} #{requested_game.angle.zoom_w} #{requested_game.angle.zoom_h}`

      if requested_game.default?
        HTTParty.post params['response_url'], body: DefaultGifResponse.new(filename).to_json
      else
        HTTParty.post params['response_url'], body: GifResponse.new(filename, requested_game.name).to_json
      end
    end
  end

  (battle ? BattleListResponse.new(battle) : DefaultResponse.new(requested_game)).to_json
end

post '/play' do
  puts JSON.parse(params['payload'])
  payload = get_payload(JSON.parse(params['payload']))
  puts 'PAYLOAD'
  puts payload
  send(payload[:action], payload)
end

get '/ip' do
  ip_address
end

def game_on(values)
  content_type :json
  begin
    battle = Battle.find(values[:battle])
    battle_user = BattleUser.create(user_name: values[:user], battle: battle, in: (values[:value] == 'yes'))
    if battle_user.save
      return (values[:value] == 'yes' ? JoinedGameResponse.new(values[:user], battle) : NoGameResponse.new(values[:user], battle)).to_json
    end
  rescue ActiveModel::Errors => e
    e
  end
  200
end

def new_game(value)
  (value[:value] == 'yes' ? SelectGameResponse.new : OhWellResponse.new).to_json
end

def select_game(values)
  NewGameResponse.new(values[:value]).to_json
end

def ip_address
  @ip ||= Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
end

def epoch_timestamp
  Time.now.strftime('%s')
end

def get_payload(response)
  payload = {}
  payload[:action] = response['callback_id'].match(/(^.+?)\//)[1].to_sym
  payload[:value] = response['actions'][0]['selected_options'] ? response['actions'][0]['selected_options'][0]['value'] : response['actions'][0]['name']
  payload[:user] = response['user']['name']

  battle = response['callback_id'].match(/^.+\/.+\/(.+)/)
  payload[:battle] = battle[1] if battle

  payload
end
