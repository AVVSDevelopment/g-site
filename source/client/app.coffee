$ ()->
  games = new GamesCollection()
  gamesView = new GamesView(games)
  gamesView.render()
  i =0
  while i<100
    games.add new Game()
    i++



  #App = new AppView()
  #App.listenTo games, 'add', App.addOne()
  #App.render()

  center_games = ()->
    margin = ($(window).width() - $("#games").width())/2
    $(".content").css "margin-left", margin


  $(document).ready ()->
    $(window).resize center_games
    center_games()

  return