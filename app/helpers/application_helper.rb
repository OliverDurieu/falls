module ApplicationHelper

	def get_car_maker(car)
    return car.car_maker.name
  end

  def get_car_model(car)
    return car.car_model.name
  end  

  def match_name(page_url,page_name)
		if page_url == page_name
			return "active"
		end	
	end

  	def match_name2(page_url,page_name)
		if page_url == page_name
			return "active"
		else
			return "hidden"
		end	
	end

  	def email_and_phone_verified?
		if current_user.email_verified == true && current_user.phone_number.verified_no == true
			return ""
		else
			return "disabled"
		end	
	end	




	def assign_hidden
		if current_user.present?
			return "hidden-xs"
		end	
	end
	
	def unread_message_count
    current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? AND messages.message_type = ?", GlobalConstants::MessageThreads::STATUS[:active], true, GlobalConstants::Messages::TYPE[:received]).count rescue ""
	end 

	def unread_message_threads
    if current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? ", GlobalConstants::MessageThreads::STATUS[:active], true).size > 0
    	message_threads = current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? ", GlobalConstants::MessageThreads::STATUS[:active], true).last(5)		
  		if message_threads.size < 5
  			message_threads = message_threads + current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? ", GlobalConstants::MessageThreads::STATUS[:active], false).last(5 - message_threads.size)
  		end	
  	else
  		message_threads = current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? ", GlobalConstants::MessageThreads::STATUS[:active], false).last(5)
  	end
  	return message_threads	
	end

	def display_base_errors resource
		return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
		messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
		html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
		HTML
		html.html_safe
	end

	def set_date_style(date)
		date.present? ? date.strftime("%a %d %b %Y - %I:%M %p") : ""
		# Thursday 12 June - 03:00
	end

	def set_full_month_date_time_style(date)
		date.present? ? date.strftime("%A %d %B %Y - %I:%M %p") : ""
		# Thursday 12 June - 03:00
	end

	def link_to_add_fields(name, f, association, css_class= "")
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder, parent_obj: f.object, current_model: association.to_s)
		end
		link_to(name, '#', class: "add_fields #{css_class}", data: { id: id, fields: fields.gsub("\n", "") })
	end


  def hide_if_verified user
    if user.verified_credentials
      return 'hidden'
    end  
  end  

  def show_if_verified user
    if user.verified_credentials
      return ''
    else
      return 'hidden'
    end    
  end
  
end
