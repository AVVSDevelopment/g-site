root      = __dirname
express   = require 'express'
mongoose  = require 'mongoose'
walk      = require 'walk'
fs        = require 'fs'
dot       = require 'express-dot'
games     = require './models/games'


app = express()

startServer = ()->
  app.configure ()->

    #console.log for input req
    #app.use (req, res, next)->
    #  console.log '%s %s', req.method, req.url
    #  next()

    app.use express.methodOverride()
    app.use express.bodyParser()
    app.use express.errorHandler
      dumpExceptions: true,
      showStack: true

    #static paths
    app.use "/static", express.static './source/static'
    app.use "/", express.static './source'

    #mongo connection
    mongoose.connect 'mongodb://gsite_app:temp_passw0rd@ds041327.mongolab.com:41327/heroku_app14575890'
    db = mongoose.connection
    db.on 'error', console.error.bind console, 'connection error:'
    db.once 'open', ()->
      console.log "connection to mongo - Ok!"

    #dot
    app.engine 'dot', dot.__express
    app.set 'views', './source/views'
    app.set 'view engine', 'dot'
    dot.setGlobals
      title:'g-site'

    #router
    app.get '/', require('./controllers/homepage').homepage
    app.get '/games/:slug', require('./controllers/homepage').gamepage

    #port
    port = process.env.PORT || 5000
    app.listen port, ()->
      console.log "Listening on " + port




#generate route for RESTful api
app.models = {}
walker = walk.walk root + "/models", followLinks:false
walker.on "names", (root, modelNames)->
  modelNames.forEach (modelName)->
    modelName = modelName.replace /\.[^/.]+$/, ""
    app.models[modelName] = require './models/'+ modelName

walker.on "end", ()->
  require('./api') app
  startServer()