Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    buttonName:
      type: String
      value: "Submit"
    nameField:
      type: String
      value: "sarasa"
    textField:
      type: String

  submitFields: (event)->
    this.fire 'saveFile', file: {name: this.$.nameField.value, content: this.$.textField.value} 
  
  checkIfEnter: (event)->
    console.log "Key pressed"
    if event.keyCode is 13
      this.submitFields(event)

  