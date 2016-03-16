module DashboardHelper

  def email_verfied
    if current_user.email_verified == true
      return 'Verified'
    else
      return 'Not Verified'
    end  
  end

  def phone_number_verfied
    if current_user.phone_number.verified_no == true
      return 'Verified'
    else
      return 'Not Verified'
    end  
  end  

  def fb_friends
    if current_user.fb_connect?
      return "#{current_user.get_fb_friends_count} friend(s)"
    else
      return 'Not Connected To Facebook'
    end  
  end 

end
