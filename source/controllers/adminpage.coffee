_ = require "underscore"
async = require 'async'
mongoose = require 'mongoose'
siteDB = mongoose.model('sites')
gameDB = mongoose.model('games')
DIR = 'partials/admin/'


admin_controller =
  sites: (req,res)=>
    {ctx} = req
    ctx.admin = true
    ctx.title = "Admin : Sites"
    siteDB.getAll (err, sites)->
      sites = _.map sites, (site)-> site.toJSON()
      async.each sites, (it, cb)->
        gameDB.countGames it._id, ctx, (err, number)->
          it.games_number = number
          cb err
      , (err)->
        unless err
          ctx.sites = sites
        else
          ctx.err = err
        res.render "#{DIR}sites", ctx

  site_settings: (req,res)=>
    {ctx} = req
    ctx.admin = true
    {site} = req.params
    siteDB.getByDomain site, (err, site)->
      ctx.title = "Admin : " + site.domain
      ctx.site = site
      res.render "#{DIR}site-settings", ctx

  ads_settings: (req, res)->
    {ctx} = req
    ctx.admin = true
    ctx.title = "Admin : Ads Settings"
    ctx.ads = {}
    res.render "#{DIR}ads", ctx

  status: (req, res)->
    {ctx} = req
    ctx.admin = true
    ctx.title = "Admin : Status"
    ctx.status = {}
    res.render "#{DIR}status", ctx

  login: (req, res)=>
    {ctx} = req
    ctx.admin = true
    ctx.title = "Admin : Login"
    res.render "#{DIR}login", ctx

  logout: (req, res)->
    req.logout()
    res.redirect '/admin/login'

module.exports = admin_controller