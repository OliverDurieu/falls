 class EmailAlertsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
		# require 'mandrill'
	before_action :authenticate_user!, only: [:create]
	before_action :set_header
	def index
		if current_user.email_alerts.present?
			@alerts = current_user.email_alerts
		else
			flash[:notice] = "No email alerts for "+ current_user.first_name
		end
	end

	def new
		if current_user.present?
			@email_alert = current_user.email_alerts.build
		else
			@email_alert = EmailAlert.new
		end	
		@rides = Ride.where("rides.departure_date > '#{Time.now}'").order(:departure_date)
	end

	def create		
		respond_to do |format|
			@emailalert = current_user.email_alerts.build(email_alert_params)
			if @emailalert.save
				format.js   { }
				# render 'create'
			end
		end
	end

	def update_travel_date
		alert = EmailAlert.find(params[:id])
		alert.travel_date = params[:date]
		alert.save!
		t = DateTime.parse(params[:date])
		render text: t.strftime("%A %d %B")
	end

	def destroy
		alert = EmailAlert.delete(params[:id])
		render "index"
	end

	def email_cron
		alerts = EmailAlert.where(flag: 0)
		rides = Ride.all
		alerts.each do |alert|
			t = alert.travel_date
			alert_date = t.strftime("%Y-%m-%d");
			rides.each do |ride|
				f = ride.departure_date
				ride_date = f.strftime("%Y-%m-%d");
				if alert_date == ride_date && alert.source == ride.source_location.get_route_name && alert.destination == ride.destination_location.get_route_name
					user = User.find(alert.user_id)
					begin
						UserMailer.email_alerts(user, ride).deliver
						alert.flag = 1
						alert.save!
						# redirect_to root_path, notice: t('.succeed')
					rescue Exception => e
						flash[:danger] = e
						return render text: "Exception"
						# redirect_to root_path
					end
				end
			end
		end
		return render text: "Success"
	end

	def email_alert_params
		params.require(:email_alert).permit(:travel_date,:user_id, :destination, :source, :email)
	end
	
end
