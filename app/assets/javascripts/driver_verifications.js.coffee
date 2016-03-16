readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('#image_upload_preview').attr 'src', e.target.result
      return

    reader.readAsDataURL input.files[0]
  return

readURLCar = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('#car_image_upload_preview').attr 'src', e.target.result
      return

    reader.readAsDataURL input.files[0]
  return  

$(document).ready ->
  $('#inputFile').change ->
    readURL this
    return
  $('#inputFilecar').change ->
    readURLCar this
    return  
  return


$(document).ready ->
  email_verify_flag = false
  phone_verify_flag = false

  enable_continue_button = (email_flag, phone_flag) ->
    if email_flag == true and phone_flag == true
      $('#verify_pin_button').prop 'disabled', false
    return

  $.ajax
    url: '/driver_verifications/check_email_verified'
    type: 'GET'
    dataType: 'json'
    async: false
    success: (response) ->
      if response.success == true
        email_verify_flag = true
      

  $.ajax
    url: '/driver_verifications/check_phone_verified'
    type: 'GET'
    dataType: 'json'
    async: false
    success: (response) ->
      if response.success == true
        phone_verify_flag = true

  enable_continue_button email_verify_flag, phone_verify_flag

  $('#tab1_button').on 'click', ->
    $('#start_tab').removeClass 'active'
    $('#tab1').addClass 'active'

  $('#email_code_send').click ->
    mail = document.getElementById('driver_verification_email').value
    pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    if pattern.test(mail)
      $('#driver_verification_update_email').val mail
      l = Ladda.create(document.querySelector('#email_code_send'))
      l.start()
      $.ajax
        type: 'GET'
        data: email: mail
        url: '/driver_verifications/email_token_generator'
        success: (data) ->
          if data.success == true
            l.stop()
            $('#email_code_send').attr 'disabled', 'disabled'
            $('#verify_email_code').prop 'disabled', false
          else
            l.stop()
            $('html, body').animate { scrollTop: 0 }, 500
        error: ->
          l.stop()
    else
      $('#flash_for_steps').removeClass 'hidden'
      $('html, body').animate { scrollTop: 0 }, 500
          
  $(document).on 'click', '#phone_code_send', ->
    l = Ladda.create(document.querySelector('#phone_code_send'))
    l.start()
    number = $('#driver_verification_p_num').val()
    $.ajax
      url: '/verify_phone_number'
      data:
        'country_code': '0'
        'phone_number': number
      success: (response) ->
        if response.success == true
          console.log 'success'
          l.stop()
          $('#phone_code_send').attr 'disabled', 'disabled'
          $('#verify_phone_code').prop 'disabled', false
        else
          l.stop()
          $('html, body').animate { scrollTop: 0 }, 'slow'
        
    
  $(document).on 'click', '#verify_email_code', ->
    l = Ladda.create(document.querySelector('#verify_email_code'))
    l.start()
    pin = $('#driver_verification_pin_email').val()
    $.ajax
      url: '/driver_verifications/verify_email_pin_code'
      type: 'POST'
      data: 'email_pin': pin
      success: (response) ->
        if response.success == true
          email_verify_flag = true
          l.stop()
          enable_continue_button email_verify_flag, phone_verify_flag
          $('#verify_email_code span').text 'VERIFIED'
          $('#verify_email_code').attr 'disabled', 'disabled'
        else
          l.stop()
          $('html, body').animate { scrollTop: 0 }, 'slow'
        
    
  $(document).on 'click', '#verify_phone_code', ->
    l = Ladda.create(document.querySelector('#verify_phone_code'))
    l.start()
    pin = $('#driver_verification_pin_mobile').val()
    $.ajax
      url: '/driver_verifications/verify_phone_pin_code'
      type: 'POST'
      data: 'phone_pin': pin
      success: (response) ->
        if response.success == true
          phone_verify_flag = true
          l.stop()
          enable_continue_button email_verify_flag, phone_verify_flag
          $('#verify_phone_code span').text 'VERIFIED'
          $('#verify_phone_code').attr 'disabled', 'disabled'
        else
          l.stop()
          $('html, body').animate { scrollTop: 0 }, 'slow'
        
  $('.driver_veri_email_pin').change ->
    $('#driver_verification_pin_email').val $(this).val()

  $('#verify_pin_button').click ->
    email_pin_code = $('#driver_verification_pin_email').val()
    phone_pin_code = $('#driver_verification_pin_mobile').val()
    verify_phone_pin_code = false
    verify_email_pin_code = false 
    
    l = Ladda.create(document.querySelector('#verify_pin_button'))
    l.start()

    $.ajax
      url: '/driver_verifications/verify_phone_pin_code'
      type: 'POST'
      data: 'phone_pin': phone_pin_code
      async: false
      success: (response) ->
        if response.success == true
          verify_phone_pin_code = true

    $.ajax
      url: '/driver_verifications/verify_email_pin_code'
      type: 'POST'
      data: 'email_pin': email_pin_code
      async: false
      success: (response) ->
        if response.success == true
          verify_email_pin_code = true

    if verify_email_pin_code == true && verify_phone_pin_code == true
      $('#tab1').removeClass 'active'
      $('#tab2').addClass 'active'
      $('#tab_nav2').addClass 'active'
    l.stop()
  