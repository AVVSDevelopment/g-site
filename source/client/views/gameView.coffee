class GameView extends Backbone.View
  tagName: "div"
  className : "game"
  templateStr:'<a href="/games/{{=it.link}}">
      <img class="thumb" src="{{=it.thumbnail}}">
      <div class="name">{{=it.name}}</div>
    </a>'
  template: doT.template @::templateStr, undefined, {}
  render: ()->
    @$el.append @template @model
    return @$el




