class PreferencesController < ApplicationController

	layout "profile", only: [:edit, :update]

	before_action :laod_preference, only: [:edit, :update]

	def update
		if @preference.update(preference_params)
			redirect_to '/profile/preferences', notice: t('.succeed')
		else
			render 'edit'
		end
	end


	private
	def laod_preference
		@preference = current_user.preference
	end

	def preference_params
		params.require(:preference).permit(:chattiness, :music, :smoking, :pets, :flag)
	end
end
