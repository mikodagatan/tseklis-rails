$(document).on('turbolinks:load', function() {
  $('#hr-dashboard').hide().removeClass("hide");
  $('#show-hr-dashboard').click(function(){
    $('#hr-dashboard').slideToggle();
  });
  $('#manager-dashboard').hide().removeClass("hide");
  $('#show-manager-dashboard').click(function(){
    $('#manager-dashboard').slideToggle();
  });
});
