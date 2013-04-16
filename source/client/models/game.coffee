class Game extends Backbone.Model
  idAttribute: "_id"
  initialize: ()->
    picnum = Math.floor(Math.random() * 3) + 1
    @set "_id", Math.floor(Math.random() * 1000000)
    @set "thumbnail", '/static/img/thumb150_' + picnum + '.jpg'
    @set "name", 'This is long default game name with number ' + @get "_id"
    @set "link", 'default-game-link-' + @get "_id"
    #@set "swf_link", 'http://static4.kizi.com/system/static/games/sticky-ninja-academy.swf?1366025167'
    @set "swf_link", 'http://www.mousebreaker.com/games/parking/INSKIN__parking-v1.1_Secure.swf'
    @set "similar", [Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000)]
    return

  #methed for development
  twin: (id)->
    @set "_id", id
    @set "name", 'This is long default game name with number ' + @get "_id"
    @set "link", 'default-game-link-' + @get "_id"
    #@set "swf_link", 'http://static4.kizi.com/system/static/games/sticky-ninja-academy.swf?1366025167'
    @set "swf_link", 'http://www.mousebreaker.com/games/parking/INSKIN__parking-v1.1_Secure.swf'
    @set "similar", [Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000),
                     Math.floor(Math.random() * 1000000)]


