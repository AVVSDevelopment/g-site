var Schema, Sites, mongoose;

mongoose = require('mongoose');

Schema = require('../rest');

Sites = new Schema({
  enable: {
    type: Boolean,
    "default": false
  },
  domain: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  title: String,
  description: String,
  keywords: String,
  language: {
    type: String,
    'default': 'en'
  },
  sources: [],
  logo_url: String,
  toolbar: {
    start_color: String,
    stop_color: String
  },
  background: {
    url: String,
    color: String
  }
});

Sites.statics.getByDomain = function(domain, cb) { 
  return this.find({},function(err,results){
    console.log('a');
  })
  /*return this.findOne({
    domain: domain
  }, cb);*/
};

Sites.statics.getAll = function(cb) {
  return this.find({}, null, {
    sort: {
      domain: 1
    }
  }, cb);
};

Sites.statics.post = function(req, res) {
  var domain, site;
  if (req.isAuthenticated()) {
    domain = req.body.domain;
    site = new (mongoose.model('sites', Sites));
    site.domain = domain;
    return site.save(function(err) {
      if (err == null) {
        return res.redirect("/admin/");
      } else {
        console.log(err);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: 'Not authenticated'
    });
  }
};

Sites.statics.put = function(req, res) {
  var id, oid,
    _this = this;
  if (req.isAuthenticated()) {
    id = req.params.id;
    oid = null;
    if ((id != null) && id.match("^[0-9A-Fa-f]+$")) {
      oid = new ObjectId(id);
    }
    return this.update({
      $or: [
        {
          domain: id
        }, {
          _id: oid
        }
      ]
    }, {
      $set: req.body
    }, {
      multi: false
    }, function(err, numAffected) {
      if (!((err != null) || !numAffected)) {
        req.app.mem["delete"](id, console.log("clear memcache for " + id));
        return res.json(null);
      } else {
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: 'Not authenticated'
    });
  }
};

exports.model = mongoose.model('sites', Sites);

exports.methods = ["post", "put"];