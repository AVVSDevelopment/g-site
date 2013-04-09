class Game extends Backbone.Model
  initialize: ()->
    picnum = Math.floor(Math.random() * 3) + 1
    this.thumbnail = '/static/img/thumb150_' + picnum + '.jpg'
    this.name = 'Default game name'
    return


