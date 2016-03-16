$(document).ready(function(){

  // disable button if fields are empty on load
  fields_for_empty($('#email_to_verfiy'));
  fields_for_empty($('#phone_to_verify'));

  // disable or enable button if fields are empty or not
  $('#email_to_verfiy').change(function(){
    fields_for_empty($(this));
  });
  $('#phone_to_verify').change(function(){
    fields_for_empty($(this));
  });

  // send ajax request with email having verification code
  $('#user_email_verify_button').click(function(){
    var email = $('#email_to_verfiy').val();
    pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    l = Ladda.create(document.querySelector('#user_email_verify_button'));
    l.start();
    if (pattern.test(email))  
    {
      $.ajax({
      type: 'GET',
      data: {email: email},
      url: '/driver_verifications/email_token_generator',
      success: function(data) {
       if (data.success === true) {
            l.stop();
            $('#user_email_verify_button').attr('disabled', 'disabled');
          }
        else {
          l.stop();
          $('html, body').animate({
            scrollTop: 0
          }, 500);
        }
      },
      error: function(){
        l.stop();
      }
      });
    }
    else 
    {
      l.stop();
      $('#flash_for_verfication').removeClass('hidden');
      $('html, body').animate({
        scrollTop: 0
      }, 500);
    } 
  });

  // send ajax request sending the mail for phone validation code
  $('#user_phone_verify_button').click(function(){
    var l = Ladda.create( document.querySelector( '#user_phone_verify_button' ) );
      l.start();
      var number = $("#phone_to_verify").val();
      $.ajax({
      url: "/verify_phone_number",
      // dataType: "json",
      data: {
        "country_code": "0",
        "phone_number": number,
      },
      success: function (response) {
        if (response.success == true) {
          l.stop();
          $("#user_phone_verify_button").attr("disabled","disabled");
        } else {  
          // $("#flash_for_phone_verfication").removeClass('hidden');
          $('html, body').animate({
            scrollTop: 0
          }, 500);
          l.stop();
        }
      }
      });
  });
  
});

function fields_for_empty(element)
{
  if(element.val() ) {
    if(element.attr('id') == 'email_to_verfiy'){
      $('#user_email_verify_button').attr('disabled', false);
    }
    if(element.attr('id') == 'phone_to_verify'){
      $('#user_phone_verify_button').attr('disabled', false);
    }


  }
  else
  {
     if(element.attr('id') == 'phone_to_verify'){
      $('#user_phone_verify_button').attr('disabled', true);
    }
    if(element.attr('id') == 'email_to_verfiy'){
      $('#user_email_verify_button').attr('disabled', true);
    }    
  }
}