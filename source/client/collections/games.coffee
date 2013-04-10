class GamesCollection extends Backbone.Collection
  model : Game
  url: '/games'
  ###
  fetch : ()->
    console.log "fetch!"
    i =0
    while i<50
      this.add new Game()
      i++
    parm = Backbone.Collection.prototype.fetch.call this
    return parm
  ###