module DriverVerificationsHelper

  def verification_final_step(step)
    if step == true
      return "active"
    end  
  end  

  def final_verification_tab(step)
    if step == true
      return "active"
    else 
      return ""  
    end  
  end  

  def non_final_verification_tab(step)
    if step == false
      return "active"
    else 
      return ""  
    end  
  end 

end
