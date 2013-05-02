getDomain = ()->
  domain = window.location.pathname.split "/"
  domain[domain.length-1]

trimInput = (o)->
  o.val $.trim o.val()

buttonSuccess = (o, cb)->
  $(o).html("<i class='icon-ok icon-white'></i>").delay(2000).queue (next)->
    cb()
    next()

buttonError = (o, cb)->
  $(o).html("<i class='icon-remove icon-white'></i> Error!").delay(2000).queue (next)->
    cb()
    next()

$(".toggle-site").click (e)->
  if $(@).hasClass "disabled"
    return false
  $(@).html "<i class='icon-refresh icon-white'></i>"
  $(@).addClass "disabled"
  enabled = $(@).attr("data-enabled") isnt "true"
  $.ajax
    type:'PUT'
    url: "#{api}/sites/#{getDomain()}"
    data:
      enable: enabled
    success: (err)=>
      unless err
        buttonSuccess @, ()=>
          if enabled
            $(@).html("Suspend").removeClass("disabled btn-success").addClass("btn-danger").attr "data-enabled", true
          else
            $(@).html("Activate").removeClass("disabled btn-danger").addClass("btn-success").attr "data-enabled", false
      else
        buttonError @, ()=>
          if enabled
            $(@).removeClass("disabled").html "Activate"
          else
            $(@).removeClass("disabled").html "Suspend"
    error: ()=>
      buttonError @, ()=>
        if enabled
          $(@).removeClass("disabled").html "Activate"
        else
          $(@).removeClass("disabled").html "Suspend"

  return false

$(".save").click (e)->
  if $(@).hasClass "disabled"
    return false
  $(@).html "<i class='icon-refresh icon-white'></i>"
  $(@).addClass "disabled"

  changes = {}

  $(@).parent().parent().find("input").each ()->
    trimInput $ @
    changes[$(@).attr("name")] = $(@).val()
  $(@).parent().parent().find("textarea").each ()->
    trimInput $ @
    changes[$(@).attr("name")] = $(@).val()


  unless $.trim($("#inputDomain").val()).length > 0
    $("#inputDomain").parent().parent().addClass "error"
    return false
  else
    $("#inputDomain").parent().parent().removeClass "error"

  $.ajax
    type:'PUT'
    url: "#{api}/sites/#{getDomain()}"
    data: changes
    success: (err)=>
      unless err
        buttonSuccess @, ()=> $(@).html("Save").removeClass("disabled")
      else
        buttonError @, ()-> $(@).html("Save").removeClass("disabled")
    error: ()=>
      buttonError @, ()-> $(@).html("Save").removeClass("disabled")

  return false
