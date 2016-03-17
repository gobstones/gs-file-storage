GsFileStorageBehavior = ->
  # Service for managing localStorage files
  # use gsFiles as a key in localStorage

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

    # Add file to localStorage and to temporal list, replace if 
    # exist a file.name equal to given. Also check
    # repeated names files and validate name.
    # @param {file}: an object with the attr name: "string" as minumun
    # @return: void
    # @except: file
    addFile: (file)->
      exist = null
      if @_fileNameValid(file.name)
        console.log
        for storageFile in @hotFiles 
          if storageFile.name is file.name
            exist = storageFile
            break
        if exist
          replaceIndex = @hotFiles.indexOf(exist)
          @hotFiles[replaceIndex] = file
          # tirar evento que cambio el archivo o lo que sea
        else
          @hotFiles.push(file)
        @storage.setItem('gsFiles', @_strfy(@hotFiles))
      else
        throw "Invalid file name."
     
    # Method to validate file name to store.
    # @param {name}: a string
    # @return: true or false if name is valid 
    _fileNameValid:(name)->
      (name isnt undefined and name.match(/[a-zA-Z]/) and name[0] isnt " ")
    
    # Get a file stored.
    # @param {name}: a string
    # @return: a file object
    # @except: in case that no file stored have name = param name
    getFile:(name)->
      for storageFile in @hotFiles 
        if storageFile.name is name
          return storageFile
      throw "No sutch file with that name."

    # Return all files stored in local Storage
    # @return: a list of files
    getAllFiles: ->
      @hotFiles

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
 
  methods.initialize()
  methods