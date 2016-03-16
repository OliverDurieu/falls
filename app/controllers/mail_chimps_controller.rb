class MailChimpsController < ApplicationController
  def create
    begin
      gb = Gibbon::API.new("85d24e69266f47b3f3d94ac6aa62711a-us9")
      gb.lists.subscribe({:id => '462fd1e88d', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
      redirect_to :back
    rescue
      puts "MAIL CHIMP ERROR!!!! POSSIBLE DUPLICATION OR ENSURE THE EMAIL FORMAT"
      redirect_to :back
    end  
  end  
end
