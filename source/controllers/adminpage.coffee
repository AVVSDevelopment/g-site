admin_controller =
  adminpage: (req,res)->
    {ctx} = req
    ctx.admin = true
    res.render 'admin', ctx

  login: (req, res)->
    {ctx} = req
    ctx.admin = true
    res.render 'admin-login', ctx
module.exports = admin_controller