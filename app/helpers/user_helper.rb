module UserHelper

	def phone_countries_options(countries, selected_country)
		countries.each do |country|
			content_tag "option", country.name, value: country.id, data: { code: country.country_code, format: country.country_format }
		end.join("\n")
	end

  def show_message_link user
    unless user == current_user
      return ""
    else  
      return "hidden"  
    end
  end

  def show_if_current_user user
    if user == current_user
      return ""
    else
      return "hidden"
    end    
  end

end

