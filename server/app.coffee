http = require "http"
express = require "express"

mongodb = require("mongodb").MongoClient

cors = require "cors"

originList = ["http://www.oeaslan.com/", "http://oeaslan.com/", "http://localhost/"]

corsOptions =
  origin : (origin, callback) ->
    originAllowed = originList.indexOf(origin) != -1
    callback(null,originAllowed)



app = express()

api = require "./routes"
app.use(cors(corsOptions))

mongodb.connect('mongodb://localhost:27017/carpark', (err, db) ->
  if err
    throw err
  else
    api.init(app, db)
    console.log "Connected to Database"
)


server = http.createServer(app)
server.listen(process.env.PORT || 8000)