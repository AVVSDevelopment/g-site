class GamesView extends Backbone.View
  el: "div#games"

  initialize: ()->
    #_.bindAll @, "render"
    @listenTo @collection, 'add', @appendGame
    @infiniScroll = new Backbone.InfiniScroll @collection, {
      strict: false
      scrollOffset: 600
      error: ()=> #fetch will be error
        i = 0
        while i<20
          @collection.add new Game()
          i++
    }
    @render()

  render: ()->
    @collection.forEach (game)->
      @appendGame(game)
    return @$el

  appendGame: (game, games, options)->
    gameview = new GameView {model : game}
    @$el.append gameview.render()
    return @$el

  remove: ()->
    @infiniScroll.destroy()
    return Backbone.View.prototype.remove.call @



