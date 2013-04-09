class GameView extends Backbone.View
  tagName: "div"
  className: "game"
  initialize: (game)->
    this.model = game
  render: ()->
    #$(this.el).append "<img class='thumb' src='#{this.model.thumbnail}'><div class='name'>#{this.model.name}</div>"
    $(this.el).append "<img class='thumb' src='#{this.model.thumbnail}'>"
    return this.el



