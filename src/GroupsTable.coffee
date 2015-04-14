H = React.DOM
ModalPopup = require('./ModalPopup')
EditGroup = require('./EditGroup')

module.exports = React.createClass({
  displayName: "GroupsTable",
  getInitialState: ->
    {groups: [], groupBeingEdited: null, loading: true}
  handleEditGroup: (group) ->
    @setState(groupBeingEdited: group)
  onClose: () ->
    @setState(groupBeingEdited: null)
  onSave: () ->
    @setState(groupBeingEdited: null)
  componentDidMount: ->
    @setState({
      loading: false,
      groups: [
        {name: "GroupA", status: "admin", isAdmin: true},
        {name: "GroupB", status: "member", isAdmin: false}
      ]
    })
  render: ->
    if @state.loading
      content = H.div(null, "Loading...")
    else
      content = H.div(null,
        H.table({className: "table"},
          H.tr(null,
            H.th(null, "Name"),
            H.th(null, "Status"),
            H.th(null, "Actions")
          ),
          @state.groups.map((group) =>
            React.createElement(GroupsTableEntry, {group: group, handleEditGroup: @handleEditGroup}, "Groups")
          )
        ),
        if @state.groupBeingEdited?
          React.createElement(ModalPopup, {onClose: @onClose, onSave: @onSave, title: "Edit Group", childClass: EditGroup, childParams: {group: @state.groupBeingEdited}})
      )

    return H.div(null,
      H.h1(null, "Groups"),
      content
    )
})

GroupsTableEntry = React.createClass({
  displayName: "GroupsTableEntry",
  getInitialState: ->
    {isLeaving: false}
  handleLeave: (e) ->
    e.preventDefault()
    @setState({isLeaving: true})
  handleEdit: (e) ->
    e.preventDefault()
    @props.handleEditGroup(@props.group)
  handleJoinBack: (e) ->
    e.preventDefault()
    @setState({isLeaving: false})
  render: ->
    if @state.isLeaving
      actionsDiv = H.div(null,
        H.form({onSubmit: @handleJoinBack},
          H.button(null, "join back")
        )
      )
    else
      leaveForm = H.form({onSubmit: @handleLeave},
        H.button(null, "leave")
      )
      # can only edit if admin
      if @props.group.isAdmin
        actionsDiv = H.div(null,
          leaveForm,
          H.form({onSubmit: @handleEdit},
            H.button(null, "edit")
          )
        )
      else
        actionsDiv = H.div(null,
          leaveForm
        )


    return H.tr({key: @props.group.name},
      H.td(null, @props.group.name),
      H.td(null, @props.group.status),
      H.td(null, actionsDiv)
    )
})
