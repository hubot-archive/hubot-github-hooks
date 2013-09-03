# Description:
#   Easily add Campfire service hooks to your GitHub repositories.
#
# Commands:
#   hubot add hook to user/repo - Add a Campfire service hook
#   hubot remove hook from user/repo - Remove a Campfire service hook
#
# Configuration:
#   HUBOT_HOOKS_CAMPFIRE_ACCOUNT - The Campfire subdomain for the hook
#   HUBOT_HOOKS_CAMPFIRE_ROOM - The Campfire room _name_ for the hook
#   HUBOT_HOOKS_CAMPFIRE_TOKEN - The Campfire user API token for the hook
#
# Author:
#   tombell
#

CAMPFIRE_ACCOUNT = process.env.HUBOT_HOOKS_CAMPFIRE_ACCOUNT
CAMPFIRE_ROOM    = process.env.HUBOT_HOOKS_CAMPFIRE_ROOM
CAMPFIRE_TOKEN   = process.env.HUBOT_HOOKS_CAMPFIRE_TOKEN

hook_data =
  name: 'campfire'
  active: true
  config: {
    subdomain: CAMPFIRE_ACCOUNT
    room: CAMPFIRE_ROOM
    token: CAMPFIRE_TOKEN
  }
  events: [
    'push'
    'issues'
    'pull_request'
  ]

module.exports = (robot) ->
  github = require('githubot')(robot)

  robot.respond /add hook( to)? ([-_\.0-9a-zA-Z]+)(\/([-_\.0-9a-zA-Z]+))/i, (msg) ->
    owner = msg.match[2]
    name  = msg.match[4]
    nwo   = "#{owner}/#{name}"

    github.request 'POST', "repos/#{nwo}/hooks", hook_data, (hook) ->
      robot.brain.data.repo_hooks or= {}
      robot.brain.data.repo_hooks[nwo] or= {}
      robot.brain.data.repo_hooks[nwo]['campfire'] = hook.id

      msg.reply "Added the Campfire hook to #{nwo} with the ID #{hook.id}"

  robot.respond /remove hook( from)? ([-_\.0-9a-zA-Z]+)(\/([-_\.0-9a-zA-Z]+))/i, (msg) ->
    owner = msg.match[2]
    name  = msg.match[4]
    nwo   = "#{owner}/#{name}"

    robot.brain.data.repo_hooks or= {}
    robot.brain.data.repo_hooks[nwo] or= {}
    id = robot.brain.data.repo_hooks[nwo]['campfire']
    delete robot.brain.data.repo_hooks[nwo]['campfire']

    github.request 'DELETE', "repos/#{nwo}/hooks/#{id}", (hook) ->
      msg.reply "Deleted the Campfire hook from #{nwo} with the ID #{id}"
