GroupsTable = require('./GroupsTable')
render = require('./PropertyListControl')

$ ->
  render()

  groupsTable = React.createElement(GroupsTable)
  React.render(groupsTable, document.getElementById('root2'))




