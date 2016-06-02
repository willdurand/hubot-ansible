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

module.exports = (robot) ->

  if ! shell.which 'ansible'
    throw new Error('Cannot find ansible command')

  runAnsiblePlaybook = (msg, command) ->
    command = ['ansible-playbook', command].join(' ')
    msg.send "Running `#{command}`"

    child = shell.exec "cd #{ansiblePath} && #{command}", (code, stdout, stderr) ->
      msg.send "Error: #{stderr}"

    child.stdout.on 'data', (data) ->
      msg.send data

  robot.respond /ansible\s+me\s+(.+)/i, (msg) ->
    command = msg.match[1]

    runAnsiblePlaybook msg, command

  robot.on 'ansible:runPlaybook', runAnsiblePlaybook
