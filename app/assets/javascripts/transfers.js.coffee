# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.booking_get_payment_form').on 'ajax:before', ->
    l = Ladda.create(document.querySelector('#' + $(this).find('.ladda-button').attr('id')))
    l.start()
    return true
