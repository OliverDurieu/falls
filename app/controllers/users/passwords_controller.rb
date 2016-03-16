class Users::PasswordsController < Devise::PasswordsController
  
  def new
    super
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      # if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message(:notice, flash_message) if is_flashing_format?
        mandrill = MandrillMailer.new
        mandrill.password_changed_successfully(resource)
        sign_in(resource_name, resource)
        respond_with resource, location: after_resetting_password_path_for(resource)
        
      # else
      #   set_flash_message(:notice, :updated_not_active) if is_flashing_format?
      #   respond_with resource, location: new_session_path(resource_name)
      # end
    else
      respond_with resource
    end
  end 

end  