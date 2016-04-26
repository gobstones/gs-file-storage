GsFileSystem = (localStorageKey)->
  
  # Service for managing localStorage files
  # Get, create, remove files.
  # trigger events when file change or file removed or file created.
  # use gsFiles as a key in localStorage

  # Method for check if nameSpace is created and
  # service initialized.
  _checkServiceInNameSpace = ->
    window.GS = window.GS or {}
    window.GS.GSFILESYSTEM = 
      window.GS.GSFILESYSTEM or 
      do ->
        methods.initialize() 
        methods

  methods =

    # Method for no use Json api, in case it change
    # @param {item}: any Object
    # @return:object received converted to string
    _strfy:(item)->
      JSON.stringify(item)

    # Method to no use Json api, in case it change.
    # @param {string}: a string with json form parsable to
    # jsvascript type object
    # @return: a javascript type structure
    _parseJs:(string)->
      JSON.parse(string)

    # Remove file from local storage and from fileSystem
    # param {fileName}: a string corresponding to a file name
    # event: fileremove & listchange $ storage
    # return: void
    removeFile:(fileName)->
      getGsFile = @hotFiles.get(fileName)
      if getGsFile
        getGsFile.remove()
        @hotFiles.delete(fileName)
      # Check if file is in @filesNameList, just to avoid
      # refresh @filesNameList if this isnt necessary
      @storage.removeItem(@_storageKeyForUse() + fileName);
      if @filesNameList.indexOf(fileName) isnt -1
        @_fire("listchange")
      
    # Method to validate file name to store.
    # @param {name}: a string
    # @return: true or false if name is valid 
    _fileNameValid:(name)->
      (name isnt undefined and name.match(/[a-zA-Z]/) and name[0] isnt " ")
    
    # Get a file stored or create one.
    # @param {fileName}: a string corresponding to a fileName
    # @host {host}: the object that open the file
    # @return: a GSFILE
    # @except: in case that fileName is invalid 
    open: (fileName, host)->
      if @_fileNameValid(fileName)
        fileExist = @_getFileInMemoryOrLocalStorage(fileName)
        if fileExist
          fileExist.open(@)
          return fileExist
        else
          file = new GSFILE(fileName, localStorageKey)
          @hotFiles.set(file.getName(), file)
          file.open(@)
          @_handleClose(file)
          return file
      else
        throw "Invalid file name."
    
    # Handle file close event when any object is using 
    # file.
    # @param {file} a gs-file to listen for closefile event.
    _handleClose: (file)->
      file.addEventListener('closefile', (event)=>
        file = event.target
        @hotFiles.delete(file.getName())
      )

    # Save file in localStorage
    # @param {gsfile}: a GSFile
    # return: void
    storageFile: (gsFile)->
      filesListChanged = @filesNameList.indexOf(gsFile.getName()) is -1
      @hotFiles.set(gsFile.getName(), gsFile)
      data = gsFile.getData()
      @storage.setItem(@_storageKeyForUse() + gsFile.getName(), @_strfy(data))
      if filesListChanged
        @_fire("listchange")

    # Trigger event using distpatchEvent of custom event target
    # param {eventName}: string, event Name
    # return: void
    _fire: (eventName)->
      evnt = document.createEvent('CustomEvent')
      evnt.initEvent eventName, true, true
      @dispatchEvent(evnt)

    # Check if file exist in localStorage or
    # in hotFiles variable
    # @param {fileName} string
    # #return: a GSFile or null
    _getFileInMemoryOrLocalStorage:(fileName)->
      fileExistJS = @hotFiles.get(fileName)
      if fileExistJS
        console.log fileExistJS.getName()
        return fileExistJS
      existLS = @storage.getItem(@_storageKeyForUse() + fileName)
      if existLS
        parsedFile = @_parseJs(existLS)
        file = new GSFILE(parsedFile.name, localStorageKey)
        file.setContent(parsedFile.content)
        @hotFiles.set(parsedFile.name, file)
        @_handleClose(file)
        return file
    
    # Set in @filesNameList all files names storaged in 
    # localStorge and return this. 
    getAllFilesName:->
      @filesNameList = @_allStorage()
      @filesNameList

    # Return all names of files storaged in localStorage[fileSystemStorageKey]
    _allStorage:->
      keys = Object.keys(@storage)      
      storagedKey = []
      for key in keys
        if key.lastIndexOf(@_storageKeyForUse(), 0) is 0
          storagedKey.push(key.replace(@_storageKeyForUse(), ""))
      storagedKey
    
    # Listen GSFile chenge event in other tabs, and listchange event
    # in other tabs.
    _listenOtherTabsFilesChange:->
      window.addEventListener('storage', (event)=>
        if event.newValue is null
          @removeFile(@_parseJs(event.oldValue).name)
        else
          console.log "storage event in new value something"
          newFile = @_parseJs(event.newValue)
          
          # if file is new in file list
          if @filesNameList.indexOf(newFile.name) is -1
            @filesNameList.push(newFile.name)
            @_fire("listchange")
          else
            # if file is opened
            if @hotFiles.get(newFile.name)
              @hotFiles.get(newFile.name).update(newFile.content, @)
      )

    _storageKeyForUse:->
      @_localStorageKey + "."

    # Initialize service, need to be called before call any other method
    # create localStorage key 'gsFiles' in case it has no was created
    initialize: ->
      console.log "initialized"
      CustomEventTarget.apply @
      @storage = window.localStorage
      @hotFiles = new Map()
      @filesNameList = []
      @_listenOtherTabsFilesChange()
      @_localStorageKey = localStorageKey or "GSFiles"
  
  _checkServiceInNameSpace()
  window.GS.GSFILESYSTEM