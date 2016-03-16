(function() {
  var subscription;

  jQuery(function() {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return subscription.setupForm();
  });

  subscription = {
    setupForm: function() {
      return $('#payment1').submit(function() {
        var l;
        $('input[type=submit]').attr('disabled', true);
        l = Ladda.create(document.querySelector('#submit_pay_online'));
        l.start();
        subscription.processCard();
        return false;
      });
    },
    processCard: function() {
      var card;
      card = {
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        expMonth: $('#month_and_date').val().split("-")[0],
        expYear: $('#month_and_date').val().split("-")[1]
      };
      return Stripe.createToken(card, subscription.handleStripeResponse);
    },
    handleStripeResponse: function(status, response) {
      var l, qty, res, str;
      l = Ladda.create(document.querySelector('#submit_pay_online'));
      if (status === 200) {
        $('#stripe_card_token').val(response.id);
        $('#pay-online').modal('hide');
        str = $('#card_number').val();
        res = str.substr(12);
        $('#card_last_four_number').text(res);
        qty = $('#quantity').val();
        $('#quantity2').val(qty);
        l = Ladda.create(document.querySelector('#submit_pay_online'));
        l.stop();
        return $('#pay-online2').modal('show');
      } else {
        l.stop();
        $('#stripe_error').text(response.error.message);
        return $('input[type=submit]').attr('disabled', false);
      }
    }
  };

  $(document).ready(function() {
    $('#datepicker').datepicker({
      format: 'mm-yyyy',
      viewMode: 'months',
      minViewMode: 'months',
      startDate: '+0y'
    });
    $('#cancel_button').click(function() {
      $('#pay-online').modal('hide');
    });
    $('#cancel_button2').click(function() {
      $('#pay-online2').modal('hide');
    });
  });

  $('#pay_button2').click(function() {
    var l;
    l = Ladda.create(document.querySelector('#pay_button2'));
    l.start();
    setTimeout((function() {
      var m;
      m = $('#payment1').serialize();
      $.ajax({
        url: '/transections/payment',
        dataType: 'json',
        async: false,
        data: $('#payment1').serialize(),
        success: function(response) {
          if (response.success === true) {
            l.stop();
            $('#pay-online2').modal('hide');
            $('#booking_code_p').text(response.booking_token);
            $('#price_paid_p').text('$' + response.paid_amount + ' Paid');
            $('#seats_available_h').text(response.seats_availabe);
            if (response.seats_availabe === 0) {
              $('#book_seat_button').html('All Seats Booked');
              $('#book_seat_button').attr('disabled', 'disabled');
            }
            $('#payment1')[0].reset();
            $('#booking_model').modal('show');
          } else {
            l.stop();
            $('#pay-online2').modal('hide');
            $('#flash_for_booking #flash_success').html(response.reason);
            $('#flash_for_booking').removeClass('hidden');
            $('html, body').animate({
              scrollTop: 0
            }, 500);
          }
        }
      });
    }), 2000);
  });

  $('#message_sent').submit(function(event) {
    var l;
    l = Ladda.create(document.querySelector('#send_message_button'));
    l.start();
  });

}).call(this);
