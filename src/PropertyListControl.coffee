H = React.DOM

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

GlyphIcon = React.createClass({
  render: ->
    H.span({className:"glyphicon glyphicon-" + @props.icon})
})

PropertyListControl = React.createClass({
  render: ->
    H.div(null,
      React.createElement(ReactCSSTransitionGroup, {transitionName:"items"},
        _.map @props.properties, (p) =>
          React.createElement(PropertyControl, {
              key: p.id,
              property: p,
              onSave: @props.onSave,
              onRemove: @props.onRemove
          })
        React.createElement(PropertyControl, {
            key: "new",
            property: {name: {}},
            onSave: @props.onSave
          })
      )
    )
})

PropertyControl = React.createClass({
  handleCodeChange: (ev) ->
    @setState(updates: _.extend({}, @state.updates, { code: ev.target.value }))

  handleNameChange: (ev) ->
    @setState(updates: _.extend({}, @state.updates, { name: { en: ev.target.value } }))

  handleTypeChange: (ev) ->
    @setState(updates: _.extend({}, @state.updates, { type: ev.target.value }))

  getInitialState: -> { updates: {} }

  save: ->
    @setState({ saving: true })
    @props.onSave @props.property, @state.updates, (err) =>
      @setState({ saving: false, updates: {} })

  cancel: ->
    @setState({ updates: {} })

  remove: ->
    @setState({ removing: true })
    @props.onRemove(@props.property.id, ->)

  render: ->
    # Get modified property
    p = _.extend({}, @props.property, @state.updates)

    chunk = { display: "inline-block", marginRight: 5 }

    H.div({style:{border: "solid 1px #DDD", margin: 10, borderRadius: 5, padding: 5, backgroundColor: "#EEE"}},
      H.div({style:chunk},
        H.small({className: "text-muted"}, "Code")
        H.br(),
        H.input({type:"text", className:"form-control input-sm", style:{width: "20em"}, value: p.code, onChange: @handleCodeChange})
      ),
      H.div({style:chunk},
        H.small({className:"text-muted"}, "Type")
        H.br(),
        H.select({
          className:"form-control input-sm",
          style:{width: "auto"},
          value: p.type,
          onChange: @handleTypeChange},
          H.option({value:"text"}, "Text")
          H.option({value:"apple"}, "Apple")
        )
      ),
      H.div({style: chunk},
        H.small({className:"text-muted"}, "Name"),
        H.br(),
        H.input({
          type: "text",
          className: "form-control input-sm",
          style: {width: "25em"},
          value: p.name.en,
          onChange: @handleNameChange
        })
      ),
      H.div({style: chunk},
        H.button({
            type:"button",
            className:"btn btn-link btn-sm",
            onClick: @remove,
            disabled: @state.removing,
            style: {display: (if not  @props.property.id? then "none")}},
          React.createElement(GlyphIcon, {icon: "remove"})
        ),
        H.button({
          type: "button",
          className: "btn btn-primary btn-sm",
          onClick: @save,
          disabled: @state.saving,
          style: {display: (if _.isEmpty(@state.updates) then "none")}},
          "Save"
        ),
        H.div(null, "&nbsp;"),
        H.button({
          type:"button",
          className:"btn btn-default btn-sm",
          onClick: @cancel,
          disabled: @state.saving,
          style: {display: (if _.isEmpty(@state.updates) then "none")}},
          "Cancel"
        )
      )
    )
})


properties = [
  { id: 1, code: "name", type: "text", name: { en: "Name"} }
  { id: 2, code: "desc", type: "text", name: { en: "Desc"} }
]

onSave = (prop, updates, cb) =>
  setTimeout( ->
    if prop.id
      _.extend(_.findWhere(properties, { id: prop.id }), updates)
    else
      updates.id = _.max(properties, (p) -> p.id) + 1
      properties.push(updates)
    cb()
    render()
  , 500)


onRemove = (id, cb) =>
  setTimeout(->
    cb()
    properties = _.reject(properties, (p) -> p.id == id)
    render()
  , 500)

render = ->
  React.render(React.createElement(PropertyListControl, {properties: properties, onSave: onSave, onRemove: onRemove}), document.getElementById('root'))

module.exports = render

