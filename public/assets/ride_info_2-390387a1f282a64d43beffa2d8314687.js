(function() {
  $(document).ready(function() {
    var slider;
    slider = new Slider('#ex2', {});
    return $('#ex2').on('slideStop', function() {
      var from_price, price_range, to_price;
      price_range = $(this).val();
      from_price = parseInt(price_range.split(',')[0]);
      to_price = parseInt(price_range.split(',')[1]);
      return $('.cost_per_seat').each(function() {
        var price;
        price = $(this).text();
        if (parseFloat(price) >= from_price && parseFloat(price) <= to_price) {
          if ($(this).closest('.passenger-block').hasClass('hidden')) {
            return $(this).closest('.passenger-block').removeClass('hidden');
          }
        } else {
          return $(this).closest('.passenger-block').addClass('hidden');
        }
      });
    });
  });

}).call(this);
