class RatingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_rating, only: [ :edit, :update, :destroy]
  # before_filter :show_ratings
  
  def hints
    puts params
  end
  def rate_user
    @user = User.find(current_user.message_threads.find(params[:thread_id]).communicator_id)
    if @user.present?
        rating = @user.ratings.find_by(from_user_id: current_user.id)
        if rating.present? 
          redirect_to edit_rating_path(rating.id)
        else
          redirect_to new_rating_path({ uid: @user.id})
        end
    else
      flash[:danger] = "Sorry! This information does not belong to a LaMule member."
      redirect_to hints_ratings_path
    end
  end
  def search_user
    if current_user.email == params[:email ] || current_user.phone_number.body == params[:phone_no] || current_user.phone_number.body == "0#{params[:phone_no]}"
      flash[:danger] = "You can't leave yourself a rating!"
      redirect_to hints_ratings_path
    else

      if params[:email].present?
        @user = User.find_by(email: params[:email])
      elsif params[:phone_no].present?
        
        if params[:phone_no][0] == "0"
          params[:phone_no].slice!(0)
        end  
        @user = User.joins(phone_number: :country).find_by("phone_numbers.body = ? AND countries.id = ?", params[:phone_no], params[:country_id])
      end
      
      if @user.present?
        rating = @user.ratings.find_by(from_user_id: current_user.id)
        if rating.present? 
          redirect_to edit_rating_path(rating.id)
        else
          redirect_to new_rating_path({ uid: @user.id})
        end
      else
        flash[:danger] = "Sorry! This information does not belong to a LaMule member."
        redirect_to hints_ratings_path
      end
    end
    

  end

  def received
    show_ratings(current_user)
  end

  def given
    @ratings = current_user.given_ratings
  end

  def new
    @user = User.find(params[:uid])
    @rating = current_user.given_ratings.new(user_id: @user.id)
  end

  def create
    @rating = current_user.given_ratings.build(rating_params)
    if @rating.save
      user = User.find(params[:rating][:user_id])
      if user.notifications.notification_status('receive_rating')
        puts 'ratingmailsent_real'
        mandrill = MandrillMailer.new
        mandrill.rating_recieved_mail(user)
      end
      redirect_to given_ratings_path
    else
      @user = User.find(params[:rating][:user_id])
      render 'new'
    end
  end

  def edit
    @user = @rating.user
  end

  def update
    if @rating.update(rating_params)
      redirect_to given_ratings_path
    else
      render 'edit'
    end
  end

  def destroy
    @rating.destroy
    redirect_to given_ratings_path
  end

  private
  def set_rating
    @rating = current_user.given_ratings.find(params[:id]) 
  end

  def rating_params
    params.require(:rating).permit(:user_id, :star, :comment, :driving_skill, :user_type)
  end

end
