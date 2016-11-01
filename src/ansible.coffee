# Description
#   A hubot script that runs Ansible playbooks
#
# Dependencies:
#   shelljs
#
# Configuration:
#   HUBOT_ANSIBLE_PLAYBOOKS_PATH
#
# Commands:
#   hubot ansible me <command> - runs `ansible-playbook` with the following command
#
# Author:
#   William Durand <will+git@drnd.me>

shell = require 'shelljs'

ansiblePath = process.env.HUBOT_ANSIBLE_PLAYBOOKS_PATH ? '.'
authorized_roles = process.env.HUBOT_ANSIBLE_AUTHORIZED_ROLES

has_an_authorized_role = (robot, user) ->
  for r in robot.auth.userRoles user
    return true if r in authorized_roles.split(',')
  return false

is_authorized = (robot, user, res) ->
  has_hubot_auth = robot.auth? and robot.auth.hasRole?
  must_restrict_with_roles = has_hubot_auth and authorized_roles?
  (not must_restrict_with_roles) or has_an_authorized_role robot, user

module.exports = (robot) ->

  if ! shell.which 'ansible'
    throw new Error('Cannot find ansible command')

  runAnsiblePlaybook = (msg, command) ->
    command = ['ansible-playbook', command].join(' ')
    msg.send "Running `#{command}`"

    child = shell.exec "cd #{ansiblePath} && #{command}", { async: true }

    child.stdout.on 'data', (data) ->
      msg.send data

  robot.respond /ansible\s+me\s+(.+)/i, (msg) ->
    command = msg.match[1]
    authorized = is_authorized robot, msg.envelope.user, msg

    unless authorized
      msg.reply "I can't do that, you need at least one of these roles: #{authorized_roles}"

    unless (not authorized)
      runAnsiblePlaybook msg, command
