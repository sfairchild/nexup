class Response
  def initialize(options={})
    @options = options
    @response = {}
  end

  def gif_response
    @response[:text] = "<http://nexup-hackathon.ngrok.io/images/gifs/#{options['filename']}|Current game room status!!!>"

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
  end
end

class GifResponse < Response

end
