$(document).ready(function() {
  $('#employments_search input').keyup( function() {
    $.get($("#employments_search").attr("action"), $("#employments_search").serialize(), null, "script");
    return false;

  });
  $('html').bind('keypress', function(e)
    {
      if(e.keyCode == 13)
      {
      return false;
      }
    });
});
