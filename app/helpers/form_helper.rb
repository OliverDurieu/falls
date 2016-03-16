module FormHelper
	def setup_user(user)
		user.profile ||= Profile.new
		user
	end

	def handle_error_text(object, attribute)
		content_tag(:div, "#{object.errors[attribute].first}", class: "field-error") if object.errors[attribute].present?
	end

	def handle_nest_error_text(object, attribute, nest_model)
		content_tag(:div, next_error_attr(object, nest_model, attribute).first, class: "field-error") if next_error_attr(object, nest_model, attribute).present?
	end

	def next_error_attr(object, nest_model, attribute)
		object.errors["#{nest_model}.#{attribute}"]
	end

	def rario_status(obj_val, radio_val)
		if obj_val == nil && radio_val == false
			true
		else
			obj_val == radio_val
		end
	end

	def options_for_birth_year_select(selected=nil)
		this_year = Date.today.year
		initial_year = this_year-100
		last_year = this_year-18
		selected_val = selected || last_year
		options_for_select (initial_year..last_year).to_a.reverse, selected_val
	end
end