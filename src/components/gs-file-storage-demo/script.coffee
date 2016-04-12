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

  ready: ->
    @storage = GsFileStorage()

    @makeFilesForFileExplorer(@storage.getAllFilesName())

    # When list change triggered refresh fileList
    @storage.addEventListener('listchange', 
      (event)=>
        @makeFilesForFileExplorer(@storage.getAllFilesName())
    )

    @listen(@$.submit, 'submitFile', 'saveFile')
    
    @listen(@$.openedFileForm, 'submitFile', 'saveOpenedFile')
  
  saveFile: (polymerEvent)->
    eventFile = polymerEvent.detail.file
    fileToStorage = @storage.getFile(eventFile.name)
    
    # When file is saved trigger change event
    fileToStorage.save(eventFile.content, @)

  saveOpenedFile: (polymerEvent)->
    console.log "saveOpenedFile"

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
    @fileDemo = @storage.getFile(fileName)
    
    @fileDemoName = @fileDemo.getName()
    @fileDemoText = @fileDemo.getContent()
    
    @fileDemo.addEventListener('change', (event)=>
      console.log "Entro en el change"
      if event.host isnt @
        console.log "Entro en el if"
        newFile = event.target 
        @fileDemoText = newFile.getContent()
    )
