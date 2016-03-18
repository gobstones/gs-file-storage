Polymer
  is: '#GRUNT_COMPONENT_NAME'

  # --- Attemp to create several files and
  # --- save them into localStorage with 
  # --- gs-file-storage
  
  properties:
    fileDemo:
      type: {}
      notify: true

  listeners:
    'openFile' : 'openFile'
    'saveFile' : 'saveFile'

  ready: ->
    @storage = GsFileStorageBehavior()

    file =
      name: "index.html"
      content: "This is a html file"
      syntax: "html"
   
    @storage.addFile(file)

    @files = @storage.getAllFiles()

  openFile: (polymerEvent)->
    @set('fileDemo',@storage.getFile(polymerEvent.detail.file.name))

  saveFile: (polymerEvent)->
    @storage.addFile(polymerEvent.detail.file)