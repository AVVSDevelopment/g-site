class GamesCollection extends Backbone.Collection
  url: '/api/v1.alpha/games'
  model : Game

  popular: ()->
    return [new Game, new Game, new Game, new Game, new Game, new Game]

  search: (query)->
    return _.map @models, (item)->
      item.toString = ()->
        JSON.stringify item.toJSON()
      item.toLowerCase = ()->
        item.name.toLowerCase()
      item.indexOf = (string) ->
        String::indexOf.apply item.name, arguments
      item.replace = (string) ->
        String::replace.apply item.name, arguments
      return item