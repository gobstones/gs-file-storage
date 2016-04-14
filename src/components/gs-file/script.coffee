GSFILE = do ->

  # Representates A File for the file system in gobstones-web
  _content = ""
  _name = ""
  constructor = (name) ->
    CustomEventTarget.apply @
    _name = name
    
    # Initialize GsFileStorage service
    @_storage = GsFileStorage()

    # Saves the file changes into localStorage
    # and notify the change
    # @param {content}: the file content to save
    # @param {host}: the trigger of the event, may be undefined
    # @return: void
    @save =(content, host) ->
      _content = content
      @_storage.storageFile(@)
      @_fire("change", host)

    # Trigger event using distpatchEvent of custom event target
    # param {eventName}: string, event Name
    # param {host}: the object that is responsible for firing the event 
    # return: void
    @_fire = (eventName, host)->
      evnt = document.createEvent('CustomEvent')
      evnt.initEvent eventName, true, true
      evnt.host = host
      @dispatchEvent(evnt)

    # Remove file listeners
    # return: void
    @remove = ->
        @actions = {}
      @_fire("fileremove")

    @getName = ->
      _name

    @getContent = ->
      _content

    @setContent = (string)->
      _content = string

    @update = (string, host)->
      _content = string
      @_fire("change", host)

    @getData = ->
      {name: _name, content: _content}

    @

  constructor
