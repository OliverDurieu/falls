class MessageThreadsController < ApplicationController

  before_action :set_message_thread, only: [:show, :set_archive, :destroy]
  layout "messages", only: [:show]

  def show
    if @message_thread.unread?
      @message_thread.update!(unread: false)
    end
    @ride = @message_thread.ride
    @messages = @message_thread.messages
    @user = @message_thread.user
    @communicator = @message_thread.communicator
    @message = Message.new
  end 

  def set_archive
    respond_to do |format|
      if @message_thread.update(status: GlobalConstants::MessageThreads::STATUS[:archived])
        format.json { render json: true } # 200 OK

      else
        format.json { render json: @message_thread.errors, status: :unprocessable_entity }
      end 
    end 
  end 

  def destroy
    respond_to do |format|
      if @message_thread.destroy
        format.json { render json: true } # 200 OK
      else
        format.json { render json: @message_thread.errors, status: :unprocessable_entity }
      end # end of if else
    end # end of respond to
  end # end of def

  private
  def set_message_thread
    @message_thread = current_user.message_threads.find(params[:id])
  end
  
end
