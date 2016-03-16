module RidesHelper

  def route_from_to(source, destination)
    return "#{source.partition(',').first} -  #{destination.partition(',').first}"
  end  

  def show_car_picker user

    if user.cars.present?
      return ""
    else
      return "hidden"
    end    
    
  end

  def arrival_time(date)
    if date.present? 
      return date.strftime("%I:%M%p %m/%d/%Y")      
    else
      return "N/A"
    end
  end

  def ride_short_name(location)
    return location.partition(',').first
  end  

	def date_in_today_format(date)
		if date
			if (Time.now).to_date == date.to_date
				return "Today - #{date.strftime('%H:%M')}"
			elsif (Time.now + 1.day).to_date == date.to_date
				return "Tomorrow - #{date.strftime('%H:%M')}"
			elsif (Time.now - 1.day).to_date == date.to_date
				return "Yesterday - #{date.strftime('%H:%M')}"
			else
				return date.strftime("%A %e %B %Y - %H:%M")
			end
		end
	end

	def calculate_price(trip,ride_id,src,dest)

		trip.each do |t|
			if t.ride_id == ride_id

				if dest == "" || dest == nil
					dest = t.locations.last
				end
				if src == "" || src == nil
					src = t.locations.first
				end

			 	if t.locations.index(src) > t.locations.index(dest)
			 		$i = t.locations.index(dest)
					$num = t.locations.index(src)
					@tprice = 0
					while $i < $num  do
   						@tprice+=t.price[$i]
   						$i +=1
					end
			 		t.trip_price = @tprice
			 	elsif t.locations.index(src) < t.locations.index(dest)
			 		$i = t.locations.index(src)
					$num = t.locations.index(dest)
					@tprice = 0
					while $i < $num  do
   						@tprice+=t.price[$i]
   						$i +=1
					end
			 		t.trip_price = @tprice
			 	end
			 end
		end
			return @tprice.to_i
	end

  def sort_btn_active(param_val, its_val1, its_val2=nil)
    param_val == its_val1 || param_val == its_val2 ? "active" : ""
  end

  def driverrating(user)
  	@driver = Rating.where(user_id: user.id, :user_type => "driver")

  	@d5 = @driver.where(user_id: user.id,:star => "5").count
    @d4 = @driver.where(user_id: user.id,:star => "4").count
    @d2 = @driver.where(user_id: user.id,:star => "2").count
    @d3 = @driver.where(user_id: user.id,:star => "3").count
    @d1 = @driver.where(user_id: user.id,:star => "1").count

    if(@driver.count >0)
    	@rating = ((@d5*5)+ (@d4*4)+ (@d3*3)+ (@d2*2)+ (@d1))/@driver.count
    	return @rating
    end
    return 0

  end

  def lastfive(user)
  	@ratings = user.ratings.limit(5).order("id desc").all
  	return @ratings
  end

  def route_state_abbrv route
    croute = route
    croute = croute.gsub('Australian Capital Territory','ACT')
    croute = croute.gsub('New South Wales','NSW')
    croute = croute.gsub('Victoria','Vic')
    croute = croute.gsub('Queensland','Qld')
    croute = croute.gsub('South Australia','SA')
    croute = croute.gsub('Western Australia','WA')
    croute = croute.gsub('Tasmania','Tas')
    croute = croute.gsub('Northern Territory','NT')
    croute = croute.gsub('Australian Antarctic Territory','AAT')
    croute = croute.gsub(', Australia','')
    puts croute
    croute
  end

  def show_if_paid booking

    if booking.transfer_request.present? && booking.transfer_request.transfer_transaction.present?
      return ''
    else
      return 'hidden'
    end  

  end
  
  def hide_if_paid  booking

    if booking.transfer_request.present? && booking.transfer_request.transfer_transaction.present?
      return 'hidden'
    else
      return ''
    end  

  end

  def get_car_models 
    # prepopulate the menu with the car models corresponding to the first car maker
    car_models_array = CarMaker.all.order('id asc').first.car_models
    return car_models_array
  end  
    
end