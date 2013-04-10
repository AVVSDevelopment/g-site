var Game, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Game = (function(_super) {
  __extends(Game, _super);

  function Game() {
    _ref = Game.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Game.prototype.initialize = function() {
    var picnum;

    picnum = Math.floor(Math.random() * 3) + 1;
    this.thumbnail = '/static/img/thumb150_' + picnum + '.jpg';
    this.name = 'Default game name';
  };

  return Game;

})(Backbone.Model);

var GamesCollection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

GamesCollection = (function(_super) {
  __extends(GamesCollection, _super);

  function GamesCollection() {
    _ref = GamesCollection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  GamesCollection.prototype.model = Game;

  GamesCollection.prototype.url = '/games';

  /*
  fetch : ()->
    console.log "fetch!"
    i =0
    while i<50
      this.add new Game()
      i++
    parm = Backbone.Collection.prototype.fetch.call this
    return parm
  */


  return GamesCollection;

})(Backbone.Collection);

var AppView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AppView = (function(_super) {
  __extends(AppView, _super);

  function AppView() {
    _ref = AppView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  AppView.prototype.initialize = function() {
    this.el = $("div#appView");
  };

  AppView.prototype.render = function() {};

  AppView.prototype.addOne = function() {
    return console.log("ADDONE");
  };

  return AppView;

})(Backbone.View);

var GameView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

GameView = (function(_super) {
  __extends(GameView, _super);

  function GameView() {
    _ref = GameView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  GameView.prototype.tagName = "div";

  GameView.prototype.className = "game";

  GameView.prototype.initialize = function(game) {
    return this.model = game;
  };

  GameView.prototype.render = function() {
    $(this.el).append("<a href='#'><img class='thumb' src='" + this.model.thumbnail + "'><div class='name'>" + this.model.name + "</div></a>");
    return this.el;
  };

  return GameView;

})(Backbone.View);

var GamesView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

GamesView = (function(_super) {
  __extends(GamesView, _super);

  function GamesView() {
    _ref = GamesView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  GamesView.prototype.initialize = function(games) {
    var _this = this;

    _.bindAll(this, "render");
    this.el = $("#games");
    this.collection = games;
    this.listenTo(this.collection, 'add', this.appendGame);
    return this.infiniScroll = new Backbone.InfiniScroll(this.collection, {
      strict: false,
      scrollOffset: 200,
      error: function() {
        var i, _results;

        i = 0;
        _results = [];
        while (i < 20) {
          _this.collection.add(new Game());
          _results.push(i++);
        }
        return _results;
      }
    });
  };

  GamesView.prototype.render = function() {
    this.collection.forEach(function(game) {
      return this.renderNewGame(game);
    });
    return this.el;
  };

  GamesView.prototype.appendGame = function(game, games, options) {
    var gameview;

    gameview = new GameView(game);
    $(this.el).append(gameview.render());
    return this.el;
  };

  GamesView.prototype.remove = function() {
    this.infiniScroll.destroy();
    return Backbone.View.prototype.remove.call(this);
  };

  return GamesView;

})(Backbone.View);

$(function() {
  var center_games, games, gamesView, initFullScreen,
    _this = this;

  games = new GamesCollection();
  gamesView = new GamesView(games);
  center_games = function() {
    var margin;

    initFullScreen();
    margin = ($(window).width() - $("#games").width() - 10) / 2;
    return $(".content").css("margin-left", margin);
  };
  initFullScreen = function() {
    var i;

    if ($("body").height() > $(window).height()) {
      return;
    }
    i = 0;
    while (i < 40) {
      games.add(new Game());
      i++;
    }
    return setTimeout(initFullScreen, 100);
  };
  center_games();
  $(document).ready(function() {
    $(window).resize(center_games);
    return setTimeout(center_games, 200);
  });
});
