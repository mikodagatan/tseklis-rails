$(document).ready(function(){

	$('.datepickerstart').pickadate({
		format: 'yyyy/mm/dd',
		selectMonths: true,
		selectYears: 60,
		max: true,
		});

	$('.datepickerend').pickadate({
		format: 'yyyy/mm/dd',
		selectMonths: true,
		selectYears: 5,
		min: true
	});

	$('.select-select').select2();

	// password edit form
	$('#password-edit-form').hide();
	$('#hide-password-settings').hide();

	$('#show-password-settings').click(function(){
   	$('#password-edit-form').show();
   	$('#show-password-settings').hide();
   	$('#hide-password-settings').show();
   });
	$('#hide-password-settings').click(function() {
	 	$('#password-edit-form').hide();
	 	$('#show-password-settings').show();
	 	$('#hide-password-settings').hide();
	 });
	 	// Address edit form

	$('#address-edit-form').hide();
	$('#hide-address-settings').hide();

	$('#show-address-settings').click(function() {
   	$('#address-edit-form').show();
   	$('#show-address-settings').hide();
   	$('#hide-address-settings').show();
   });

	$('#hide-address-settings').click(function() {
	 	$('#address-edit-form').hide();
	 	$('#show-address-settings').show();
	 	$('#hide-address-settings').hide();
	 });

		// Leave Type edit form


	$('#leave-type-edit-form').hide();
	$('#hide-leave-type-settings').hide();

	$('#show-leave-type-settings').click(function() {
   	$('#leave-type-edit-form').show();
   	$('#show-leave-type-settings').hide();
   	$('#hide-leave-type-settings').show();
   });
	
	$('#hide-leave-type-settings').click(function() {
	 	$('#leave-type-edit-form').hide();
	 	$('#show-leave-type-settings').show();
	 	$('#hide-leave-type-settings').hide();
	 });
});