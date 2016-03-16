Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    buttonName:
      type: String
      value: "Submit"
    bindedValue:
      type: String
      notify: true

  attached: ->
    this.inputField  = this.$.inputField
    this.inputField.value = this.bindedValue

  submitValue: (polymerEvent)->
    this.bindedValue = this.inputField.value
    console.log this.inputField.value

  checkIfEnter: (event)->
    console.log "Key pressed"
    if event.keyCode is 13
      this.submitValue(event)