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

var getSnap = function(el, not){
  console.log("hi");

  var request = $.ajax({
    url: "/snap.json",
    type: "GET",
    data: { not : this.not }
  });

  request.done(function(response){
    // console.log(el.children('img').attr('src',response.url));
    // console.log(el.children('.time').html(response.duration));
  });
}

$(function(){
  
  $('.image-wrapper:first').each(function(){
    var timer = function() {
      time=time-1;
      if (time <= 0) {
        clearInterval(counter);
        //counter ended, do something here
        return;
      }
      console.log(time);
    }

    var time = $(this).children(".time").html().trim();
    var counter=setInterval(timer, 1000); //1000 will  run it every 1 second
  });
});

