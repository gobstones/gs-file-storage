
Polymer
  is: '#GRUNT_COMPONENT_NAME'

  # --- Attemp to create several files and
  # --- save them into localStorage with 
  # --- gs-file-storage
  
  properties:
    fileDemo:
      type: {}
      notify: true

  behaviors: [GsFileStorageBehavior]

  listeners:
    'openFile' : 'openFile'

  attached: ->
    @.demofiles = [
        name: "index.html"
        content: "This is an html file"
        syntax: "html"
      , 
        name: "script.js"
        content: "This is an javascript file"
        syntax: "js"
      ,
        name: "style.css"
        content: "This is an css file"
        syntax: "Css"
      ,
        name: "style.css"
        content: "This is an css file"
        syntax: "Css"
    ]

    for file in @.demofiles
      @.addFile(file)

    @.addFile(
      name: "index.html"
      content: "This is an html file"
      syntax: "html"
    )

  openFile: (polymerEvent)->
    @.set('fileDemo',@.getFile(polymerEvent.detail.file.name))
