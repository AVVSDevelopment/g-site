mongoose = require 'mongoose'
Schema = require '../rest'



#ObjectId = mongoose.Types.ObjectId;
#_ = require 'underscore'


Sites = new Schema
  enable:
    type: Boolean
    "default": false
  domain:
    type:String
    required: true
    unique: true
    lowercase: true
    trim: true
  title: String
  description: String
  keywords: String
  language: String
  sources: []
  logo_url: String
  background:
    url: String
    color: String

Sites.statics.getByDomain = (domain, ctx, cb)->
  @findOne {domain}, cb

Sites.statics.getAll = (ctx, cb)->
  @find {}, null, {sort:{domain:1}}, cb

Sites.statics.post = (req, res)->
  if req.isAuthenticated()
    {domain} = req.body
    site = new (mongoose.model 'sites', Sites)
    site.domain = domain
    site.save (err)->
      unless err?
        #res.redirect "/admin/site/#{domain}"
        res.redirect "/admin/"
      else
        console.log err
        res.json {err}
  else
    res.json err:'Not authenticated'

Sites.statics.put = (req, res)->
  if req.isAuthenticated()
    {id} = req.params
    oid = null
    if id? and id.match "^[0-9A-Fa-f]+$"
      oid = new ObjectId id
    @update {$or:[{domain:id}, {_id: oid}]}, {$set:req.body}, (err)->
      unless err?
        res.json null
      else
        res.json {err}
  else
    res.json err:'Not authenticated'
###
sm = (mongoose.model 'sites', Sites)

s = new sm
s.enable = false
s.domain = "footballgames.com"
s.title = "Football Games"
s.language = "en"
s.save (err)->
  console.log err

s = new sm
s.enable = false
s.domain = "juegosninas.es"
s.title = "Juegos de niñas"
s.language = "es_ES"
s.save (err)->
  console.log err

s = new sm
s.enable = false
s.domain = "jogoscarros.com.br"
s.title = "Jogos de Carros"
s.language = "pt_BR"
s.save (err)->
  console.log err

s = new sm
s.enable = false
s.domain = "shootinggames.co.uk"
s.title = "Shooting Games"
s.language = "en_UK"
s.save (err)->
  console.log err
###

#exports.methods = ["get","post","delete","put","patch"]
exports.model = mongoose.model 'sites', Sites
exports.methods = ["post", "put"]