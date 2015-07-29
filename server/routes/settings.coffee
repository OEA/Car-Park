ctrl = module.exports

#Constants

FLOOR = 5
SLOT = 20

#Init
ctrl.init = (app, db) ->
  app.get('/api/settings', (req, resp) ->
    resp.send(
      code:200
      message:"Sucesss",
      floor:FLOOR,
      slot:SLOT
    )
  )

  app.get('/api/getfilledslots', (req, resp) ->

  )