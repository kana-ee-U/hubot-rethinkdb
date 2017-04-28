try
  {Robot,Adapter,TextMessage,User} = require 'hubot'
catch
  prequire = require('parent-require')
  {Robot,Adapter,TextMessage,User} = prequire 'hubot'

@rethinkdbdash_host = if process.env.RETHINKDB_HOST? then ['{ \"host\" : \"',process.env.RETHINKDB_HOST,'\"}'].join("") else '{}'
@inline_configuration=JSON.parse @rethinkdbdash_host
# Configure thinky with host or config file, whatever is provided
thinky = require('thinky')(if process.env.RETHINKDBDASH_CONFIG_FILE? then require(process.env.RETHINKDBDASH_CONFIG_FILE) else @inline_configuration)


class RethinkdbAdapter extends Adapter

  constructor: ->
    super
    @robot.logger.debug "Constructor"
    @type = thinky.type
    @Message = thinky.createModel("Message", {
      message: @type.string(),
      username: @type.string()
    });

  send: (envelope, strings...) ->
    @robot.logger.debug "Send"
    @robot.logger.debug "#{str}" for str in strings
    # Create a new post
    @msg = new @Message({
      message: strings.join('\n'),
      username: @robot.name
    })
    @msg.saveAll()

  reply: (envelope, strings...) ->
    @robot.logger.debug "Reply"
    @robot.logger.debug "#{str}" for str in strings
    @send envelope, strings

  receive_done: (feed) ->
    feed.each (error, message) =>
      if error
        @robot.logger.error error
      if message  and  message.username isnt  @robot.name
        user = new User 1001, name: message.username, room: 'room 1'
        hubot_message = new TextMessage user, message.message, message.id
        @robot.receive hubot_message

  run: ->
    @robot.logger.debug "Run"
    @emit "connected"
    @Message.changes().then(
      (feed) => @receive_done feed
    ).error( @robot.logger.error )


exports.use = (robot) ->
  new RethinkdbAdapter robot
