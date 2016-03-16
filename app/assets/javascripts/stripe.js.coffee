jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#payment1').submit ->
      $('input[type=submit]').attr('disabled', true)
      l = Ladda.create(document.querySelector('#submit_pay_online'))
      l.start()
      subscription.processCard()
      false

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#month_and_date').val().split("-")[0];
      expYear: $('#month_and_date').val().split("-")[1];
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    l = Ladda.create(document.querySelector('#submit_pay_online'))
    if status == 200
      $('#stripe_card_token').val(response.id)
      $('#pay-online').modal 'hide'
      str = $('#card_number').val()
      res = str.substr(12)
      $('#card_last_four_number').text res
      qty = $('#quantity').val()
      $('#quantity2').val(qty)
      l = Ladda.create(document.querySelector('#submit_pay_online'))
      l.stop()
      $('#pay-online2').modal 'show'
      # $('#payment1')[0].submit()
    else
      l.stop()
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)

$(document).ready ->
  $('#datepicker').datepicker
    format: 'mm-yyyy'
    viewMode: 'months'
    minViewMode: 'months'
    startDate: '+0y'
  $('#cancel_button').click ->
    $('#pay-online').modal 'hide'
    return
  $('#cancel_button2').click ->
    $('#pay-online2').modal 'hide'
    return  
  return  


$('#pay_button2').click ->
  l = Ladda.create(document.querySelector('#pay_button2'))
  l.start()
  setTimeout (->
    m=$('#payment1').serialize()
    $.ajax
      url: '/transections/payment'
      dataType: 'json'
      async: false
      data: $('#payment1').serialize()
      success: (response) ->
        if response.success == true
          l.stop()
          $('#pay-online2').modal 'hide'
          $('#booking_code_p').text response.booking_token
          $('#price_paid_p').text '$' + response.paid_amount + ' Paid' 
          $('#seats_available_h').text response.seats_availabe
          if response.seats_availabe == 0
             $('#book_seat_button').html 'All Seats Booked'
             $('#book_seat_button').attr 'disabled', 'disabled'
          $('#payment1')[0].reset()
          $('#booking_model').modal 'show'
        else
          l.stop()
          $('#pay-online2').modal 'hide'
          $('#flash_for_booking #flash_success').html response.reason
          $('#flash_for_booking').removeClass 'hidden'
          $('html, body').animate { scrollTop: 0 }, 500      
        return  
    return
    ), 2000
  return  

$('#message_sent').submit (event) ->
  l = Ladda.create(document.querySelector('#send_message_button'))
  l.start()
  return