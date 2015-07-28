ctrl = module.exports

ctrl.init = (app, db) ->
  app.get('/api/test', (req, resp) ->
    resp.send(
      code:200
      message:"Sucesss",
    )
  )