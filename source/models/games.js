var Games, ObjectId, Schema, mongoose, url, _;

url = require('url');

mongoose = require('mongoose');

_ = require('underscore');

Schema = require('../rest');

ObjectId = mongoose.Types.ObjectId;

Games = new Schema({
  title: {
    type: String,
    required: true
  },
  description: String,
  slug: {
    type: String,
    required: true,
    trim: true
  },
  image_url: {
    type: String,
    required: true
  },
  swf_url: {
    type: String,
    required: true
  },
  created_on: {
    type: Date,
    "default": Date.now
  },
  updated_on: {
    type: Date,
    "default": Date.now
  },
  thumbs_up: {
    type: Number,
    "default": 0
  },
  thumbs_down: {
    type: Number,
    "default": 0
  },
  site: Schema.Types.ObjectId,
  pageviews: {
    type:Number,
    "default": 0
  },
  avg_time: {
    type:Number,
    "default": 0
  },
  bounce_rate: {
    type:Number,
    "default": 0
  }
});

Games.statics.getAllBySiteId = function(id, cb){
  return this.find ({site:id}, cb);
}

Games.statics.getBySlugOrId = function(id, ctx, cb) {
  var oid;
  oid = (id != null ? id.match("^[0-9A-Fa-f]+$") : void 0) ? new ObjectId(id) : null;
  return this.findOne({
    $or: [
      {
        slug: id
      }, {
        _id: oid
      }
    ],
    site: ctx._id
  }, cb);
};

Games.statics.getSimilar = function(id, count, ctx, cb) {
  return this.find({
    site: ctx._id
  }, null, {
    limit: count
  }, cb);
};

Games.statics.getPopular = function(count, ctx, cb) {
  return this.find({
    site: ctx._id
  }, null, {
    sort: {
      thumbs_up: -1
    },
    limit: count
  }, cb);
};

Games.statics.search = function(query, ctx, cb) {
  return this.find({
    site: ctx._id,
    title: new RegExp(query, "i")
  }, null, {
    limit: 20
  }, cb);
};

Games.statics.pagination = function(page, page_size, ctx, cb) {
  page = page || 0;
  page_size = page_size || 40;
  return this.find({
    site: ctx._id
  }, null, {
    sort: {
      thumbs_up: -1
    },
    skip: (page - 1) * page_size,
    limit: page_size
  }, cb);
};

Games.statics.countGames = function(site_id, ctx, cb) {
  return this.count({
    site: site_id
  }, cb);
};

Games.statics.get = function(req, res) {
  var ctx, id, key, page, page_size, popular, query, similar, _ref,
    _this = this;
  ctx = req.ctx;
  id = req.params.id;
  _ref = req.query, query = _ref.query, page = _ref.page, page_size = _ref.page_size, popular = _ref.popular, similar = _ref.similar;
  key = "" + ctx.locale + "/" + ctx.hash + "/";
  if (id != null) {
    key += id;
  }
  key += JSON.stringify(req.query);
  return req.app.mem.get(key, function(err, val) {
    var cb;
    if (!err && val) {
      return res.json(JSON.parse(val));
    } else {
      cb = function(err, data) {
        if (!err) {
          req.app.mem.set(key, JSON.stringify(data));
          return res.json(data);
        } else {
          return res.json({
            err: err
          });
        }
      };
      if (popular != null) {
        return _this.getPopular(popular, ctx, cb);
      } else if (id != null) {
        if (similar != null) {
          return _this.getSimilar(id, similar, ctx, cb);
        } else {
          return _this.getBySlugOrId(id, ctx, cb);
        }
      } else if (query != null) {
        return _this.search(query, ctx, cb);
      } else {
        return _this.pagination(page, page_size, ctx, cb);
      }
    }
  });
};

Games.statics.put = function(req, res) {
  var changes, ctx, id, oid, thumbsDown, thumbsUp;
  ctx = req.ctx;
  id = req.params.id;
  if ((id != null) && id.match("^[0-9A-Fa-f]+$")) {
    oid = new ObjectId(id);
  }
  thumbsUp = req.query.thumbsUp;
  thumbsDown = Boolean(req.query.thumbsDown);
  changes = {};
  if (thumbsUp != null) {
    changes.thumbs_up = thumbsUp.localeCompare('true') === 0 ? 1 : -1;
  } else if (thumbsDown != null) {
    changes.thumbs_down = thumbsDown.localeCompare('true') === 0 ? 1 : -1;
  } else {
    return res.json({
      err: "unknown action"
    });
  }
  return this.update({
    $or: [
      {
        slug: id
      }, {
        _id: oid
      }
    ],
    site: ctx._id
  }, {
    $inc: changes
  }, {
    multi: false
  }, function(err) {
    if (err == null) {
      return res.send({
        success: true
      });
    } else {
      return res.send({
        err: err
      });
    }
  });
};

exports.model = mongoose.model('games', Games);

exports.methods = ["get", "put"];