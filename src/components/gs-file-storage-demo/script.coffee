Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    files:
      type: []
      value: []

  ready: ->
    @storage = GsFileStorage()

    @makeFilesForFileExplorer(@storage.getAllFilesName())

    # When list change triggered refresh fileList
    @storage.addEventListener('listchange', 
      (event)=>
        @makeFilesForFileExplorer(@storage.getAllFilesName())
    )

    @listen(@$.submit, 'submitFile', 'saveFile')

  saveFile: (polymerEvent)->
    eventFile = polymerEvent.detail.file
    @fileDemo = @storage.getFile(eventFile.name)
    @fileDemo.setContent(eventFile.content)

    # When file is saved trigger change event
    @fileDemo.saveIt()

  makeFilesForFileExplorer: (filesNamesList)->
    filesNames = filesNamesList
    @files = []
    for fName in filesNames
      @push('files',
        name: fName 
        content: ""
      )
