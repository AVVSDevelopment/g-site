class GamesView extends Backbone.View
  initialize: (games)->
    this.el = $ "#games"
    this.model = games
    this.listenTo games, 'add', this.renderNewGame
  render: ()->
    return this
  renderNewGame: (game, games, options)->
    gameview = new GameView(game);
    $(this.el).append gameview.render()
    return this.el



