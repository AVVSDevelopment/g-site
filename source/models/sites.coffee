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
  title:
    type: String
    required: true
  description: String
  keywords: String
  language:
    type: String
    required: true
  sources: []
  logo_url: String
  background:
    url: String
    color: String

Sites.statics.getByDomain = (domain, ctx, cb)->
  @findOne {domain}, (err, site)=>
    if not err? and site?
      cb site
    else
      cb err:"site not found"


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


exports.model = mongoose.model 'sites', Sites
#exports.methods = ["get","post","delete","put","patch"]
exports.methods = ["get"]