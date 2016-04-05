Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    buttonName:
      type: String
      value: "Submit"
    nameField:
      type: String
    textField:
      type: String

  submitFields: (event)->
    @fire 'submitFile', file: {name: @$.nameField.value, content: @$.textField.value} 
