class Game extends Backbone.Model
  url: ()->
    base = '/api/v1.alpha/games/'
    if @has "_id"
      return  base + @get "_id"
    else if @has "slug"
      return base + @get "slug"
    else
      return base

  idAttribute: "_id"

  thumbsUp: (isInc)->
    $.ajax
      url: @url()+"?thumbsUp="+isInc
      type: 'PUT'

  thumbsDown: (isDec)->
    $.ajax
      url: @url()+"?thumbsDown="+isDec
      type: 'PUT'



