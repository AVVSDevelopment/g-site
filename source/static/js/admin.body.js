var buttonError, buttonSuccess, getDomain, trimInput;

getDomain = function() {
  var domain;

  domain = window.location.pathname.split("/");
  return domain[domain.length - 1];
};

trimInput = function(o) {
  return o.val($.trim(o.val()));
};

buttonSuccess = function(o, cb) {
  return $(o).html("<i class='icon-ok icon-white'></i>").delay(2000).queue(function(next) {
    cb();
    return next();
  });
};

buttonError = function(o, cb) {
  return $(o).html("<i class='icon-remove icon-white'></i> Error!").delay(2000).queue(function(next) {
    cb();
    return next();
  });
};

$(".toggle-site").click(function(e) {
  var enabled,
    _this = this;

  if ($(this).hasClass("disabled")) {
    return false;
  }
  $(this).html("<i class='icon-refresh icon-white'></i>");
  $(this).addClass("disabled");
  enabled = $(this).attr("data-enabled") !== "true";
  $.ajax({
    type: 'PUT',
    url: "" + api + "/sites/" + (getDomain()),
    data: {
      enable: enabled
    },
    success: function(err) {
      if (!err) {
        return buttonSuccess(_this, function() {
          if (enabled) {
            return $(_this).html("Suspend").removeClass("disabled btn-success").addClass("btn-danger").attr("data-enabled", true);
          } else {
            return $(_this).html("Activate").removeClass("disabled btn-danger").addClass("btn-success").attr("data-enabled", false);
          }
        });
      } else {
        return buttonError(_this, function() {
          if (enabled) {
            return $(_this).removeClass("disabled").html("Activate");
          } else {
            return $(_this).removeClass("disabled").html("Suspend");
          }
        });
      }
    },
    error: function() {
      return buttonError(_this, function() {
        if (enabled) {
          return $(_this).removeClass("disabled").html("Activate");
        } else {
          return $(_this).removeClass("disabled").html("Suspend");
        }
      });
    }
  });
  return false;
});

$(".save").click(function(e) {
  var changes,
    _this = this;

  if ($(this).hasClass("disabled")) {
    return false;
  }
  $(this).html("<i class='icon-refresh icon-white'></i>");
  $(this).addClass("disabled");
  changes = {};
  $(this).parent().parent().find("input").each(function() {
    trimInput($(this));
    return changes[$(this).attr("name")] = $(this).val();
  });
  $(this).parent().parent().find("textarea").each(function() {
    trimInput($(this));
    return changes[$(this).attr("name")] = $(this).val();
  });
  if (!($.trim($("#inputDomain").val()).length > 0)) {
    $("#inputDomain").parent().parent().addClass("error");
    return false;
  } else {
    $("#inputDomain").parent().parent().removeClass("error");
  }
  $.ajax({
    type: 'PUT',
    url: "" + api + "/sites/" + (getDomain()),
    data: changes,
    success: function(err) {
      if (!err) {
        return buttonSuccess(_this, function() {
          return $(_this).html("Save").removeClass("disabled");
        });
      } else {
        return buttonError(_this, function() {
          return $(this).html("Save").removeClass("disabled");
        });
      }
    },
    error: function() {
      return buttonError(_this, function() {
        return $(this).html("Save").removeClass("disabled");
      });
    }
  });
  return false;
});
