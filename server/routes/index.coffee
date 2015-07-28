settings = require './settings'
payment = require './payment'

ctrl = module.exports

ctrl.init = (app, db) ->
  settings.init(app, db)
  payment.init(app, db)
