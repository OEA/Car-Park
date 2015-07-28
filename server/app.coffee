http = require "http"
express = require "express"
#
#cors = require "cors"
#
#originList = ["http://oeaslan.com/car-park/", "http://localhost/"]
#
#corsOptions =
#  origin : (origin, callback) ->
#    originAllowed = originList.indexOf(origin) != -1
#    callback(null,originAllowed)


app = express()
#app.use(cors(corsOptions))

api = require "./routes"
api.init(app, null)

server = http.createServer(app)
server.listen(process.env.PORT || 8000)