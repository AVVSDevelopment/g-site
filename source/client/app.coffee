$ ()->
  games = new GamesCollection()
  gamesView = new GamesView(games)




  #center games div
  center_games = ()->
    initFullScreen() #for situation from tiny to large screen resize
    margin = ($(window).width() - $("#games").width() - 10)/2
    $(".content").css "margin-left", margin

  #Init full screen of games, toolbar must appear
  initFullScreen = ()=>
    if $("body").height() > $(window).height() then return
    i = 0
    while i<40
      games.add new Game()
      i++
    setTimeout initFullScreen, 100

  center_games()
  $(document).ready ()->
    $(window).resize center_games
    setTimeout center_games, 200


  return