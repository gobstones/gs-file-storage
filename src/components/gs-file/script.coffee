GSFILE = do ->

  # Representates A File for the file system in gobstones-web
  _content = ""
  _name = ""
  _openers = []
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

    # Add host to openers list. Store list of objects that
    # have open this file.
    # param {host}: an object that opened this file
    # return void
    @open = (host)->
      # es necesario tener elementos repetidos ?
      _openers.push(host)

    # Remove host from openers list and fire closefile
    # event to clean memory.
    # param {host}: an object that opened this file
    # return void
    @close = (host)->
      openerIndex = _openers.indexOf(host)
      if openerIndex isnt -1
        _openers.splice(openerIndex, 1)
        if _openers.length() == 0
          @_fire('closefile')

    # Remove file listeners
    # return: void
    @remove = ->
      @_fire("fileremove")
      # TODO: checkear esto con Ale
      @actions = {}

    @getName = ->
      _name

    @getContent = ->
      _content

    @setContent = (string)->
      _content = string

    # Method to set content and fire change event and not
    # fire storage method on window.localStorage.
    # this is usefull because sometimes there is no need
    # to storage again the file.
    # @param {content}: a string content
    # @param {host}: the obj that make the update
    # @return: void.
    @update = (content, host)->
      _content = string
      @_fire("change", host)

    @getData = ->
      {name: _name, content: _content}

    @

  constructor
