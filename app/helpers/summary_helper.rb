module SummaryHelper
	def calculate_rank(iuser)
		@rank
		@per = 0
		@user = iuser


		@time_diff = (Time.now.year * 12 + Time.now.month) - (@user.created_at.year * 12 + @user.created_at.month)

		if @user.profile.mini_bio.present?
			@per = @per + 30
		end
		if @user.profile.is_picture?
			@per = @per + 15
		end
		if @user.cars.present?
			@per = @per + 20
		end
		if @user.phone_number.present?
			if @user.phone_number.verified_no.present? && @user.email_verified.present?
				@per = @per + 15
			end
		end
		if @user.preference.flag > 0
			@per = @per + 20
		end

		if @user.ratings.count > 12 && @time_diff > 12 && @per > 90
			@rank = "ambassador" 
		elsif @user.ratings.count > 6 && @time_diff > 6 && @per > 80
			@rank = "expert" 
		elsif @user.ratings.count > 3 && @time_diff > 3 && @per > 70
			@rank = "experiences" 
		elsif @user.ratings.count > 1 && @time_diff > 1 && @per > 60
			@rank = "intermediate"
		else
			@rank = "newcomer"
		end
		return @rank
	end
end
