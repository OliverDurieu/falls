    var seq_count=1
    $(document).ready(function () {
        var sub_route_distances = new Array();
        var stop_over = new Array();
        var ride_legs_array = new Array();
        var location = new Array();
        var ride_leg_count = 1;
        var is_round = false;

        $('#weekdays input:checkbox:checked').each(function () {
            $(this).parent().addClass('active');
        });

        $(".recurring_trip_radio").click(function () {
            handle_return_weeks_with_recurring();
            if ($("#ride_is_recurring_trip_1").prop("checked") == true) {
                $("#weeks_outbound").removeClass("hidden");
            }
            else {
                $("#weeks_outbound").addClass("hidden");
            }
        });
        drawGMap();
        $('form').on('click', '.remove_location', function (event) {
          seq_count--;
            var $this = $(this);
            $this.prev('input[type=hidden]').val('1');
            var location = $this.closest('fieldset');
            var location_id = location.find('.input-id').val();
            location.remove();
            drawGMap();
            $("#ride_routing_required").val(1);
            var ride_id = $('#ride_id').val();
            if (ride_id > 0 && location_id > 0) {
                $.ajax({
                    type: 'DELETE',
                    url: '/rides/' + $("#ride_id").val() + '/locations/' + location_id,
                    dataType: 'json'
                });//end of ajax;
            }
            address_elem_id = this.parentElement.childNodes[1].id
            var index_to_remove = stop_over.indexOf('#' + address_elem_id + '-li');
            $('#' + address_elem_id + '-li').remove();

            //console.log($('.gmaps-input-address').length);
            
            getSubRouteDistance(); 
            make_legs(is_round);
            set_schedule();
            return event.preventDefault();
        });

        $('form').on('click', '.add_fields', function (event) {
            seq_count++;
            var regexp, time;
            time = new Date().getTime();
            regexp = new RegExp($(this).data('id'), 'g');
            $('.stages-list').append($(this).data('fields').replace(regexp, time));
            gmapAutocompleteInitialize();
            $("#ride_routing_required").val(1);
            return event.preventDefault();
        });

        // $('#ride_departure_date').datetimepicker({
        //     timeFormat: "hh:mm TT",
        //     controlType: 'select'
        // });

        // $('#ride_return_date').datetimepicker({
        //     timeFormat: "hh:mm TT",
        //     controlType: 'select'
        // });

        $('body').on('click', '.date-holder .date_addon', function (e) {
            if (!$('#ui-datepicker-div').is(':visible')) {
                $(this).parents('.date-holder').find('input').trigger("focus");
            }
        });
        $('#ride_is_round_trip').change(function () {
            if ($(this).is(':checked')) {
                // $('.ruturn-date-holder').removeClass("hidden");
            } else {
                $('.ruturn-date-holder').addClass("hidden");
            }
            handle_return_weeks_with_recurring()
        });//end of check all or uncheck all
        // $('#').change(function(){
            
        // });

        // $('#weekdays label').eq(n).button('toggle');
        // ======================================================================
        //  creating sub routes, their legs and their list with schedule
        
        $('#ride_source').blur(function(){
            // $('#schedule_start_location').text(this.value);
            // var partsOfStr = this.value.split(',');
            // $('#ride_leg_start').text(partsOfStr[0]);
            // if($('#ride_source').val() != ''){
            //   // check if its a returning trip
            //   // is_returning_trip($('#ride_leg_end').text(), $('#ride_leg_start').text(), 2);            
            // }
            // if(($('#ride_source').val() != '') && ($('#ride_destination').val() != ''))
            // {
            //   get_time_and_distance();
            // }
        });

        $('#ride_destination').blur(function(){
            $('#schedule_end_location').text(this.value);
            var partsOfStr = this.value.split(',');
            $('#ride_leg_end').text(partsOfStr[0]);
            if($('#ride_source').val() != ''){
              // check if its a returning trip
              // is_returning_trip(partsOfStr[0], $('#ride_leg_start').text(), 2);
            }
            if(($('#ride_source').val() != '') && ($('#ride_destination').val() != ''))
            {
              get_time_and_distance();
            }
        });
        
        //  creating sub routes, their legs and their list with schedule
        $("body").on("blur", '.sub-route-locations', function () {
            // if($.inArray(this.id + '-li', stop_over) >= 0)
            // {  
            //   console.log("this.id");
            //   console.log(this.id);
            //   var text_to_alter = $('#' + this.id + '-routeName').text();
            //   $('#' + this.id + '-routeName').text(this.value);
            // }  
            // else
            // {  
            //   // create_sub_routes_steps(this.value, this.id);
            // }  
           });
        
        
        // default sub eta div will be hidden
        $('.eta_div').each(function(){
          $(this).hide(); 
        });

        // bind click with final div edit link
        $('body').on('click', '.edit ', function (e)
        {
          console.log($(this).attr('id').split('-')[1]);
          var id = $(this).attr('id').split('-')[1]; 
          $("#eta_div"+id).toggle();
          init_time_picker();
          set_new_eta(id);
                    
        });

        // adding time picker 
        $('.time_picker').datetimepicker({
          format: 'LT'
        });

        function init_time_picker(){
            $('.time_picker').datetimepicker({
            format: 'LT'
          });
        }

        function set_new_eta(id){
          $('.time_class').each(function(){  
            $(this).on('blur', function(){
                if((this.id == "time_picker-"+id) || (this.id == "date_picker-"+id)){
                  if(($("#date_picker-"+id).val() != '') && ($("#time_picker-"+id).val() != '')){
                    $('#eta_holder'+id).text($("#time_picker-"+id).val()+" on "+ $("#date_picker-"+id).val());
                  }
                  else if(($("#date_picker-"+id).val() != '') && ($("#time_picker-"+id).val() == '')){
                    $('#eta_holder'+id).text( $("#date_picker-"+id).val());
                  }
                  else if(($("#date_picker-"+id).val() == '') && ($("#time_picker-"+id).val() != ''))
                  {
                    $('#eta_holder'+id).text($("#time_picker-"+id).val());   
                  }
                  else
                  {
                    $('#eta_holder'+id).text("N/A"); 
                  }
                }  
            });
          });
        }


        $('.trip_type').change(function(){
          //console.log('inside method');
          if($('#ride_is_round_trip_true').is(':checked'))
          {
            is_round = true;
            set_return_trip_distance();
          } 
          if($('#ride_is_round_trip_false').is(':checked'))
          {
            is_round = false;
          }  
          make_legs(is_round);
        });

        $("body").on("change", '.price_per_seat', function () {
          set_total_price();
        });

        $("body").on("change", '.num_of_seats', function () {
          set_total_seats();
        });
        // formatting date for submitting to controller
        $('body').on("blur", '.time_class',function(){
           format_date(this.id);
        });
        // set car ID
        $("#car_picker").on('change', function() {
          $("#id_car").val($(this).val());
        });

        $("#create_ride_button").click(function(){
            if($("#car_picker").hasClass( "hidden" ))
            {
              $("#car_not_added").modal('show');
              return false;
            } 
            else
            {
              return true;
            } 
        });
        //get default selected value in case value of select is not changed
        set_car_id($('#car_picker').val());
        
        //hide and show recurring div of months and days
        $('#recurring_div').hide();

        $('#ride_is_recurring_trip').click(function(){

          if(!($('#ride_is_recurring_trip').is(":checked")))
          {
            $('#recurring_div').toggle();
             // uncheck all the options if not a recurring ride
            $('.recurring_class').each(function(){
              if($(this).is(":checked"))
              {
                $(this).parent().removeClass("active");
                $(this).removeAttr('checked');
              }
            });
          }
          else
          {
            $('#recurring_div').toggle();
          }  

        });

      // hiding main eta div  
      $('#eta_div1').hide();

      // set date format of the date picker
      init_datepicker()

      // auto pricing if checbox checked
      $('#auto_pricing_checkbox').click(function(){
        if ($("#auto_pricing_checkbox").is(':checked'))
        {
          set_auto_pricing();
        }
        else
        {
          set_total_price();
        }
      });

      // getting subroute distances 
      $("body").on("blur", '.gmaps-input-address', function () {
        
        // getSubRouteDistance();
  
      });
      // regenerate legs and schedule on sub route deletion
      $('.map-form').on('click','.remove_location',function (){ 
        // console.log($('.gmaps-input-address').length);
        
        // getSubRouteDistance(); 
        // make_legs(is_round);
        // set_schedule();
      });

    }); // end of document .ready

      function isNumberKey(evt){
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 48 && charCode < 56)
            return true;
        return false;

        // var charCode = (evt.which) ? evt.which : event.keyCode
        // if (charCode > 31 && (charCode < 48 || charCode > 57))
        //     return false;
        // return true;
      }

    function init_datepicker () {
      $('.date_picker_rails').datepicker({
          format: 'dd/mm/yyyy',
          startDate: '+1d'
      });
    }

    function handle_return_weeks_with_recurring() {

        if ($("#ride_is_recurring_trip_1").is(':checked') && $('#ride_is_round_trip').is(':checked')) {
            if ($("#weeks_return").hasClass("hidden")) {
                $("#weeks_return").removeClass("hidden");
            }
        }
        else {
            if (!$("#weeks_return").hasClass("hidden")) {
                $("#weeks_return").addClass("hidden");
            }
        }
    }

  function make_legs(is_round){
    loc_arr =new Array();
    $('.gmaps-input-address').each(function(){
      if($(this).val() != '')
      {
        loc_arr.push($(this).val().split(',')[0]);
      }
      if(loc_arr.length>=2)
      {
        generate_legs(loc_arr, is_round);
      }
    });
  }

  function generate_legs(array, is_round)
  {
    if($('#ride_is_round_trip_true').is(':checked'))
    {
      is_round = true;
    }
    else
    {
      is_round = false;
    }
    $.ajax({
        type: 'POST',
        data: {locations:array, is_round: is_round},
        url: '/rides/make_legs',
        success: function(msg){
          $("#legs_list").html(msg);
          // if ($("#auto_pricing_checkbox").is(':checked'))
          // {
          //   console.log("called auto pricing");
          //   set_auto_pricing();       
          // }
          $('#auto_pricing_checkbox').attr('checked', false);
        }
    });
  }

  function set_total_price(){
    var num_regex = /^[0-9]+$/;
    var total = 0;
    var number = 0;
    $('.price_per_seat').each(function(){
      if(num_regex.test($(this).val()))
      {
        number = parseInt($(this).val());
        total = total + number;
      }  
      else
      {
        number = 0;
        total = total +number;
      }  
    });
    //console.log("cost: "+total);
    $("#ride_total_cost").val(total);
  }

  function set_total_seats()
  {
    var num_regex = /^[0-9]+$/;
    var total = 0;
    $('.num_of_seats').each(function(){
      if(num_regex.test($(this).val()))
      {
        total = total + parseInt($(this).val());
      }   
    });
    //console.log("seats: "+total);
    $("#ride_total_seats").val(total);
  }

  function format_date(id)
  {
      var date_elem = document.getElementById('date_picker-'+id.split('-')[1]);
      var time_elem = document.getElementById('time_picker-'+id.split('-')[1]);
    if((date_elem.value != null) && (time_elem.value != null) && (date_elem.value != '') && (time_elem.value != ''))
    {
      var date_time_object = date_elem.value.replace(/\//g, "-") +' '+ time_elem.value.substring(0, time_elem.value.length-2);
      if(id.split('-')[1] == "departtime")
      {
        $('#date_field_depart').val(date_time_object);
      }
      else
      {
        $('#date_field'+id.split('-')[1]).val(date_time_object);
      }
    }    
  }

  function hide_eta_divs()
  {
    $('.eta_div').each(function(){
      this.hide();
    });
  }
  function set_schedule()
  {
    
    loc_arr =new Array();
    $('.gmaps-input-address').each(function(){
      if($(this).val() != '')
      {
        loc_arr.push($(this).val().split(',')[0]);
      }
    });
    create_schedule(loc_arr);
  }

  function create_schedule(array)
  {
    $.ajax({
        type: 'POST',
        data: {locations:array},
        url: '/rides/make_schedule',
        success: function(msg){
          $("#ride_schedule").html(msg);
          // set date and time picker format of the partial view
          $('.time_picker').datetimepicker({
              format: 'LT'
          });
          init_datepicker()
          // update_destinition_step_id(array);
        }
      });
  }

  function set_auto_pricing()
  {
    for( var i=0; i< sub_route_distances.length; i++)
    {
        var distance = sub_route_distances[i];
        distance = distance.replace(/\s/g, '');
        distance = distance.replace(/,/g, "");
        var amount = parseInt(distance, 10) * 0.08;  
        //console.log("amount: "+ amount);
        $('#ride_routes_attributes_'+i+'_price').val(Math.round(amount * 100)/100);
    }
    var total = 0;
    $('.price_per_seat').each(function(){
     // console.log(total);  
      total = total + parseInt($(this).val()); 
    });
    $("#ride_total_cost").val(total);
    // set total price
   //console.log("Total : "+total);
    // set return pricing if radio button is checked
    set_return_trip_distance();
    set_total_seats();
  }

  function getSubRouteDistance(){
    var sub_route_array = new Array();
    sub_route_distances = new Array();
    sub_route_array.push($("#ride_source").val());
    $('.gmaps-input-address').each(function(){
      if ($(this).hasClass("sub-route-locations" ))
      {
        sub_route_array.push($(this).val());             
      } 
    });
    sub_route_array.push($("#ride_destination").val());
    //console.log(sub_route_array);
    if(sub_route_array.length >= 2){
      for(var i = 0; i < sub_route_array.length; i++)
      {
        var j = i+1;
        if( j<= (sub_route_array.length - 1))
        {
          var origin = sub_route_array[i];
          var destination = sub_route_array[j];
          var service = new google.maps.DistanceMatrixService();
          service.getDistanceMatrix({
            origins: [origin],
            destinations: [destination],
            travelMode: google.maps.TravelMode.DRIVING,
            avoidHighways: false,
            avoidTolls: false
          },
          subroutesdistanceCallback
          );
          }  
        }
        // get return distance in case of return route
      }
  }


function subroutesdistanceCallback(response, status) {
  if (status == google.maps.DistanceMatrixStatus.OK) {
    var origins = response.originAddresses;
    var destinations = response.destinationAddresses; 
    for (var i = 0; i < origins.length; i++) {
      var results = response.rows[i].elements;
        for (var j = 0; j < results.length; j++) {
        var element = results[j];
        console.log(results[j]);
        var distance = element.distance.text;          
        var duration = element.duration.text;
        var from = origins[i];
        var to = destinations[j];
        //console.log("SubRoute Distance: "+distance);
        sub_route_distances.push(distance);
      }
    }
  }
  //console.log(sub_route_distances);
}


  function set_return_trip_distance()
  {
    index = sub_route_distances.length + 1;
    if($('#ride_is_round_trip_true').is(':checked'))
    {
      //console.log('return trip pricing');
      distance = $('#distance_total').text().replace(/\s/g, '');
      distance = distance.replace(/,/g, "");
      var amount = parseInt(distance, 10) * 0.08;   
      $('#ride_routes_attributes_'+index+'_price').val(Math.round(amount * 100)/100);
    } 

  }

  function set_car_id(id)
  { 
   $("#id_car").val(id);
  }

  function update_destinition_step_id(array)
  {
    $('#date_field_dest').attr("id","date_picker,"+(array.length - 1))
  }

  function get_time_and_distance()
  {
    getGMapDistance();
  }
  function bind_events_with_gmaps(){
    make_legs(false);
    set_schedule();
    if($('#ride_source').val() != '' && $('#ride_destination').val() != '')
      getSubRouteDistance();
  }
 
  window.bind_events_with_gmaps = bind_events_with_gmaps
;
