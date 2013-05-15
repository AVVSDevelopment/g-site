_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'
games = mongoose.model('games')
DIR = 'partials/app/'

homepage_controller =
  homepage: (req,res)->
    {ctx} = req
    games.pagination 1, 40, ctx, (err, page_of_games)->
      unless err
        ctx.games = _.map page_of_games, (game)-> game.toJSON()
      else
        ctx.err = {err}
      res.render "#{DIR}index", ctx, (err, html)->
        unless err? or req.isAuthenticated()
          req.app.mem.set "#{ctx.locale}/#{ctx.hash}#{req.url}", html
        res.send html

  site_css: (req, res)->
    {ctx} = req
    ctx.layout = false
    res.render "#{DIR}style", ctx, (err, css)->
      unless err?
        req.app.mem.set "#{ctx.locale}/#{ctx.hash}#{req.url}", css
      res.set 'Content-Type', 'text/css'
      res.send css

  gamepage: (req,res)=>
    {slug} = req.params
    {ctx} = req
    async.auto
      pagination: (cb)=> games.pagination 1, 40, ctx, cb
      game      : (cb)=> games.getBySlugOrId slug, ctx, cb
      similar   : (cb)=> games.getSimilar slug, 5, ctx, cb
      popular   : (cb)=> games.getPopular( 5, ctx, cb)
    , (err, data)=>
      if !err and data.game
        ctx.games = _.map data.pagination, (game)-> game.toJSON()
        ctx.gamepage = data.game.toJSON()
        ctx.gamepage.similar = _.map data.similar, (game)-> game.toJSON()
        ctx.gamepage.popular = _.map data.popular, (game)-> game.toJSON()
        res.render "#{DIR}index", ctx, (err, html)->
          unless err? or req.isAuthenticated()
            req.app.mem.set "#{ctx.locale}/#{ctx.hash}#{req.url}", html
          res.send html
      else
        ctx.err = {err}
        res.send 404


module.exports = homepage_controller