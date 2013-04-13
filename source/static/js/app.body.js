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
    this.link = 'default-game-name';
    this.swf_link = 'game/swf/link.swf';
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

var GamePageView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

GamePageView = (function(_super) {
  __extends(GamePageView, _super);

  function GamePageView() {
    _ref = GamePageView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  GamePageView.prototype.id = "GamePage";

  GamePageView.prototype.templateStr = '<div class="game-page-body">\
    <div class="games-list popular">\
      <div class="top">Popular games</div>\
      <div class="panel-content"></div>\
    </div>\
    <div class="game-window">\
      <div class="top">\
        <a href="/" class="typicn previous"></a>\
        <span class="game-name">{{=it.name}}</span>\
        <a href="#" class="typicn thumbsUp"></a>\
        <a href="#" class="typicn thumbsDown"></a>\
        <a href="#" class="typicn heart"></a>\
      </div>\
      <div class="panel-content">{{=it.swf_link}}</div>\
    </div>\
    <div class="games-list similar">\
      <div class="top">Similar games</div>\
      <div class="panel-content"></div>\
    </div>\
    <div class="ad">\
      <div class="top">Advertisment</div>\
      <div class="panel-content"></div>\
    </div>\
  </div>';

  GamePageView.prototype.template = doT.template(GamePageView.prototype.templateStr, void 0, {});

  GamePageView.prototype.events = {
    'click .heart': 'like',
    'click .thumbsUp': 'thumbsUp',
    'click .thumbsDown': 'thumbsDown'
  };

  GamePageView.prototype.render = function() {
    this.$el.html(this.template(this.model));
    return this.$el;
  };

  GamePageView.prototype.like = function() {
    return console.log('like');
  };

  GamePageView.prototype.thumbsUp = function() {
    return console.log('thumbsUp');
  };

  GamePageView.prototype.thumbsDown = function() {
    return console.log('thumbsDown');
  };

  return GamePageView;

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

  GameView.prototype.templateStr = '<a href="/games/{{=it.link}}">\
      <img class="thumb" src="{{=it.thumbnail}}">\
      <div class="name">{{=it.name}}</div>\
    </a>';

  GameView.prototype.template = doT.template(GameView.prototype.templateStr, void 0, {});

  GameView.prototype.render = function() {
    this.$el.append(this.template(this.model));
    return this.$el;
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

  GamesView.prototype.el = "div#games";

  GamesView.prototype.initialize = function() {
    var _this = this;

    this.listenTo(this.collection, 'add', this.appendGame);
    this.infiniScroll = new Backbone.InfiniScroll(this.collection, {
      strict: false,
      scrollOffset: 600,
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
    return this.render();
  };

  GamesView.prototype.render = function() {
    this.collection.forEach(function(game) {
      return this.appendGame(game);
    });
    return this.$el;
  };

  GamesView.prototype.appendGame = function(game, games, options) {
    var gameview;

    gameview = new GameView({
      model: game
    });
    this.$el.append(gameview.render());
    return this.$el;
  };

  GamesView.prototype.remove = function() {
    this.infiniScroll.destroy();
    return Backbone.View.prototype.remove.call(this);
  };

  return GamesView;

})(Backbone.View);

var App, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

App = (function(_super) {
  __extends(App, _super);

  function App() {
    this.initFullScreen = __bind(this.initFullScreen, this);
    this.center_games = __bind(this.center_games, this);    _ref = App.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  App.prototype.initialize = function() {
    this.games = new GamesCollection();
    this.gamesView = new GamesView({
      collection: this.games
    });
    this.gamePageView = new GamePageView({
      el: $("#GamePage")
    });
    return this.initFullScreen();
  };

  App.prototype.center_games = function() {
    var margin;

    this.initFullScreen();
    margin = ($(window).width() - $("#games").width() - 10) / 2;
    if (margin > 40) {
      margin = 0;
    }
    return $(".content").css("margin-left", margin);
  };

  App.prototype.initFullScreen = function() {
    var i;

    if ($("body").height() > $(window).height()) {
      return;
    }
    i = 0;
    while (i < 50) {
      this.games.add(new Game());
      i++;
    }
    return setTimeout(this.initFullScreen, 100);
  };

  App.prototype.routes = {
    "games/:game_link": "gamepage",
    "": "index"
  };

  App.prototype.init = function() {};

  App.prototype.index = function() {
    return this.gamePageView.$el.modal('hide');
  };

  App.prototype.gamepage = function(game_link) {
    this.gamePageView.model = this.games.find(function(game) {
      return game.link === game_link;
    });
    return this.gamePageView.render().modal('show');
  };

  return App;

})(Backbone.Router);

$(function() {
  var app;

  app = new App();
  $(window).resize(app.center_games);
  setTimeout(app.center_games, 200);
  Backbone.history.start({
    pushState: true
  });
  return $(document).delegate("a", "click", function(e) {
    var href, uri;

    if (e.currentTarget.getAttribute("nobackbone")) {
      return;
    }
    href = e.currentTarget.getAttribute('href');
    if (!href) {
      return true;
    }
    if (href[0] === '/') {
      uri = Backbone.history._hasPushState ? e.currentTarget.getAttribute('href').slice(1) : "!/" + e.currentTarget.getAttribute('href').slice(1);
      app.navigate(uri, {
        trigger: true
      });
      return false;
    }
  });
});
