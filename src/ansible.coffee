# Description
#   A hubot script that runs Ansible playbooks
#
# Dependencies:
#   shelljs
#
# Configuration:
#   none
#
# Commands:
#   hubot ansible me <command> - runs `ansible-playbook` with the following command
#
# Author:
#   William Durand <will+git@drnd.me>

shell = require 'shelljs'

module.exports = (robot) ->

  if ! shell.which 'ansible'
    @robot.logger.error 'Cannot find ansible command'
    exit 1

  runAnsiblePlaybook = (msg, command) ->
    child = shell.exec ['ansible-playbook', command].join(' '), { async: true }

    child.stdout.on 'data', (data) ->
      msg.send data

  robot.respond /ansible\s+me\s+(.+)/i, (msg) ->
    command = msg.match[1]

    msg.send "Running `ansible-playbook #{command}`"
    runAnsiblePlaybook command
