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

var getTileId = function(el){
  return el.attr('id');  
}

var getIds = function(){
  arr = []
  $('.tile').each(function(){
    arr.push( getTileId($(this)) );
  });
  return arr.join(',');
}

var getSnap = function(el, not){
  var request = $.ajax({
    url: "/snap.json",
    type: "GET",
    data: { not : ids }
  });

  request.done(function(response){
    el.children('img').attr('src',response.url);
    el.children('.time').children('span').html(response.duration);
    countDown();
  });
}

var countDown = function(){
  $('.tile').each(function(){
    var imageWrapper = $(this);
    var timer = function() {
      time=time-1;
      if (time < 0) {
        clearInterval(counter);
        return;
      }
      if (time == 0){ 
        getSnap(imageWrapper, 12);
      }
      timeEl.html(time);
    }
    
    var timeEl = imageWrapper.children('.time').children('span');
    var time = timeEl.html().trim();
    var counter=setInterval(timer, 1000);
  });
}


$(function(){
  ids = getIds();
  countDown();
});

