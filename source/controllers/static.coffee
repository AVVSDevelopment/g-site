fs = require 'fs'

static_controller =
  get_file: (req, res)->
    {folder, filename, fingerprint} = req.params
    if filename.length>32
      fingerprint = filename.match /^([0-9a-f]{32})/
    if fingerprint?
      fingerprint = fingerprint[0]
      filename = filename.replace /^([0-9a-f]{32})/, ""
    console.log folder, fingerprint, filename
    res.sendfile "./source/public/#{folder}/#{filename}"

module.exports = static_controller