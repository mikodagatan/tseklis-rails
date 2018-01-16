$(document).on('turbolinks:load', function() {

  $('#instructions').hide().removeClass("hide");
  $('#show_instructions').click(function(){
    $('#instructions').slideToggle('right');
  });
});
