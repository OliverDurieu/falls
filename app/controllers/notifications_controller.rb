class NotificationsController < ApplicationController

	layout "profile", only: [:index, :update_user_notifications]

	def update_user_notifications
		if current_user.update(user_notifications_params)
			redirect_to '/profile/notifications', notice: t('.succeed')
		else
			render 'index', notice: t('.failed')
		end
	end

	def update_fackbook_notifications
		if current_user.update(user_notifications_params)
			redirect_to '/profile/social_sharing', notice: t('.succeed')
		else
			render 'users#social_sharing', notice: t('.failed')
		end
	end

	def booking_notifications
		@booking_n = current_user.booking_notifications
		current_user.booking_notifications.where(:seen => 0 ).update_all(:seen => 1)
	end

	private
	def user_notifications_params
		params.require(:user).permit(:enable_notifications_validation, notifications_attributes: [:id, :status])
	end
end
