$(document).ready(function(){

	$('.datepickerstart').pickadate({
		format: 'yyyy/mm/dd',
		selectMonths: true,
		selectYears: 60,
		max: true,
		});

	$('.datepickerend').pickadate({
		format: 'yyyy/mm/dd',
		min: true
	});

	$('.timepickerstart').pickatime({

		});

	$('.timepickerend').pickatime({

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

	// Company Leave Settings form


	$('#company-leave-settings-edit-form').hide();
	$('#hide-company-leave-settings').hide();
	$('#show-company-leave-settings').click(function() {
   	$('#company-leave-settings-edit-form').show();
   	$('#show-company-leave-settings').hide();
   	$('#hide-company-leave-settings').show();
   });
	
	$('#hide-company-leave-settings').click(function() {
	 	$('#company-leave-settings-edit-form').hide();
	 	$('#show-company-leave-settings').show();
	 	$('#hide-company-leave-settings').hide();
	 });

	// Holiday settings

	// Company Leave Settings form

	$('.edit-holiday-form').hide();
	$('.hide-edit-holiday').hide();

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