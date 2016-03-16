class UnsubscribesController < ApplicationController

	layout "profile", only: [:account, :delete_account]

	def account
		@unsubscribe = Unsubscribe.new
	end

	def delete_account
		begin
			@unsubscribe = current_user.build_unsubscribe(unsubscribe_params)
			if @unsubscribe.save
				# UserMailer.delete_account(@unsubscribe.unsubscribe_reason.name, @unsubscribe.comment, current_user).deliver
				mandrill_mailer = MandrillMailer.new
				mandrill_mailer.delete_account(@unsubscribe.unsubscribe_reason.name, @unsubscribe.comment, current_user)
				# destroy current users message threads before destroying their instance
				# message_thread = MessageThread.where("user_id = ?  OR communicator_id = ?", current_user.id, current_user.id)
				# message_thread.destroy_all 
				current_user.destroy
				return redirect_to root_path, notice: t('.success')
			else
				return render 'account'
			end
		rescue Exception => e
			puts "=== Delete Account ==="
			puts e
			flash[:danger] = t('.failed')
			return redirect_to account_unsubscribes_path
		end
	end

	private
	def unsubscribe_params
		params.require(:unsubscribe).permit(:unsubscribe_reason_id, :comment, :recommend)
	end

end
