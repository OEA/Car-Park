ctrl = module.exports

Car = require '../models/Car/Car'
#constants
PRICE_PER_FIRST_HOUR = 7
PRICE_PER_HOUR = 1
CURRENCY = "TL"

#Init
ctrl.init = (app, db) ->
  app.get('/api/payment/settings', (req, resp) ->
    resp.send(
      code:200,
      message:"success",
      pricePFH:PRICE_PER_FIRST_HOUR,
      pricePH:PRICE_PER_HOUR
      currency:CURRENCY
    )
  )

  app.get('/api/payment/calculate/:time', (req, resp) ->
    time = req.params.time
    if time > 1
      total = PRICE_PER_FIRST_HOUR + (time - 1) * PRICE_PER_HOUR
    else
      total = PRICE_PER_FIRST_HOUR
    resp.send(
      code:200,
      message:"success",
      total: total
      currency: CURRENCY
    )
  )

  app.get('/payment/calculate-from-id/:id', (req, resp) ->
    id = req.params.id;
    cars = db.collection "cars"
    cars.find({'deviceId':id,'active':1}).toArray((err, cars) ->
      car = cars[0]
      if car
        date = new Date()
        hours = Math.abs(date.getHours() - car.startDate.getHours())
        console.log date
        console.log car.startDate
        console.log hours
        if hours > 1
          resp.send(
            code: 200,
            message: "success",
            total: PRICE_PER_FIRST_HOUR + (hours - 1) * PRICE_PER_HOUR
            currency: CURRENCY
          )
        else
          resp.send(
            code: 200,
            message: "success",
            total: PRICE_PER_FIRST_HOUR
            currency: CURRENCY
          )
      else
        resp.send(
          code: 400,
          message: "failure",
          detail: "There is no active id which you give"
        )
    )
  )


  app.get('/payment/pay/:id', (req, resp) ->
    id = req.params.id
    cars = db.collection "cars"
    cars.findOneAndUpdate({'deviceId':id,'active':1},{$set:{'active':0}},(err, item) ->
      if item.value
        resp.send(
          code: 200,
          message: "success",
          car: item
        )
      else
        resp.send(
          code: 400,
          message: "failure",
          detail: "There is no active id which you give."
        )
    )

  )

  app.get('/test', (req, resp) ->
    deviceId = req.query.deviceId
    startDate = new Date()
    slot = req.query.slot
    floor = req.query.floor
    car = new Car(deviceId, startDate, slot, floor, 1)
    db.collection 'cars', (err, collection) =>
      if err
        console.error err
      collection.insert car, (err, car) =>
        if err
          console.error err
    resp.send(
      code: 200,
      message: "success",
      car: deviceId
    )
  )
