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
      try
        _content = content
        @_storage.storageFile(@)
      catch saveFileError
        console.log "#{saveFileError}"
      @fire("change", host)

    # Trigger event using distpatchEvent of custom event target
    # param {eventName}: string, event Name
    # param {host}: the object that is responsible for firing the event 
    # return: void
    @fire = (eventName, host)->
      evnt = document.createEvent('CustomEvent')
      evnt.initEvent eventName, true, true
      evnt.host = host
      @dispatchEvent(evnt)

    # Remove file from Local Storage
    # return: void
    @removeIt = ->
      try
        @_storage.removeFile(name: @name)
      catch removeFileError
        console.log "#{removeFileError}"
      @fire("remove")

    @getName = ->
      _name

    @getContent = ->
      _content

    @setContent = (string)->
      _content = string

    @getData = ->
      {name: _name, content: _content}

    @

  constructor
