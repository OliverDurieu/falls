class AnalyticsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :admin_only

  def index
  end

  private

  def admin_only
  	redirect_to :back, notice: "Access denied." unless current_user.admin? 
  end

end
