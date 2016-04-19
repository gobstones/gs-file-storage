Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    files:
      type: []
      value: []
    fileDemoName: 
      type: String
    fileDemoText:
      type: String

  listeners:
    'openFile': 'openFile'
    'removeFile' : 'removeFile'

  ready: ->
    @storage = GsFileSystem("gsFiles")

    @makeFilesForFileExplorer(@storage.getAllFilesName())

    # When list change triggered refresh fileList
    @storage.addEventListener('listchange', 
      (event)=>
        @makeFilesForFileExplorer(@storage.getAllFilesName())
    )

    @listen(@$.openedFileForm, 'submitFile', 'saveFile')
    
    # @listen(@$.openedFileForm, 'submitFile', 'saveOpenedFile')

  # saveFile: (polymerEvent)->

  saveFile: (polymerEvent)->
    eventFile = polymerEvent.detail.file

    fileToStorage = @storage.open(eventFile.name, @)

    # When file is saved trigger change event
    fileToStorage.save(eventFile.content, @)

  makeFilesForFileExplorer: (filesNamesList)->
    filesNames = filesNamesList
    @files = []
    for fName in filesNames
      @push('files',
        name: fName 
        content: ""
      )

  openFile:(polymerEvent)->
    
    fileName = polymerEvent.detail.file.name
    @fileDemo = @storage.open(fileName, @)
    
    @set('fileDemoName', @fileDemo.getName())
    @set('fileDemoText', @fileDemo.getContent())

    @fileDemo.addEventListener('change', (event)=>
      if event.host isnt @
        newFile = event.target 
        @fileDemoText = newFile.getContent()
    )

    @fileDemo.addEventListener('fileremove', (event)=>
      @fileDemoText = null
      @fileDemoName = null
    )

  removeFile: (polymerEvent)->
    fileName = polymerEvent.detail.file.name
    @storage.removeFile(fileName)
