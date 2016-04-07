GSFILE = do ->

  # Representates A File for the file system in gobstones-web

  constructor = (name) ->
    CustomEventTarget.apply @
    @data = 
      name: name
      content: ""
    
    # Initialize GsFileStorage service
    @_storage = GsFileStorage()

    # Saves the file changes into localStorage
    # and notify the change
    # return: void
    @saveIt = ->
      try
        @_storage.storageFile(@)
      catch saveFileError
        console.log "#{saveFileError}"
      @fire("change", @)

    # Trigger event using distpatchEvent of custom event target
    # param {eventName}: string, event Name
    # param {host}: the object that is responsible for firing the event 
    # return: void

    # add from in event firing to know what object
    # trigger the event
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
      @data.name

    @getContent = ->
      @data.content

    @setName = (string)->
      @data.name = string

    @setContent = (string)->
      @data.content = string

    @getData = ->
      @data

    @

  constructor
