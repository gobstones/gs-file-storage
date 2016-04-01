Polymer
  is: '#GRUNT_COMPONENT_NAME'

  listeners:
    'openFile' : 'openFile'
    'submitFile' : 'saveFile'

  properties:
    fileContent:
      type: String
    fileses:
      type: []
      value: []

  ready: ->
    window.localStorage.removeItem('gsFiles')
    @storage = GsFileStorage()
    @disabledText = @$.disabledText
    @fileses = [{name: "sarasa", content: ""}]
    @makeFilesForFileExplorer(@storage.getAllFilesName())

    # When list change triggered refresh fileList
    @storage.addEventListener('listchange', 
      (event)=>
        @makeFilesForFileExplorer(@storage.getAllFilesName())
    )
    
    @fileDemo = @storage.getFile("index.html")
    
    # When change triggered refresh content
    @fileDemo.addEventListener('change', 
      (event)=>
        file = event.target
        @refreshTextContent(file.getContent())
    )

  saveFile: (polymerEvent)->
    eventFile = polymerEvent.detail.file
    @fileDemo.setContent(eventFile.content)
    # When file is saved trigger change event
    @fileDemo.saveIt()

  refreshTextContent:(text)->
    @disabledText.value = text

  makeFilesForFileExplorer: (filesNamesList)->
    filesNames = filesNamesList
    @files = []
    for fName in filesNames
      @files.push(
        name: fName 
        content: ""
      )
