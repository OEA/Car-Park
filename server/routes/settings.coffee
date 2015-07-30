ctrl = module.exports

#Constants

global.FLOOR = 5
global.SLOT = 20

#Init
ctrl.init = (app, db) ->
  app.get('/node/settings', (req, resp) ->
    resp.send(
      code:200
      message:"Sucesss",
      floor:FLOOR,
      slot:SLOT
    )
  )

  app.get('/node/getfilledslots', (req, resp) ->
    collection = db.collection "cars"
    collection.find({'active':1}).toArray((err, cars) ->
      resp.send(
        code: 200,
        message: "success",
        slots: cars
      )
    )
  )