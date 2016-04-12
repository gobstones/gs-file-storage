CustomEventTarget = ->
    
    # Callbacks map, key = eventName
    # values = callbacks to execute
    @actions = {}

    # Method to add a callback to a specific
    # event
    # param {name}: a string name for a event
    # param {action}: function to execute
    # return: void
    @subscribe = (name, action) ->
      if not @actions[name]
        @actions[name] = []
      @actions[name].push action

    # Like suscribe but corresponds to html5 events api
    @addEventListener = (name, action) ->
      @subscribe(name, action)
    
    # Call all the functions that correspond
    # to a given key (name) in the actions attribute 
    # param {name}: a key name, string
    # param {data}: data to pass via parameter to each function
    # return: void 
    @trigger = (name, data) ->
      actions = @actions[name]
      if actions
        _i = 0
        _len = actions.length
        while _i < _len
          action = actions[_i]
          action data
          _i++

    # Call every callBack saved to event.name
    # and pass event as parameter
    # param {evento}: a html event
    # return: void
    @dispatchEvent = (evento) ->
      # this is necesary to defnne target of
      # custom event point to self.
      Object.defineProperty(evento, "target", 
        value : @,
        writable : false,
        enumerable : true,
        configurable : true
      )
      @trigger evento.type, evento


    # Remove callback from event callbacks
    # param {name}: a string name for a event
    # param {action}: function to remove
    # return: void
    @removeEventListener = (name, action) ->
      actions = @actions[name]
      if actions
        exist = actions.indexOf(action)
        if exist > -1
          actions.splice(index, 1)
