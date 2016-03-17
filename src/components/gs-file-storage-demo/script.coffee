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

  ready: ->
    @storage = GsFileStorageBehavior()

    @demofiles = [
        name: "index.html"
        content: "This is a html file"
        syntax: "html"
      , 
        name: "script.js"
        content: "This is a javascript file"
        syntax: "js"
      ,
        name: "style.css"
        content: "This is a css file"
        syntax: "Css"
      ,
        name: "style.css"
        content: "This is another content for css file"
        syntax: "Css"
    ]

    for file in @demofiles
      @storage.addFile(file)

    @storage.addFile(
      name: "index.html"
      content: "This is another content for html file"
      syntax: "html"
    )

    @files = @storage.getAllFiles()

  openFile: (polymerEvent)->
    @set('fileDemo',@storage.getFile(polymerEvent.detail.file.name))
