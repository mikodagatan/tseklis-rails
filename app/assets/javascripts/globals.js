$(document).ready(function(){

	$('.datepickerstart').pickadate({
		format: 'mm/dd/yyyy',
		selectMonths: true,
		selectYears: 60,
		max: true,
		});

	$('.datepickerend').pickadate({
		format: 'mm/dd/yyyy',
		selectMonths: true,
		selectYears: 5,
		min: true
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