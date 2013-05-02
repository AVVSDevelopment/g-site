mongoose = require 'mongoose'
#siteDB = mongoose.model('sites')
DIR = 'partials/admin/'


admin_controller =

  sites: (req,res)=>
    {ctx} = req
    ctx.admin = true
    res.render "#{DIR}sites", ctx

  site_settings: (req,res)=>
    {ctx} = req
    ctx.admin = true
    {site} = req.params
    #siteDB.getByDomain site, ctx,
    console.log site
    res.render "#{DIR}site-settings", ctx

  login: (req, res)=>
    {ctx} = req
    ctx.admin = true
    console.log @dir
    res.render "#{DIR}login", ctx

  logout: (req, res)->
    req.logout()
    res.redirect '/admin/login'

module.exports = admin_controller