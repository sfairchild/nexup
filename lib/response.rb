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
  def initialize
    super
    @response = {
      text: 'Please wait while we get in position and create some awesomeness',
      response_type: 'in_channel'
    }
  end
end

class HelpResponse < Response
  def initialize
    games = Game.all.map(&:name)
    @response = {
      text: "You can request and of the following games: #{games.join(', ')},"
    }
  end
end

class GifResponse < Response
  def initialize(filename)
    @response = {
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
    }
  end
end

class DefaultGifResponse < Response
  def initialize(filename)
    @response = {
      text: "<http://nexup-hackathon.ngrok.io/images/gifs/#{filename}|Current game room status!!!>",
      attachments: [
        {
          title: 'Do you want to select a game?',
          callback_id: 'http://nexup-hackathon.ngrok.io/play',
          fallback: 'You device does not support this type of message',
          actions: [
            {
              name: 'game_options',
              text: 'Pick a game...',
              type: 'select',
            }
          ]
        }
      ]
    }
    # @response[:attachments][0][:actions][0][:options] = Game.all.map{|game| { text: game.name, value: game.name } }
  end
end
