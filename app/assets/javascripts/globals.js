$(document).ready(function(){
	$('.datepicker.start').pickadate({
		format: 'mm/dd/yyyy',
		selectMonths: true,
		selectYears: 60,
		max: true
	});

	$('.datepicker.end').pickadate({
		format: 'mm/dd/yyyy',
		selectMonths: true,
		selectYears: 10,
		max: true
	});



	$('.select-select').select2();

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