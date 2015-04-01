ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

GlyphIcon = React.createClass({ render: -> <span className={"glyphicon glyphicon-" + @props.icon}></span> })

PropertyListControl = React.createClass({
  render: ->
    <div>
      <ReactCSSTransitionGroup transitionName="items">
        { _.map @props.properties, (p) => 
          <PropertyControl key={p.id} property={p}
            onSave={@props.onSave}
            onRemove={@props.onRemove}
          />
        }
        <PropertyControl key="new" property={ name: {} }
          onSave={@props.onSave}
        />
      </ReactCSSTransitionGroup>
    </div>
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

    <div style={border: "solid 1px #DDD", margin: 10, borderRadius: 5, padding: 5, backgroundColor: "#EEE"}>
      <div style={chunk}>
        <small className="text-muted">Code</small>
        <br/>
        <input type="text" className="form-control" style={width: "20em"} 
          value={p.code}
          onChange={@handleCodeChange} />
      </div>
      <div style={chunk}>
        <small className="text-muted">Type</small>
        <br/>
        <select className="form-control" style={width: "auto"} 
          value={p.type}
          onChange={@handleTypeChange}>
          <option value="text">Text</option>
          <option value="apple">Apple</option>
        </select> 
      </div>
      <div style={chunk}>
        <small className="text-muted">Name</small>
        <br/>
        <input type="text" className="form-control" style={width: "25em"} 
          value={p.name.en}
          onChange={@handleNameChange} />
      </div>
      <div style={chunk}>
        <button type="button" className="btn btn-link" 
          onClick={@remove}
          disabled={@state.removing} 
          style={display: (if not  @props.property.id? then "none")}> 
          <GlyphIcon icon="remove"/>
        </button>
        <button type="button" className="btn btn-primary" 
          onClick={@save} 
          disabled={@state.saving} 
          style={display: (if _.isEmpty(@state.updates) then "none")}> 
          Save
        </button>
        &nbsp;
        <button type="button" className="btn btn-default" 
          onClick={@cancel} 
          disabled={@state.saving} 
          style={display: (if _.isEmpty(@state.updates) then "none")}> 
          Cancel
        </button>
      </div>
    </div>
})


$ -> 
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
    React.render(<PropertyListControl properties={properties} 
      onSave={onSave}
      onRemove={onRemove}/>, document.getElementById('root'))

  render()


# PropertyControlOld = React.createClass({
#   handleCodeChange: (ev) -> 
#     @setState(updates: _.extend({}, @state.updates, { code: ev.target.value }))

#   handleNameChange: (ev) -> 
#     @setState(updates: _.extend({}, @state.updates, { name: { en: ev.target.value } }))

#   handleTypeChange: (ev) -> 
#     @setState(updates: _.extend({}, @state.updates, { type: ev.target.value }))

#   getInitialState: -> { updates: {} }

#   save: ->
#     @setState({ saving: true })
#     @props.onUpdate @props.property.id, @state.updates, (err) =>
#       @setState({ saving: false, updates: {} })

#   cancel: ->
#     @setState({ updates: {} })

#   remove: ->
#     @props.onRemove(@props.property.id, ->)

#   render: ->
#     # Get modified property
#     p = _.extend({}, @props.property, @state.updates)
#     <tr>
#       <td>
#         <input type="text" className="form-control" style={width: "20em"} 
#           value={p.code}
#           onChange={@handleCodeChange} />
#       </td>
#       <td>
#         <select className="form-control" style={width: "auto"} 
#           value={p.type}
#           onChange={@handleTypeChange}>
#           <option value="text">Text</option>
#           <option value="apple">Apple</option>
#         </select> 
#       </td>
#       <td>
#         <input type="text" className="form-control" style={width: "25em"} 
#           value={p.name.en}
#           onChange={@handleNameChange} />
#       </td>
#       <td>
#         <button type="button" className="btn btn-link" onClick={@remove}>
#           <GlyphIcon icon="remove"/>
#         </button>
#         <button type="button" className="btn btn-primary" 
#           onClick={@save} 
#           disabled={@state.saving} 
#           style={visibility: (if _.isEmpty(@state.updates) then "hidden")}> 
#           Save
#         </button>
#         &nbsp;
#         <button type="button" className="btn btn-default" 
#           onClick={@cancel} 
#           disabled={@state.saving} 
#           style={visibility: (if _.isEmpty(@state.updates) then "hidden")}> 
#           Cancel
#         </button>
#       </td>
#     </tr>
# })

# PropertyList = React.createClass({
#   render: ->
#     <table className="table">
#       <thead>
#         <tr>
#           <th>Code</th>
#           <th>Type</th>
#           <th>Name</th>
#           <th>Details</th>
#         </tr>
#       </thead>
#       <tbody>
#         { _.map @props.properties, (p) => 
#           <PropertyControl2 key={p.id} property={p} onUpdate={@props.onUpdate} onRemove={@props.onRemove}/>
#         }
#       </tbody>
#     </table>
# })
