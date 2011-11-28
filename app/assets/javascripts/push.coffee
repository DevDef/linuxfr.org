#= require eventsource

$ = window.jQuery

class Push
  constructor: (@chan) ->
    @callbacks = {}

  on: (kind, callback) ->
    @callbacks[kind] = callback
    @

  start: ->
    setTimeout( =>
      source = new EventSource("/b/#{@chan}")
      source.addEventListener "message", @onMessage
      source.addEventListener "error",   @onError
    , 5000)

  onMessage: (e) =>
    try
      msg = $.parseJSON e.data
      fn  = @callbacks[msg.kind]
      fn msg  if fn?
    catch err
      console.log err  if window.console

  onError: (e) =>
    console.log "onError", e  if window.console

pushs  = []
$.push = (chan) ->
  pushs[chan] ||= new Push(chan)
