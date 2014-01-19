// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require bootstrap
//= require turbolinks
//= require_tree .

imageIds = [];
numSnaps = 8;
swapQueue = [];
animations = ['flipInX', 'flipInY'];

var swapImage = function(el, snap){
  el.children('.time').children('span').html(snap.duration);
  el.css('background-image', 'url(' + snap.url + ')');
  animation = animations[Math.floor(Math.random() * animations.length)];
  el.addClass('animated ' + animation);
  el.children("div.flag").children("span").removeClass("flagged");
  el.removeClass("liked");
  el.children("div.like").remove();
  
  setTimeout(function() {
    el.removeClass('animated ' + animation);
  }, 500);
  countDown(el, snap.duration);

  var oldId = el.attr('data-id');

  imageIds = $.grep(imageIds, function(value) {
    return value != oldId;
  });

  if (snap.id != 0) {
    imageIds.push(snap.id);
  }
  el.attr('data-id', snap.id);
}

var createImage = function(el, snap){
  el.children('.time').children('span').html(snap.duration);
  el.css("background-image", "url(" + snap.url + ")");
  el.attr('data-id', snap.id);
  imageIds.push(snap.id);
  countDown(el, snap.duration);
}

var intro = function(){
  var doNext = function(i) { 
    if (i > numSnaps) {
      return;
    }

    getSnap((function(index) {
      return function(snap) {
        createImage($("#s"+index),snap);
        doNext(i + 1);
      }
    })(i));
  }
  doNext(1);
}

var getSnap = function(callback){
  var request = $.ajax({
    url: "/snap.json?" + Math.floor(5004567800*Math.random()) + "&not=" + imageIds.join(","),
    type: "GET"
  });

  request.done(function(response){
    callback(response);
  });
}

var processQueue = function() {
  if (swapQueue.length > 0) {
      el = swapQueue.pop();
      getSnap((function(tile) {
        return function(snap) {
          $('<img/>').attr('src', snap.url).load(function() {
            $(this).remove(); // prevent memory leaks as @benweet suggested
          });
          swapImage(tile, snap);
          setTimeout(processQueue, 100);
        }
      })(el));
    } else {
      setTimeout(processQueue, 100);
  }
  }

var countDown = function(el, duration){
    var imageWrapper = el;
    var timer = function() {
      time=time-1;
      if (time < 0) {
        clearInterval(counter);
        return;
      }
      if (time == 0){ 
        swapQueue.push(el);
      }
      timeEl.html(time);
    }
    
    var timeEl = imageWrapper.children('.time').children('span');
    var time = duration;
    var counter=setInterval(timer, 1000);
}

var modal = function(){
  if ($.cookie('snapwall') == null){
    $.cookie('snapwall', Math.floor(Math.random()*2345678));
    $('#myModal').modal();
  }else{
    console.log('NOPE');
  }
}

var setupFlags = function() {
  $(".flag").click(function() {
    if (!$(this).hasClass("flagged")) {
      var id = $(this).parent().attr('data-id');
      $.ajax({
          url: "/snap/" + id + "/flag",
          type: "GET"
      })
      $(this).children("span").addClass("flagged")
    }
  });
}

var setupLikes = function() {
  $("div.tile").dblclick(function() {
    if (!$(this).hasClass("liked")) {
      var id = $(this).attr("data-id");
      $.ajax({
          url: "/snap/" + id + "/like",
          type: "GET"
      });

      $(this).addClass("liked");
      $(this).append("<div class='like animated fadeIn'><span class='glyphicon glyphicon-heart'></span></div>");
      var thiz = $(this).children("div.like");
      setTimeout(function() {
        $(thiz).removeClass("animated fadeIn");
        $(thiz).addClass("animated fadeOut");
        setTimeout(function() {
          thiz.remove();
        }, 500);
      }, 1000)
    }
  });
}

$(function(){
  modal();
  setupFlags();
  setupLikes();
  intro();
  setTimeout(processQueue, 100);
});

