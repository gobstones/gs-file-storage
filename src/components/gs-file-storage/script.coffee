
GsFileStorageBehavior = 

  ready: ->
    @.storage = window.localStorage
    if @.storage.getItem('gsFiles') is undefined or @.storage.getItem('gsFiles') is null 
      @.storage.setItem('gsFiles', @.strfy([]))

  strfy:(item)->
    JSON.stringify(item)

  parseJs:(string)->
    JSON.parse(string)

  filesInStorageToObjs:()->
    stringFiles = @.storage.getItem('gsFiles')
    @.parseJs(stringFiles)
  
  addFile: (file)->
    if @.fileNameValid(file.name)
      jsFiles = @.filesInStorageToObjs()
      
      @.files = jsFiles
      
      jsFiles.push(file)
      @.storage.setItem('gsFiles', @.strfy(jsFiles))
    else
      throw "Invalid file name"
  
  fileNameValid:(name)->
    return ( (name isnt undefined) and name.match(/[a-zA-Z]/) and name[0] isnt " ")
  
  getFile:(name)->
    jsFiles = @.filesInStorageToObjs()
    for file in jsFiles
      if file.name is name
        return file

  getAllFilesStored: ->
    stringFiles = @.storage.getItem('gsFiles')
    @.parseJs(stringFiles)

