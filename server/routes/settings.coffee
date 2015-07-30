ctrl = module.exports

#Constants

global.FLOOR = 5
global.SLOT = 60

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

  app.get('/node/getlocation/:id', (req, resp) ->
    id = req.params.id
    collection = db.collection "cars"
    collection.find({'active':1, 'deviceId':id}).count((err, count) ->
      if count > 0
        collection.find({'active':1, 'deviceId':id}).toArray((err, cars) ->
          resp.send(
            code: 200
            message: "success",
            slot: cars[0].slot
            floor: cars[0].floor
          )
        )
      else
        resp.send(
          code: 400
          message: "fail"
        )
    )
  )