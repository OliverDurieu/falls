$(document).ready ->
  slider = new Slider('#ex2', {})
  $('#ex2').on 'slideStop', ->
    price_range = $(this).val()
    from_price = parseInt(price_range.split(',')[0])
    to_price = parseInt(price_range.split(',')[1])
    $('.cost_per_seat').each ->
      price = $(this).text()
      if parseFloat(price) >= from_price and parseFloat(price) <= to_price
        if $(this).closest('.passenger-block').hasClass('hidden')
          $(this).closest('.passenger-block').removeClass 'hidden'
      else
        $(this).closest('.passenger-block').addClass 'hidden'