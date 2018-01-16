$(document).on('turbolinks:load', function() {
  // password edit form
	$('#password-edit-form').hide().removeClass('hide');
	$('#hide-password-settings').hide().removeClass('hide');

	$('#show-password-settings').click(function(){
   	$('#password-edit-form').slideToggle();
   	$('#show-password-settings').toggle();
   	$('#hide-password-settings').show();
   });
	$('#hide-password-settings').click(function() {
	 	$('#password-edit-form').slideToggle();
	 	$('#show-password-settings').show();
	 	$('#hide-password-settings').hide();
	 });
	 	// Address edit form

	$('#address-edit-form').hide().removeClass('hide');
	$('#show-address-settings').click(function() {
   	$('#address-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#company-leave-settings-edit-form').hide();
   });

		// Leave Type edit form

	$('#leave-type-edit-form').hide().removeClass('hide');
	$('#show-leave-type-settings').click(function() {
   	$('#leave-type-edit-form').slideToggle();
    $('#company-leave-settings-edit-form').hide();
    $('#address-edit-form').hide();
   });

	// Company Leave Settings form

	$('#company-leave-settings-edit-form').hide().removeClass('hide');
	$('#show-company-leave-settings').click(function() {
   	$('#company-leave-settings-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#address-edit-form').hide();
   });

	 // Department leave settings form

 	$('#departments-edit-form').hide().removeClass('hide');
 	$('#show-department-settings').click(function() {
  	$('#departments-edit-form').slideToggle();
   	$('#leave-type-edit-form').hide();
   	$('#address-edit-form').hide();
  });
});
