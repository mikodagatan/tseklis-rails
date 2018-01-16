$(document).on('turbolinks:load', function() {
  $('.edit-holiday-form').hide().removeClass('hide');
	$('.hide-edit-holiday').hide().removeClass('hide');

	$('.show-edit-holiday', this).click(function() {
   	$(this).parent().siblings(".edit-holiday-form").slideToggle();
   	$(this).toggle();
   	$(this).siblings(".hide-edit-holiday").toggle();
   });

	$('.hide-edit-holiday', this).click(function() {
	 	$(this).parent().siblings(".edit-holiday-form").slideToggle();
	 	$(this).siblings(".show-edit-holiday").toggle();
	 	$(this).toggle();
	 });
});
