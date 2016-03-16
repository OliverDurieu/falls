# Rides
class RidesC

  module CalculationMethods
    extend ActiveSupport::Concern

    def range_rides
      @trip = []
      if params[:range]
        if params[:ride_source].present? && params[:ride_destination].present?
          @rides_id = Location.near(params[:ride_source], (50 * Geocoder::Calculations::KM_IN_MI)).map(&:ride_id)
          # return render json: @rides_id
          @trip = Ride.where("rides.id IN (?) AND rides.user_id IS NOT NULL AND rides.departure_date > ? AND rides.full_completed > ?", @rides_id.uniq,Time.now, 0).order(params[:order_by])
          @tripa = populate_trips (@trip)
          # return render json: @tripa
          sql = "Select t.ride_id, t.route_id , t.price, t.source_id, t.destination_id, rides.is_round_trip, rides.user_id From (Select  locations.ride_id,locations.address, routes.id as route_id , routes.price, routes.source_id, routes.destination_id From locations, routes, rides where locations.ride_id = rides.id AND rides.user_id IS NOT NULL AND rides.full_completed > 0 AND locations.ride_id = routes.ride_id) as t , locations , routes, rides Where t.ride_id = locations.ride_id AND t.ride_id = routes.ride_id AND t.ride_id = rides.id Group by t.route_id , t.ride_id,t.price, t.source_id, t.destination_id, rides.is_round_trip, rides.user_id"
            # @result = ActiveRecord::Base.connection.execute(sql)
            # trip_all = populate_trips (@result)

            connection = ActiveRecord::Base.connection
            query_result = connection.execute(sql)
            connection.close
            trip_all = populate_trips query_result

            counter = 0
            @trip = []
            trip_all.each do |trip_a|
              @rides_id.uniq.each do |ride_id|
                if trip_a.ride_id.to_i == ride_id && trip_a.locations[0] == params[:ride_source]
                  @trip << trip_a
                  puts @trip.inspect
                  counter = counter + 1
                end
              end
              # return render json: @trip
            end
        end
      end
      if @trip.present?
        @trip.each do |t|
          rride = Ride.find(t.ride_id)
          if t.dir == "st"
            t.date = rride.departure_date
          else
            t.date = rride.return_date
          end
        end
        @source  = params[:ride_source]
        render "rides_info"
      else
        redirect_to URI.encode(new_email_alert_path+'?from='+params[:ride_source]+'&to='+params[:ride_destination])
      end
    end

    def set_trip
      connection = ActiveRecord::Base.connection
      begin
        if params[:ride_source].present? && params[:ride_destination].present?
          source = params[:ride_source].split(/,/)[0]
          destination = params[:ride_destination].split(/,/)[0]

          sql = "Select t.ride_id, t.route_id , t.price, t.source_id, t.destination_id, rides.is_round_trip, "\
                "rides.user_id From (Select  locations.ride_id,locations.address, routes.id as route_id , routes.price, "\
                "routes.source_id, routes.destination_id From locations, routes, rides "\
                "where locations.address LIKE '#{source}%' AND "\
                "locations.ride_id = rides.id AND rides.user_id IS NOT NULL AND rides.full_completed > 0 AND "\
                "locations.ride_id = routes.ride_id) as t , locations , routes, rides Where t.ride_id = locations.ride_id AND "\
                "t.ride_id = routes.ride_id AND locations.address LIKE '#{destination}%' AND "\
                "t.ride_id = rides.id AND rides.departure_date >= '#{Time.now}' Group by t.route_id , t.ride_id,t.price, t.source_id, "\
                "t.destination_id, rides.is_round_trip, rides.user_id"
          
          
          query_result = connection.execute(sql)
          @trip = populate_trips query_result

          # @trip.each do |t|
          #   if t.locations.index(params[:ride_source]) > t.locations.index(params[:ride_destination]) && t.is_round.blank?
          #     @trip.delete(t)
          #   end
          #   if t.locations.index(params[:ride_source]) > t.locations.index(params[:ride_destination]) && t.is_round.present?
          #     t.trip_price = calculate_price(t, params[:ride_destination], params[:ride_source])
          #     t.src = params[:ride_source]
          #     t.dest = params[:ride_destination]
          #     t.dir = "rev"
          #   else
          #     t.trip_price = calculate_price(t, params[:ride_source], params[:ride_destination])
          #     t.src = params[:ride_source]
          #     t.dest = params[:ride_destination]
          #   end
          # end
        elsif params[:ride_source].present?
          source = params[:ride_source].split(/,/)[0]
          sql = "Select locations.ride_id,routes.id, routes.price, routes.source_id, routes.destination_id, rides.is_round_trip, "\
                "rides.user_id From locations, routes, rides where locations.address LIKE '#{source}%'  "\
                "AND rides.user_id IS NOT NULL AND rides.full_completed > 0 AND locations.ride_id = routes.ride_id AND "\
                "rides.id = locations.ride_id AND rides.departure_date >= '#{Time.now}' Group by routes.id, locations.ride_id, rides.is_round_trip, "\
                "rides.user_id"

          query_result = connection.execute(sql)
          @trip = populate_trips query_result
          # @extras = []

          # @trip.each do |t|
          #   if params[:ride_source] != t.locations.last && params[:ride_source] != t.locations.first && t.is_round.present?
          #     # puts t.locations.first
          #     # t.rid
          #     t.trip_price = calculate_price(t, params[:ride_source], t.locations.last)
          #     t.src = params[:ride_source]
          #     t.dest = t.locations.last
          #     t.dir = "st"
          #     @temp = t.dup
          #     @temp.dir = "rev"
          #     @rride = Ride.find(t.ride_id)
          #     @temp.src = params[:ride_source]
          #     @temp.dest = t.locations.first
          #     @temp.trip_price = calculate_price(t, params[:ride_source], t.locations.first)
          #     @extras<<@temp
          #   elsif params[:ride_source] != t.locations.last && t.is_round.blank?
          #     t.src = params[:ride_source]
          #     t.dest = t.locations.last
          #     t.trip_price = calculate_price(t, params[:ride_source], t.locations.last)
          #     @rride = Ride.find(t.ride_id)
          #     t.date = @rride.departure_date
          #   elsif params[:ride_source] == t.locations.last && t.is_round.blank?
          #     @trip.delete(t)
          #     @rride = Ride.find(t.ride_id)
          #     t.date = @rride.departure_date
          #   elsif params[:ride_source] == t.locations.last && t.is_round.present?
          #     t.src = params[:ride_source]
          #     t.dest = t.locations.first
          #     t.trip_price = calculate_price(t, t.locations.first, params[:ride_source])
          #     @rride = Ride.find(t.ride_id)
          #     t.date = @rride.departure_date
          #   elsif params[:ride_source] == t.locations.first && t.is_round.blank?
          #     @rride = Ride.find(t.ride_id)
          #     t.date = @rride.departure_date
          #     @trip.delete(t)
          #   else
          #     t.src = params[:ride_source]
          #     t.dest = t.locations.last
          #     t.trip_price = calculate_price(t, params[:ride_source], t.locations.last)
          #     @rride = Ride.find(t.ride_id)
          #     t.date = @rride.departure_date
          #   end
          # end
          # @trip.concat(@extras)
        else
          destination = params[:ride_destination].split(/,/)[0]
          sql = "Select locations.ride_id,routes.id, routes.price, routes.source_id, routes.destination_id, rides.is_round_trip, "\
                 "rides.user_id From locations, routes, rides where locations.address LIKE '#{destination}%' "\
                 "AND rides.user_id IS NOT NULL AND rides.full_completed > 0 AND locations.ride_id = routes.ride_id AND rides.id = locations.ride_id "\
                 "AND rides.departure_date >= '#{Time.now}' Group by routes.id, locations.ride_id, rides.is_round_trip, rides.user_id"
          query_result = connection.execute(sql)
          @trip = populate_trips query_result
          #   @extras = []

          #   @trip.each do |t|
          #     if params[:ride_destination] != t.locations.last && params[:ride_destination] != t.locations.first && t.is_round.present?
          #       t.trip_price = calculate_price(t, params[:ride_destination], t.locations.last)
          #       t.dest = params[:ride_destination]
          #       t.src = t.locations.last
          #       @temp = t.dup
          #       @temp.dir = "rev"
          #       @temp.trip_price = calculate_price(t, t.locations.first, params[:ride_destination])
          #       @temp.dest = params[:ride_destination]
          #       @temp.src = t.locations.first
          #       @temp.is_round = "f"
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #       @temp.date = @rride.return_date
          #       @extras<<@temp
          #     elsif params[:ride_destination] != t.locations.last && params[:ride_destination] != t.locations.first && t.is_round.blank?
          #       t.trip_price = calculate_price(t, t.locations.first, params[:ride_destination])
          #       t.dest = params[:ride_destination]
          #       t.src = t.locations.first
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #     elsif params[:ride_destination] == t.locations.first && t.is_round.present?
          #       t.trip_price = calculate_price(t, t.locations.last, params[:ride_destination])
          #       t.dest = params[:ride_destination]
          #       t.src = t.locations.last
          #       t.dir = "rev"
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #     elsif params[:ride_destination] == t.locations.last
          #       t.trip_price = calculate_price(t, t.locations.first, params[:ride_destination])
          #       t.dest = params[:ride_destination]
          #       t.src = t.locations.first
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #     elsif params[:ride_destination] == t.locations.first && t.is_round.blank?
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #       @trip.delete(t)
          #     else
          #       t.trip_price = calculate_price(t, t.locations.first, params[:ride_destination])
          #       t.dest = params[:ride_destination]
          #       t.src = t.locations.first
          #       @rride = Ride.find(t.ride_id)
          #       t.date = @rride.departure_date
          #     end
          #   end
          # @trip.concat(@extras)
        end
      ensure
        connection.close
      end
    end

    def populate_trips (result)
      @trip_ids = Array.new
      result.each_with_index do |r, index|
        @trip_ids[index] = r['ride_id'] rescue r[0]
      end
      @trip_ids = @trip_ids.uniq

      @trip = []

      @src = Array.new
      @dest = Array.new
      @price = Array.new
      @location = Array.new
      @isround
      @iterator = 0
      @eiterator = 0

      @trip_ids.each do |id|
        result.each do |r|
          result_ride_id = r['ride_id'] rescue r[0]
          result_price = r['price'].to_i rescue r[2].to_i
          result_source_id = r['source_id'].to_i rescue r[3].to_i
          result_destination_id = r['destination_id'].to_i rescue r[4].to_i
          result_is_round_trip = r['is_round_trip'] rescue r[5]
          @user_id = r['user_id'] rescue r[6]
          if (id == result_ride_id)
            @src[@iterator] = result_source_id
            @price[@iterator]= result_price
            @dest[@iterator] = result_destination_id
            @isround = result_is_round_trip
            @iterator += 1
          end
        end
        @src.concat(@dest)
        @src = @src.uniq
        @location = Location.where(id: @src).map(&:address)
        @temp = Trip.new
        @temp.ride_id = id
        @temp.locations = @location
        @temp.price = @price
        @temp.is_round = @isround
        @temp.dir = "st"
        @temp.user_id = @user_id
        @trip[@eiterator] = @temp
        @src = Array.new
        @dest = Array.new
        @price = Array.new
        @location = Array.new
        @iterator = 0
        @eiterator += 1
      end
      # puts @trip.inspect
      return @trip
    end

    def calculate_price(trip, src, dest)
      t = trip.dup
      if t.locations.index(src) > t.locations.index(dest)
        $i = t.locations.index(dest)
        $num = t.locations.index(src)
        @tprice = 0
        while $i < $num do
          @tprice+=t.price[$i]
          $i +=1
        end
        t.trip_price = @tprice
      elsif t.locations.index(src) < t.locations.index(dest)
        $i = t.locations.index(src)
        $num = t.locations.index(dest)
        @tprice = 0
        while $i < $num do
          @tprice+=t.price[$i]
          $i +=1
        end
        t.trip_price = @tprice
      end
      return @tprice
    end

    
  end
end
