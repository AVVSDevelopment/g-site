class GamesView extends Backbone.View

  initialize: (games)->
    _.bindAll(@, "render");
    @el = $ "#games"
    @collection = games
    @listenTo @collection, 'add', @appendGame
    @infiniScroll = new Backbone.InfiniScroll @collection, {
      strict: false
      scrollOffset: 200
      error: ()=> #fetch will be error
        i =0
        while i<20
          @collection.add new Game()
          i++
    }

  render: ()->
    @collection.forEach (game)->
      @renderNewGame(game)
    return @el

  appendGame: (game, games, options)->
    gameview = new GameView(game);
    $(@el).append gameview.render()
    return @el

  remove: ()->
    @infiniScroll.destroy()
    return Backbone.View.prototype.remove.call @



