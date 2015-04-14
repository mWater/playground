H = React.DOM

module.exports = React.createClass({
  displayName: "ModalPopup",

  handleSave: (e) ->
    e.preventDefault()
    if @props.onSave?
      @props.onSave()

  handleCancel: (e) ->
    e.preventDefault()
    if @props.onClose
      @props.onClose()

  render: ->
    H.div({className: "modal show"},
      H.div({className: "modal-dialog"},
        H.div({className: "modal-content"},
          H.div({className: "modal-header"},
            H.form({onSubmit: @handleCancel},
              H.button({className: "close"},'x')
            ),
            H.h4({className: "modal-title"}, @props.title)
          )
          H.div({className: "modal-body"},
            React.createElement(@props.childClass, @props.childParams)
          )
          H.div({className: "modal-footer"},
            H.form({onSubmit: @handleSave},
              H.button(null, "Save")
            ),
            H.form({onSubmit: @handleCancel},
              H.button(null, "Cancel")
            )
          )
        )
      )
    )
})