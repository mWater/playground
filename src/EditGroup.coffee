H = React.DOM

module.exports = React.createClass({
  displayName: "EditGroup",
  getInitialState: ->
    {members: [type: "user", name:"testName2", isAdmin:false]}
  render: ->
    H.div({role: "tabpanel"},
      H.ul({className: "nav nav-tabs", role: "tablist"},
        H.li({role: "presentation", className: "active"},
          H.a({href: "#settings", role: "tab", "aria-controls":"settings", "data-toggle":"tab"}, "Settings title")
        ),
        H.li({role: "presentation"},
          H.a({href: "#members", role: "tab", "aria-controls":"members", "data-toggle":"tab"}, "Members title")
        )
      ),

      H.div({className: "tab-content"},
        H.div({role:"tabpanel", className: "tab-pane active", id: "settings"},
          React.createElement(SettingsTab, {
            hasDataCollectionEnabled: this.state.hasDataCollectionEnabled,
            isPubliclyVisible: this.state.isPubliclyVisible
          })
        ),
        H.div({role:"tabpanel", className: "tab-pane", id: "members"},
          React.createElement(MembersTab, {
            members: this.state.members,
            handleGroupLeave: @handleGroupLeave
          })
        )
      )
    )
})

SettingsTab = React.createClass({
  displayName: "SettingsTab",
  getInitialState: ->
    {isPubliclyVisible: false, hasDataCollectionEnabled: false}
  handlePubliclyVisibleChanged: (e) ->
    @setState({isPubliclyVisible: !@state.isPubliclyVisible})
  handleDataCollectionEnabledChanged: (e) ->
    @setState({hasDataCollectionEnabled: !@state.hasDataCollectionEnabled})
  render: ->
    H.div(null,
      H.div(null, "Group Name:"),
      H.div(null, "Group Description:"),
      H.div(null, H.input({type:"checkbox", checked:this.state.isPubliclyVisible, onChange: @handlePubliclyVisibleChanged}), "Group is publicly visible"),
      H.div(null, H.input({type:"checkbox", checked:this.state.hasDataCollectionEnabled, onChange: @handleDataCollectionEnabledChanged}), "Data collection enabled"),
      H.div(null, "Etc.")
    )
})

MembersTab = React.createClass({
  displayName: "MembersTab",
  render: ->
    H.div(null,
      H.table({className: "table"},
        H.tr(null,
          H.th(null, "Member"),
          H.th(null, "Admin"),
          H.th(null, "Actions")
        ),
        this.props.members.map((member) =>
          key = "(" + member.type + ") " + member.name
          return H.tr({key: key},
            H.td(null, key),
            H.td(null,
              H.input({type:"checkbox", checked:member.isAdmin})
            ),
            H.td(null,
              H.form({onSubmit: @handleRemove},
                H.button(null, "remove")
              )
            )
          )
        )
      ),
      H.div(null, "Add Member:")
    )
})