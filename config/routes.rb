Rails.application.routes.draw do
  get 'errors/exception_occured'

	get '/analytics', to: "analytics#index"
	get 'messages/received'
	get 'messages/sent'
	get 'messages/archived'
	get 'dashboard/show_dashboard'
	get 'dashboard/contact_us'
	get 'dashboard/contact_us_submit'
	get 'dashboard/public_urls'
	get 'summary/Lamule_community'
	get 'summary/ExperienceLevel'
	get 'summary/history'
	get 'summary/policy'
	get 'summary/partner'
	get 'summary/termsconditions'
	get 'summary/howitworks'
	get 'summary/origin'
	get 'summary/about_us'
	get 'users/index_facebook'
	get 'users/index_not_facebook'
	get 'users/signUp_email_page'
	post 'users/verify_uid'
	get 'transections/payment'
	get 'driver_verifications/profile_verification'
	get 'driver_verifications/personal_information'
	post 'transfer_requests/make_transfer_request'


	get 'driver_verifications/email_token_generator'
	
	post 'transfers/transfer_funds'
	get 'notifications/booking_notifications'
	match '/twitter', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/fb-blog-post', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/fb-shark-tank', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/fb-inspirational', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/fb-add', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/fb-boosted-post', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/instagram', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/edm', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/press', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/news', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/photopostcards', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/unirideshare', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/alpinerideshare', :to => 'dashboard#public_urls', :via => [:get, :post]
	match '/surfrideshare', :to => 'dashboard#public_urls', :via => [:get, :post]
	


	devise_for :users,
						 controllers: {
								 sessions: "users/sessions",
								 registrations: "users/registrations",
								 passwords: "users/passwords",
								 omniauth_callbacks: "users/omniauth_callbacks"
						 }
	root :to => "dashboard#index"
	resources :users

	get "/fill_phone", to: "phone_number#fill_phone"
	get "/verify_phone_number", to: "phone_number#verify_phone_number"
	get "/confirm_phone", to: "phone_number#confirm_phone"
	get "/confirmation_phone", to: "phone_number#confirmation_phone"
	get "/complete_registration_proccess", to: "users#complete_registration_proccess"
	get "/send_verify_email", to: "users#send_verify_email"
	get "/verified_the_email", to: "users#verified_the_email"
	get "/profile/preferences", to: "preferences#edit"
	get "/profile/notifications", to: "notifications#index"
	get "/profile/social_sharing", to: "users#social_sharing"
	get '/profile/credit_card', to: "users#credit_card"
	post '/transfers/revert_transfer/:id', to: "transfers#revert_transfer", as: "revert_transfer"
	patch '/profile/update_credit_card_info', to: "users#update_credit_card_info"
	post "/profile/disconnect_facebook", to: "users#disconnect_facebook"
	
	get "/offer-seats/1", to: "rides#offer_seat_1"
	get "/:id/offer-seats/2", to: "rides#offer_seat_2"
	resources :users, only: [] do
		member do
			get :public_profile
			get :payments_history
		end
		collection do
			post :send_direct_message
		end	
	end
	
	resources :driver_verifications, only: [:index] do
		collection do
			get :steps
			post :verify_profile
			post :verify_email_pin_code
			post :verify_phone_pin_code
			get  :check_email_verified
			get  :check_phone_verified
			post :verify_personal_info
			get :finished
		end	
	end
		
	resources :bookings do
		collection do
			get :past_bookings
		end
		member do
			get :accept
			get :reject
		end
	end
	resources :profile, only: [] do
		collection do
			get :general
			get :photo
			get :verifications
			get :address
			patch :update_general_info
			patch :update_address
			post :verify_email_phone
		end
		member do
			patch :upload_photo
		end
	end
	resources :unsubscribes, only: [] do
		collection do
			get 'account'
			delete 'delete_account'
		end
	end
	resources :cars, only: [:index, :new, :create, :edit, :update, :destroy] do
		member do
			patch :upload_image
		end
	end

	resources :transections, only: [:refund] do
		member do
			get :refund
		end
	end
	
	resources :car_makers, only: [] do
		resources :car_models, only: [:index]
	end
	resources :preferences, only: [:update]
	resources :notifications, only: [] do
		collection do
			patch :update_user_notifications
			patch :update_fackbook_notifications
		end
	end
	resources :rides, only: [:index, :destroy, :edit, :update, :show, :create] do
		resources :locations, only: [:destroy]
		collection do
			post :create_offer_1
			get :rides_info
			post :make_legs
			post :make_schedule
			get :previous_rides
			get :archive_rides
			get :range_rides
		end
		member do
			get :share_on_facebook
			patch :create_offer_2
			get :publication
			patch :set_car
			get :contact_to_the_driver
			put :add_seat
			put :delete_seat
			post :duplicate_ride
			get :visitors
			patch :archive
			get :successfully_posted_rides
		end
	end

	resources :message_threads, only: [:show, :destroy] do
		resources :messages, only: [:create]
		member do
			post :set_archive
		end
	end

	resources :ratings, only: [:new, :create, :edit, :update, :destroy] do
		collection do
			get :hints
			get :search_user
			get :rate_user
			get :received
			get :given
		end
	end

	resources :email_alerts, only: [:index, :new, :create, :destroy] do
		collection do
			get :send_email
			get :email_cron
		end
		member do
		   get :update_travel_date
		end
	end

	resource :mail_chimp, only: [:create]

	match '/404', to: 'errors#exception_occured', via: :all
	match '/422', to: 'errors#exception_occured', via: :all
	match '/500', to: 'errors#exception_occured', via: :all



	resources :rides  do 
     collection  do  
        get 'previous_rides' 
     end
  end 
  
resources :rides  do 
     collection  do  
        get 'archive_rides' 
     end
  end 

  # resources :users  do 
  #    collection  do  
  #       get 'verify_uid'
  #    end
  # end 
  get '*unmatched_route', :to => 'application#raise_not_found!'
end
