class App extends Backbone.Router
  initialize: ->
    @bind 'route', @_trackPageview
    @games = new GamesCollection()
    #init games collection from html
    _.each $('.game'), (game_el)->
      game = new Game
      slug = $(game_el).find('a').attr 'href'
      game.set
        title: $(game_el).find('div.name').html()
        image_url: $(game_el).find('img.thumb').attr 'src'
        slug: slug.substr(slug.lastIndexOf('/') + 1)
      gameView = new GameView
        model:game
        el:game_el
      @add game
    , @games

    @gamesView = new GamesView {collection:@games}
    @gamePageView = new GamePageView el: $ "#GamePage"
    @initFullScreen()

  #center games div
  center_games: =>
    if $("body").height() < $(window).height() then @initFullScreen() #for situation from tiny to large screen resize
    margin = ($(window).width() - $("#games").width() - 10)/2
    if margin>40 then margin = 0
    $(".content").css "margin-left", margin

  #Init full screen of games, scrollbar must appear
  initFullScreen: =>
    $(window).scroll()
    if $("body").height() > $(window).height() then return
    setTimeout @initFullScreen, 100

  _trackPageview: ->
    url = Backbone.history.getFragment()
    if not /^\//.test(url) and url isnt ""
      url = "/" + url
    ga('send', 'pageview', url);

  routes:{
    "games/:game_link": "gamepage"
    "": "index"
  }

  init: ->
    return

  index: ->
    $('body').removeClass "no-scroll"
    $('#GamePage').hide()
    $('#GamePageBackdrop').hide()
    @gamePageView.deleteSwfObject()
    $(window).resize()

  gamepage: (game_link)->
    $('#GamePageBackdrop').show()
    slug = game_link.substr(game_link.lastIndexOf('/') + 1)
    @gamePageView.model = new Game {slug:slug}
    @gamePageView.model.fetch
      success: =>
        @gamePageView.model.fetchPopularAndSimilar
          success: =>
            $('#GamePage').replaceWith @gamePageView.render()
            @gamePageView.setupSwfObject()
            $('#GamePage').show()
            $('body').addClass "no-scroll"
          error: ->
            $('#GamePageBackdrop').hide()
      error: ->
        $('#GamePageBackdrop').hide()



$ () ->
  window.app = new App()
  $(window).resize app.center_games
  setTimeout app.center_games, 200


  Backbone.history.start {pushState: true, silent: true}
  $(document).delegate "a", "click", (e)->
    if e.currentTarget.getAttribute("nobackbone") then return
    href = e.currentTarget.getAttribute('href')
    return true unless href

    if href[0] is '/'
      uri = if Backbone.history._hasPushState then e.currentTarget.getAttribute('href').slice(1) else "!/"+e.currentTarget.getAttribute('href').slice(1)
      app.navigate uri, {trigger:true}
      return false

  $(document).delegate "*[data-tracking-action]", "click", (e)->
    ga 'send', 'event',
      $(this).attr("data-tracking-category"),
      $(this).attr("data-tracking-action"),
      $(this).attr("data-tracking-label"),
      $(this).attr("data-tracking-value")


  $('.search-bar .search-query').typeahead
    source: app.games.search
    matcher: ()-> true
    sorter: (items)->items
    highlighter: (game)->
      gv = new GameView {model:game}
      return gv.render()
    updater: (itemString) =>
      item = JSON.parse(itemString)
      app.navigate '/games/'+item.slug, {trigger:true}
      return
    items: 8
