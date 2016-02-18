chai   = require 'chai'
helper = require './test-helper'
assert = chai.assert

describe 'hubot ansible', ->
  beforeEach (done) ->
    @robot = helper.robot()
    @user  = helper.testUser @robot
    @robot.adapter.on 'connected', ->
      @robot.loadFile  helper.SRC_PATH, 'ansible.coffee'
      @robot.parseHelp "#{helper.SRC_PATH}/ansible.coffee"
      done()
    @robot.run()

  afterEach ->
    @robot.shutdown()

  it 'should be included in /help', (done) ->
    assert.include @robot.commands[0], 'ansible'
    done()
