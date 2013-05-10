_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'
gameDB = mongoose.model('games')
DIR = 'partials/app/'

homepage_controller =
  homepage: (req,res)->
    {ctx} = req
    gameDB.pagination 1, 40, ctx, (err, games)->
      unless err
        ctx.games = _.map games, (game)-> game.toJSON()
      else
        ctx.err = {err}
      res.render "#{DIR}index", ctx, (err, html)->
        unless err? or req.isAuthenticated()
          req.app.mem.set "#{ctx.locale}/#{ctx.domain}#{req.url}", html
        res.send html

  gamepage: (req,res)=>
    {slug} = req.params
    {ctx} = req
    async.auto
      pagination: (cb)=> gameDB.pagination 1, 40, ctx, cb
      game      : (cb)=> gameDB.getBySlugOrId slug, ctx, cb
      similar   : (cb)=> gameDB.getSimilar slug, 5, ctx, cb
      popular   : (cb)=> gameDB.getPopular( 5, ctx, cb)
    , (err, data)=>
      unless err
        ctx.games = _.map data.pagination, (game)-> game.toJSON()
        ctx.gamepage = data.game.toJSON()
        ctx.gamepage.similar = _.map data.similar, (game)-> game.toJSON()
        ctx.gamepage.popular = _.map data.popular, (game)-> game.toJSON()
      else
        ctx.err = {err}
      res.render "#{DIR}index", ctx, (err, html)->
        unless err? or req.isAuthenticated()
          req.app.mem.set "#{ctx.locale}/#{ctx.domain}#{req.url}", html
        res.send html

module.exports = homepage_controller