module ProfileHelper
  def avatar_url(user)
    if user.profile.is_picture?
      user.profile.picture
    elsif user.profile.photo.present?
      user.profile.photo
    else
      "/assets/user/icon-man-144.png"
    end
  end

end
