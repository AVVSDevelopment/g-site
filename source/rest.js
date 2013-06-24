var Rest, mongoose,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

mongoose = require('mongoose');

Rest = (function(_super) {

  __extends(Rest, _super);

  function Rest(args) {
    Rest.__super__.constructor.call(this, args);
    this.statics.get = function(req, res, next) {
      var id;
      id = req.params.id;
      return this.findOne({
        _id: id
      }, function(err, item) {
        if (err == null) {
          return res.json(item);
        } else {
          return res.json({
            err: err
          });
        }
      });
    };
    this.statics.put = function(req, res, next) {
      console.log("PUT");
      return res.send('PUT');
    };
    this.statics["delete"] = function(req, res, next) {
      console.log("DELETE");
      return res.send('DELETE');
    };
    this.statics.post = function(req, res, next) {
      console.log("POST");
      return res.send('POST');
    };
    this.statics.patch = function(req, res, next) {
      console.log("PATCH");
      return res.send('PATCH');
    };
  }

  return Rest;

})(mongoose.Schema);

module.exports = Rest;