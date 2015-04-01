GlyphIcon = React.createClass({ render: -> <span className={"glyphicon glyphicon-" + @props.icon}></span> })

PropertyList = React.createClass({
  render: ->
    <table className="table">
      <thead>
        <tr>
          <th>Code</th>
          <th>Type</th>
          <th>Name</th>
          <th>Details</th>
        </tr>
      </thead>
      <tbody>
        { _.map @props.properties, (p) => 
          <PropertyControl key={p.id} property={p} onUpdate={@props.onUpdate} onRemove={@props.onRemove}/>
        }
      </tbody>
    </table>
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
    @props.onUpdate @props.property.id, @state.updates, (err) =>
      @setState({ saving: false, updates: {} })

  cancel: ->
    @setState({ updates: {} })

  remove: ->
    @props.onRemove(@props.property.id, ->)

  render: ->
    # Get modified property
    p = _.extend({}, @props.property, @state.updates)
    <tr>
      <td>
        <input type="text" className="form-control" style={width: "20em"} 
          value={p.code}
          onChange={@handleCodeChange} />
      </td>
      <td>
        <select className="form-control" style={width: "auto"} 
          value={p.type}
          onChange={@handleTypeChange}>
          <option value="text">Text</option>
          <option value="apple">Apple</option>
        </select> 
      </td>
      <td>
        <input type="text" className="form-control" style={width: "25em"} 
          value={p.name.en}
          onChange={@handleNameChange} />
      </td>
      <td>
        <button type="button" className="btn btn-link" onClick={@remove}>
          <GlyphIcon icon="remove"/>
        </button>
        <button type="button" className="btn btn-primary" 
          onClick={@save} 
          disabled={@state.saving} 
          style={visibility: (if _.isEmpty(@state.updates) then "hidden")}> 
          Save
        </button>
        &nbsp;
        <button type="button" className="btn btn-default" 
          onClick={@cancel} 
          disabled={@state.saving} 
          style={visibility: (if _.isEmpty(@state.updates) then "hidden")}> 
          Cancel
        </button>
      </td>
    </tr>
})

$ -> 
  properties = [
    { id: 1, code: "name", type: "text", name: { en: "Name"} }
    { id: 2, code: "desc", type: "text", name: { en: "Desc"} }
  ]

  onUpdate = (id, updates, cb) =>
    setTimeout(->
      cb()
      _.extend(_.findWhere(properties, { id: id }), updates)
      render()
    , 2000)

  onRemove = (id, cb) =>
    setTimeout(->
      cb()
      properties = _.reject(properties, (p) -> p.id == id)
      render()
    , 2000)

  render = ->
    React.render(<PropertyList properties={properties} onUpdate={onUpdate} onRemove={onRemove}/>, document.getElementById('root'))

  render()


