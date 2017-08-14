$(document).ready(function(){
	$('.datepicker').pickadate();
	$('.select2').select2();

	// password edit form
	$('#password-edit-form').hide();
	$('#hide-password-settings').hide();
	$('#show-password-settings').click(function() {
   	$('#password-edit-form').show();
   	$('#show-password-settings').hide();
   	$('#hide-password-settings').show();
   });
	$('#hide-password-settings').click(function() {
	 	$('#password-edit-form').hide();
	 	$('#show-password-settings').show();
	 	$('#hide-password-settings').hide();
	 });

});