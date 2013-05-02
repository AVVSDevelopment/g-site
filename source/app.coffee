root      = __dirname
express   = require 'express'
i18n      = require 'i18n'
url       = require 'url'
mongoose  = require 'mongoose'
walk      = require 'walk'
fs        = require 'fs'
dot       = require 'express-dot'
async     = require 'async'
_         = require 'underscore'
passport  = require 'passport'
localStrategy = require('passport-local').Strategy

#models
games     = require './models/games'
sites     = require './models/sites'

#controllers
admin     = require './controllers/adminpage'
index     = require './controllers/homepage'



passport.use new localStrategy (username, password, done)->
  if username is 'admin'
    if password is 'admin'
      return done null, username
    else
      return done null, false, message: 'Incorrect password.'
  else
    return done null, false, message: 'Incorrect username.'

passport.serializeUser (user, done)->
  done null, user

passport.deserializeUser (id, done)->
  done null, id


app = express()

startServer = ()->
  app.configure ()->
    #dot
    app.set 'views', './source/views'
    app.set 'view engine', 'dot'
    app.engine 'dot', dot.__express

    #stack
    app.use "/static", express.static './source/static'
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.errorHandler
      dumpExceptions: true,
      showStack: true

    app.use express.session secret:'super-puper-secret-key'
    app.use passport.initialize()
    app.use passport.session()
    app.use i18n.init
    app.use (req, res, next)->
      #######LOGGING#######
      #console.log "_________________________________________"
      console.log req.url
      #console.log req.cookies
      #####################
      ctx = {}
      ctx.locales = app.locales
      ctx.domain = {}
      ctx.domain.host = req.headers.host
      ctx.domain.api = '/api/v1.alpha'
      ctx.__ = i18n.__
      ctx.domain.defaultLocale = 'es'
      if req.cookies.lang in ctx.locales
        ctx.locale = req.cookies.lang
      else if i18n.getLocale req in ctx.locales
        ctx.locale = i18n.getLocale req
      else
        ctx.locale = ctx.domain.defaultLocale
      req.ctx = ctx
      next()

    async.auto
      createApi: createApi
      createLocales: createLocales
      mongo: connectToMongo
    , ()->
      port = process.env.PORT || 5000
      app.listen port, ()->
        console.log "Listening on " + port
      console.log app.stack

  app.post '/admin/login', passport.authenticate('local'), (req, res)->res.redirect '/admin/'
  app.get '/admin/', ensureAuthenticated, admin.sites
  app.get '/admin', (req, res)-> res.redirect '/admin/'
  app.get '/admin/site/:site', ensureAuthenticated, admin.site_settings
  app.get '/admin/ads/', ensureAuthenticated, admin.ads_settings
  app.get '/admin/status/', ensureAuthenticated, admin.status
  app.get '/admin/login', redirectIfAuthenticated, admin.login
  app.get '/admin/logout', admin.logout

  app.get '/', index.homepage
  app.get '/games/:slug', index.gamepage






#generate route for RESTful api
createApi = (cb)->
  app.models = {}
  walker = walk.walk root + "/models", followLinks:false
  walker.on "names", (root, modelNames)->
    modelNames.forEach (modelName)->
      modelName = modelName.replace /\.[^/.]+$/, ""
      app.models[modelName] = require './models/'+ modelName
  walker.on "end", ()->
    require('./api') app
    console.log "generate api routes - Ok!"
    cb()

#generate locales for i18n
createLocales = (cb)->
  app.locales = []
  walker = walk.walk root + "/static/locales", followLinks:false
  walker.on "names", (root, modelNames)->
    modelNames.forEach (localeName)->
      app.locales.push localeName.replace /\.[^/.]+$/, ""
  walker.on "end", ()->
    i18n.configure
      locales: app.locales
      directory: './source/static/locales'
    console.log "search for locales - Ok!"
    cb()

#mongo connection
connectToMongo = (cb)->
  mongoose.connect 'mongodb://gsite_app:temp_passw0rd@ds041327.mongolab.com:41327/heroku_app14575890'
  db = mongoose.connection
  db.on 'error', console.error.bind console, 'connection error:'
  db.once 'open', ()->
    console.log "connection to mongo - Ok!"
    cb()


ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  res.redirect '/admin/login'

redirectIfAuthenticated = (req, res, next)->
  unless req.isAuthenticated()
    return next()
  res.redirect '/admin/'


startServer()