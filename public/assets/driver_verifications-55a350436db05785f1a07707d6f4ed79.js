(function() {
  var readURL, readURLCar;

  readURL = function(input) {
    var reader;
    if (input.files && input.files[0]) {
      reader = new FileReader;
      reader.onload = function(e) {
        $('#image_upload_preview').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  };

  readURLCar = function(input) {
    var reader;
    if (input.files && input.files[0]) {
      reader = new FileReader;
      reader.onload = function(e) {
        $('#car_image_upload_preview').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  };

  $(document).ready(function() {
    $('#inputFile').change(function() {
      readURL(this);
    });
    $('#inputFilecar').change(function() {
      readURLCar(this);
    });
  });

  $(document).ready(function() {
    var email_verify_flag, enable_continue_button, phone_verify_flag;
    email_verify_flag = false;
    phone_verify_flag = false;
    enable_continue_button = function(email_flag, phone_flag) {
      if (email_flag === true && phone_flag === true) {
        $('#verify_pin_button').prop('disabled', false);
      }
    };
    $.ajax({
      url: '/driver_verifications/check_email_verified',
      type: 'GET',
      dataType: 'json',
      async: false,
      success: function(response) {
        if (response.success === true) {
          return email_verify_flag = true;
        }
      }
    });
    $.ajax({
      url: '/driver_verifications/check_phone_verified',
      type: 'GET',
      dataType: 'json',
      async: false,
      success: function(response) {
        if (response.success === true) {
          return phone_verify_flag = true;
        }
      }
    });
    enable_continue_button(email_verify_flag, phone_verify_flag);
    $('#tab1_button').on('click', function() {
      $('#start_tab').removeClass('active');
      return $('#tab1').addClass('active');
    });
    $('#email_code_send').click(function() {
      var l, mail, pattern;
      mail = document.getElementById('driver_verification_email').value;
      pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
      if (pattern.test(mail)) {
        $('#driver_verification_update_email').val(mail);
        l = Ladda.create(document.querySelector('#email_code_send'));
        l.start();
        return $.ajax({
          type: 'GET',
          data: {
            email: mail
          },
          url: '/driver_verifications/email_token_generator',
          success: function(data) {
            if (data.success === true) {
              l.stop();
              $('#email_code_send').attr('disabled', 'disabled');
              return $('#verify_email_code').prop('disabled', false);
            } else {
              l.stop();
              return $('html, body').animate({
                scrollTop: 0
              }, 500);
            }
          },
          error: function() {
            return l.stop();
          }
        });
      } else {
        $('#flash_for_steps').removeClass('hidden');
        return $('html, body').animate({
          scrollTop: 0
        }, 500);
      }
    });
    $(document).on('click', '#phone_code_send', function() {
      var l, number;
      l = Ladda.create(document.querySelector('#phone_code_send'));
      l.start();
      number = $('#driver_verification_p_num').val();
      return $.ajax({
        url: '/verify_phone_number',
        data: {
          'country_code': '0',
          'phone_number': number
        },
        success: function(response) {
          if (response.success === true) {
            console.log('success');
            l.stop();
            $('#phone_code_send').attr('disabled', 'disabled');
            return $('#verify_phone_code').prop('disabled', false);
          } else {
            l.stop();
            return $('html, body').animate({
              scrollTop: 0
            }, 'slow');
          }
        }
      });
    });
    $(document).on('click', '#verify_email_code', function() {
      var l, pin;
      l = Ladda.create(document.querySelector('#verify_email_code'));
      l.start();
      pin = $('#driver_verification_pin_email').val();
      return $.ajax({
        url: '/driver_verifications/verify_email_pin_code',
        type: 'POST',
        data: {
          'email_pin': pin
        },
        success: function(response) {
          if (response.success === true) {
            email_verify_flag = true;
            l.stop();
            enable_continue_button(email_verify_flag, phone_verify_flag);
            $('#verify_email_code span').text('VERIFIED');
            return $('#verify_email_code').attr('disabled', 'disabled');
          } else {
            l.stop();
            return $('html, body').animate({
              scrollTop: 0
            }, 'slow');
          }
        }
      });
    });
    $(document).on('click', '#verify_phone_code', function() {
      var l, pin;
      l = Ladda.create(document.querySelector('#verify_phone_code'));
      l.start();
      pin = $('#driver_verification_pin_mobile').val();
      return $.ajax({
        url: '/driver_verifications/verify_phone_pin_code',
        type: 'POST',
        data: {
          'phone_pin': pin
        },
        success: function(response) {
          if (response.success === true) {
            phone_verify_flag = true;
            l.stop();
            enable_continue_button(email_verify_flag, phone_verify_flag);
            $('#verify_phone_code span').text('VERIFIED');
            return $('#verify_phone_code').attr('disabled', 'disabled');
          } else {
            l.stop();
            return $('html, body').animate({
              scrollTop: 0
            }, 'slow');
          }
        }
      });
    });
    $('.driver_veri_email_pin').change(function() {
      return $('#driver_verification_pin_email').val($(this).val());
    });
    return $('#verify_pin_button').click(function() {
      var email_pin_code, l, phone_pin_code, verify_email_pin_code, verify_phone_pin_code;
      email_pin_code = $('#driver_verification_pin_email').val();
      phone_pin_code = $('#driver_verification_pin_mobile').val();
      verify_phone_pin_code = false;
      verify_email_pin_code = false;
      l = Ladda.create(document.querySelector('#verify_pin_button'));
      l.start();
      $.ajax({
        url: '/driver_verifications/verify_phone_pin_code',
        type: 'POST',
        data: {
          'phone_pin': phone_pin_code
        },
        async: false,
        success: function(response) {
          if (response.success === true) {
            return verify_phone_pin_code = true;
          }
        }
      });
      $.ajax({
        url: '/driver_verifications/verify_email_pin_code',
        type: 'POST',
        data: {
          'email_pin': email_pin_code
        },
        async: false,
        success: function(response) {
          if (response.success === true) {
            return verify_email_pin_code = true;
          }
        }
      });
      if (verify_email_pin_code === true && verify_phone_pin_code === true) {
        $('#tab1').removeClass('active');
        $('#tab2').addClass('active');
        $('#tab_nav2').addClass('active');
      }
      return l.stop();
    });
  });

}).call(this);
