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

  app.get('/api/payment/calculate-from-id/:id', (req, resp) ->
    resp.send(
      code: 200,
      message: "success",

    )
  )

  app.get('/test', (req, resp) ->

    car = new Car("testDeviceId", "test date", "3,5", 4, 1)
    db.collection 'cars', (err, collection) =>
      if err
        console.error err
      collection.insert car, (err, car) =>
        if err
          console.error err

    resp.send(
      code: 200,
      message: "success",
      car: "test"
    )
  )