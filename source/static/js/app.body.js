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

  AppView.prototype.el = $("div#appView");

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
    $(this.el).append("<img class='thumb' src='" + this.model.thumbnail + "'>");
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
    this.el = $("#games");
    this.model = games;
    return this.listenTo(games, 'add', this.renderNewGame);
  };

  GamesView.prototype.render = function() {
    return this;
  };

  GamesView.prototype.renderNewGame = function(game, games, options) {
    var gameview;

    gameview = new GameView(game);
    $(this.el).append(gameview.render());
    return this.el;
  };

  return GamesView;

})(Backbone.View);

$(function() {
  var center_games, games, gamesView, i;

  games = new GamesCollection();
  gamesView = new GamesView(games);
  gamesView.render();
  i = 0;
  while (i < 100) {
    games.add(new Game());
    i++;
  }
  center_games = function() {
    var margin;

    margin = ($(window).width() - $("#games").width()) / 2;
    return $(".content").css("margin-left", margin);
  };
  $(document).ready(function() {
    $(window).resize(center_games);
    return center_games();
  });
});
