mongoose = require 'mongoose'
_ = require 'underscore'

homepage_controller =
  homepage: (req,res)->
    {ctx} = req
    mongoose.model('games').pagination 1, 40, ctx, (games)->
      unless games.err?
        ctx.games = _.map games, (game)-> game.toJSON()
        res.render 'index', ctx
      else
        ctx.err = games.err
        res.render 'index', ctx

  gamepage: (req,res)->
    {slug} = req.params
    {ctx} = req

    mongoose.model('games').pagination 1, 40, ctx, (games)->
      unless games.err?
        ctx.games = _.map games, (game)-> game.toJSON()
        mongoose.model('games').getBySlugOrId slug, ctx, (game)->
          unless game.err? or _.isEmpty game
            ctx.gamepage = game.toJSON()
            mongoose.model('games').getSimilar slug, 5, ctx, (similar)->
              unless similar.err?
                ctx.gamepage.similar = _.map similar, (game)-> game.toJSON()
                mongoose.model('games').getPopular 5, ctx, (popular)->
                  unless popular.err?
                    ctx.gamepage.popular = _.map popular, (game)-> game.toJSON()
                  res.render 'index', ctx
              else
                res.render 'index', ctx
          else
            res.render 'index', ctx
      else
        ctx.err = games.err
        res.render 'index', ctx

module.exports = homepage_controller