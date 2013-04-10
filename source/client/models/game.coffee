class Game extends Backbone.Model
  initialize: ()->
    picnum = Math.floor(Math.random() * 3) + 1
    @thumbnail = '/static/img/thumb150_' + picnum + '.jpg'
    @name = 'Default game name'
    return


