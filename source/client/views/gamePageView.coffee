class GamePageView extends Backbone.View
  id: "GamePage"
  templateStr:'<div class="game-page-body">
    <div class="games-list popular">
      <div class="top">Popular games</div>
      <div class="panel-content"></div>
    </div>
    <div class="game-window">
      <div class="top">
        <a href="/" class="typicn previous"></a>
        <span class="game-name">{{=it.name}}</span>
        <a href="#" class="typicn thumbsUp"></a>
        <a href="#" class="typicn thumbsDown"></a>
        <a href="#" class="typicn heart"></a>
      </div>
      <div class="panel-content">{{=it.swf_link}}</div>
    </div>
    <div class="games-list similar">
      <div class="top">Similar games</div>
      <div class="panel-content"></div>
    </div>
    <div class="ad">
      <div class="top">Advertisment</div>
      <div class="panel-content"></div>
    </div>
  </div>'
  template: doT.template @::templateStr, undefined, {}
  events: {
    'click .heart': 'like'
    'click .thumbsUp': 'thumbsUp'
    'click .thumbsDown': 'thumbsDown'
  }
  render: ()->
    @$el.html @template @model
    return @$el

  like: ()->
    console.log 'like'

  thumbsUp: ()->
    console.log 'thumbsUp'

  thumbsDown: ()->
    console.log 'thumbsDown'

