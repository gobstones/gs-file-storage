Polymer
  is: '#GRUNT_COMPONENT_NAME'

  listeners:
    'openFile' : 'openFile'
    'submitFile' : 'saveFile'

  properties:
    fileContent:
      type: String

  ready: ->
    window.localStorage.removeItem('gsFiles')
    @storage = GsFileStorage()
    @disabledText = @$.disabledText
    
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
