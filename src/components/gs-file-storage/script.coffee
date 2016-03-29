GsFileStorage = ->
  
  # Service for managing localStorage files
  # use gsFiles as a key in localStorage

  # Method for check if nameSpace is created and
  # service initialized.
  _checkServiceInNameSpace = ->
    window.GS = window.GS or {}
    window.GS.GSFILESTORAGE = 
      window.GS.GSFILESTORAGE or 
      do -> 
        methods.initialize() 
        methods

  methods =

    # Method for no use Json api, in case it change
    # @param {item}: any Object
    # @return:object received converted to String 
    _strfy:(item)->
      JSON.stringify(item)
    
    # Method for no use Json api, in case it change.
    # @param {string}: a string with json form parsable to
    # jsvascript type object
    # @return: a javascript type structure
    _parseJs:(string)->
      JSON.parse(string)
    
    # Remove file from local storaga, by removing key map
    # param {fileName}: a string corresponding to a file name
    # exept: no exist a file with name = fileName
    # return: void
    removeFile:(fileName)->
      exist = @hotFiles[fileName]
      if exist
        delete @hotFiles[fileName]
        @storage.setItem('gsFiles', @_strfy(@hotFiles))
      else
        throw "No sutch file with that name."

    # Method to validate file name to store.
    # @param {name}: a string
    # @return: true or false if name is valid 
    _fileNameValid:(name)->
      (name isnt undefined and name.match(/[a-zA-Z]/) and name[0] isnt " ")
    
    # Get a file stored or create one.
    # @param {name}: a string
    # @return: a GSFILE
    # @except: in case that fileName is invalid 
    getFile:(fileName)->
      if @_fileNameValid(fileName)
        fileExist = @_fileExist(fileName)
        if fileExist
          return fileExist
        else
          file = new GSFILE(fileName)
          @storageFile(file)
          return file
      else
        throw "Invalid file name."

    # Save file in localStorage
    # @param {gsfile}: a GSFile
    # return: void
    storageFile:(gsFile)->
      @_changedFileList(gsFile.getName())
      @hotFiles[gsFile.getName()] = gsFile
      data = gsFile.getData()
      @storage.setItem('gsFiles.' + gsFile.getName(), @_strfy(data))

    # Check if hotFiles list changed and trigger a event
    # @param {fileName}: string
    # return: void
    # trigger: listChangedEvent
    _changedFileList:(fileName)->
      if not @hotFiles[fileName]
        console.log "lanzar el evento"
        # triggerear el evento de actualizar la lista de archivos


    # Check if file exist in localStorage or
    # in hotFiles variable
    # @param {fileName} string
    # #return: a GSFile or null
    _fileExist:(fileName)->
      fileExistJS = @hotFiles[fileName]
      if fileExistJS
        return fileExistJS
      existLS = @storage.getItem('gsFiles.' + fileName)
      if existLS
        parsedFile = @_parseJs(existLS)
        file = new GSFILE(parsedFile.name)
        file.setContent(parsedFile.content)
        @hotFiles[fileName] = file
        return file

    # Initialize service, need to be called before call any other method
    # create localStorage key 'gsFiles' in case it has no was created
    initialize: ->
      @storage = window.localStorage
      localStorageFiles = @storage.getItem('gsFiles')
      if (localStorageFiles is undefined ) or (localStorageFiles is null)
        @storage.setItem('gsFiles', '[]')
        @hotFiles = []
      else
        @hotFiles = @_parseJs(localStorageFiles)

  _checkServiceInNameSpace()
  window.GS.GSFILESTORAGE