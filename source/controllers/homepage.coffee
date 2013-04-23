mongoose = require 'mongoose'
_ = require 'underscore'

homepage_controller =
  homepage: (req,res)->
    mongoose.model('games').find {}, null, {limit:40}, (err, games)->
      unless err?
        ctx = games : _.map games, (game)-> game.toJSON()
        res.render 'layout', ctx
      else
        ctx = err:err
        res.render 'layout', ctx

  gamepage: (req,res)->
    {slug} = req.params
    mongoose.model('games').find {}, null, {limit:40}, (err, games)->
      unless err? or not games?
        ctx = games : _.map games, (game)-> game.toJSON()
        mongoose.model('games').find {slug:slug}, (err, game)->
          unless err? or not game?
            ctx.gamepage = game
            res.render 'layout', ctx
          else
            res.render 'layout', ctx
      else
        ctx = err:err
        res.render 'layout', ctx

module.exports = homepage_controller