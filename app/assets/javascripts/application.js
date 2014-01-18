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
//= require turbolinks
//= require_tree .

imageIds = [];
numSnaps = 8;

var swapImage = function(el, snap){
  el.children('.time').children('span').html(snap.duration);
  el.children('img').attr('src',snap.url);
  countDown(el, snap.duration);

  var oldId = el.attr('data-id');

  imageIds = $.grep(imageIds, function(value) {
    return value != oldId;
  });

  var exists = imageIds.indexOf(snap.id);
  if (snap.id != 0 && exists < 0) {
    imageIds.push(snap.id);
  }
  
  el.attr('data-id',snap.id);
}

var createImage = function(el, snap){
  el.children('.time').children('span').html(snap.duration);
  el.append("<img src='" + snap.url + "'>");
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
        createImage($("#"+index),snap);
        doNext(i + 1);
      }
    })(i)
    );
  }
  doNext(1);
}

var getSnap = function(callback){
  console.log(imageIds);
  var request = $.ajax({
    url: "/snap.json?" + Math.floor(5004567800*Math.random()) + "&not=" + imageIds.join(","),
    type: "GET"
  });

  request.done(function(response){
    callback(response);
  });
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
        getSnap((function(tile) {
          return function(snap) {
            swapImage(tile,snap);
          }
        })(imageWrapper)
        );
      }
      timeEl.html(time);
    }
    
    var timeEl = imageWrapper.children('.time').children('span');
    var time = duration;
    var counter=setInterval(timer, 1000);
}


$(function(){
  intro();
  // ids = getIds();
});

