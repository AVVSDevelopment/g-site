root      = __dirname
i18n      = require 'i18n'
mongoose  = require 'mongoose'
walk      = require 'walk'
memjs     = require 'memjs'
crypto    = require 'crypto'
cp        = require 'child_process'
fs        = require 'fs'
knox      = require 'knox'


#generate route for RESTful api
exports.createApi = (app, cb)->
  app.models = {}
  walker = walk.walk root + "/models", followLinks:false
  walker.on "names", (root, modelNames)->
    modelNames.forEach (modelName)->
      modelName = modelName.replace /\.[^/.]+$/, ""
      app.models[modelName] = require './models/'+ modelName
  walker.on "end", ()->
    require('./api') app
    app.log.info "generate api routes    - Ok!"
    cb()

#generate locales for i18n
exports.createLocales = (app, cb)->
  app.locales = []
  walker = walk.walk root + "/public/locales", followLinks:false
  walker.on "names", (root, modelNames)->
    modelNames.forEach (localeName)->
      app.locales.push localeName.replace /\.[^/.]+$/, ""
  walker.on "end", ()->
    i18n.configure
      locales: app.locales
      directory: './source/public/locales'
    app.log.info "search for locales     - Ok!"
    cb()

#mongo connection
exports.connectToMongo = (app, cb)->
  mongoose.connect process.env.MONGOLAB_URI
  db = mongoose.connection
  db.on 'error', console.error.bind console, 'connection error:'
  db.once 'open', ()->
    app.log.info "connection to mongo    - Ok!"
    cb()

#memcache
exports.connectToMemcache = (app, cb)->
  app.mem = memjs.Client.create(undefined, expires:60*60)
  app.log.info  "connection to memcache - Ok!"
  cb()

#run grunt to compile new js and css files
exports.runGrunt = (app, cb)->
  grunt = cp.exec "grunt dev --no-color", (err,stdout,stderr)->
    app.log.info stdout
    if err?
      app.log.err  "grunt                  - FAILED!"
      app.log.err stderr
      app.log.err err
    else
      app.log.info  "grunt                  - Ok!"
    cb()

#upload to S3
exports.uploadStaticToS3 = (app, cb)->
  ###
  client = knox.createClient
    key: process.env.AWS_ACCESS_KEY_ID
    secret: process.env.AWS_SECRET_ACCESS_KEY
    bucket: process.env.AWS_STORAGE_BUCKET_NAME_STATIC

  fs.readFile './source/static/js/admin.body.js', (err, buf)->
    req = client.put '/static/js/admin.body.js',
      'Content-Length': buf.length
      'Content-Type': 'application/javascript'
      'x-amz-acl': 'public-read'
    req.on 'response', (res)->
      if res.statusCode is 200
        console.log 'saved to %s', req.url
    req.end buf
  ###
  #app.log.info  "upload   static to S3    - Ok!"
  cb()