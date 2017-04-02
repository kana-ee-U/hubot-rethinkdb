try
  {Robot,Adapter,TextMessage,User} = require 'hubot'
  thinky = require('thinky')({'host':'172.17.0.2'})
catch
  prequire = require('parent-require')
  {Robot,Adapter,TextMessage,User} = prequire 'hubot'
  thinky = require('thinky')({'host':'172.17.0.2'})

class RethinkdbAdapter extends Adapter

  constructor: ->
    super
    @type = thinky.type
    @Message = thinky.createModel("Message", {
      message: @type.string(),
      username: @type.string()
    });
    @robot.logger.info "Constructor"

  send: (envelope, strings...) ->
    @robot.logger.info "Send"
    # console.log "#{str}" for str in strings
    # Create a new post
    @msg = new @Message({
      message: strings.join('\n'),
      username: 'hubot'
    })
    @msg.saveAll()

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply"
    @send envelope, strings

  receive_done: (feed) ->
    feed.each (error, message) =>
      if error
        @robot.logger.error error
      if message  and  message.username isnt 'hubot'
        user = new User 1001, name: message.username, room: 'room 1'
        hubot_message = new TextMessage user, message.message, message.id
        @robot.receive hubot_message

    # console.log "fin   received done "

  run: ->
    @robot.logger.info "Run"
    # console.log @robot
    @emit "connected"
    @Message.changes().then(
      (feed) => @receive_done feed
    ).error( console.log )


exports.use = (robot) ->
  new RethinkdbAdapter robot
