class Response
  def initialize(options={})
    @options = options
    @response = {}
  end

  def to_json
    @response.to_json
  end
end

class DefaultResponse < Response
  def initialize(game)
    super
    @response = {
      text: 'Please wait while we get in position and create some awesomeness'
    }
    @response[:response_type] = 'in_channel' unless game.default?
  end
end

class HelpResponse < Response
  def initialize
    games = Game.available.map(&:name)
    @response = {
      text: "You can request and of the following games: #{games.join(', ')},"
    }
  end
end

class GifResponse < Response
  def initialize(filename, game)
    battle = Battle.create(game: Game.find_by_name(game))
    @response = {
      text: "<http://nexup-hackathon.ngrok.io/images/gifs/#{filename}|Current game room status!!!>",
      response_type: 'in_channel',
      attachments: [
        {
          title: "#{battle.name} was created \n Do you want to pwn someone in #{game}?",
          callback_id: "game_on/#{game}/#{battle.id}",
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
    }
  end
end

class DefaultGifResponse < Response
  def initialize(filename)
    @response = {
      text: "<http://nexup-hackathon.ngrok.io/images/gifs/#{filename}|Current game room status!!!>",
      attachments: [
        {
          title: 'Do you want to play a game?',
          callback_id: "new_game/",
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
    }
    @response[:attachments][0][:actions][0][:options] = Game.available.map{|game| { text: game.name, value: game.name } }
  end
end

class OhWellResponse < Response
  def initialize
    @response = {
      text: 'Maybe later'
    }
  end
end

class SelectGameResponse < Response
  def initialize
    games = Game.available.map {|game| {text: game.name, value: game.name} }
    @response = {
      text: 'Ok',
      replace_original: true,
      attachments: [
        {
          text: "What game do you want to play?",
          callback_id: 'select_game/',
          fallback: 'You device does not support this type of message',
          actions: [
            {
              text: 'Select a game...',
              name: 'games',
              type: 'select',
              options: games
            }
          ]
        }
      ]
    }
  end
end

class JoinedGameResponse < Response
  def initialize(user, battle)
    @response = {
      response_type: 'in_channel',
      replace_original: false,
      text: "<@#{user}> joined in the #{battle.name}, may God have mercy on his soul"
    }
  end
end

class NoGameResponse < Response
  def initialize(user, battle)
    @response = {
      response_type: 'in_channel',
      replace_original: false,
      text: "@#{user} is out of the #{battle.name}, guess they couldn't handle the preasure"
    }
  end
end

class NewGameResponse < Response
  def initialize(game)
    battle = Battle.create(game: Game.find_by_name(game))
    @response = {
      text: "The #{battle.name} was just created.",
      replace_original: false,
      response_type: 'in_channel',
      attachments: [
        {
          title: "Do you want to pwn someone in #{game}?",
          callback_id: "game_on/#{game}/#{battle.id}",
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
    }
  end
end
