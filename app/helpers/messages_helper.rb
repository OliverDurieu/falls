module MessagesHelper

  def get_recieved_message_count
    current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND messages.message_type = ?", GlobalConstants::MessageThreads::STATUS[:active], GlobalConstants::Messages::TYPE[:received]).size
  end

  def get_sent_message_count
    current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND messages.message_type = ?", GlobalConstants::MessageThreads::STATUS[:active], GlobalConstants::Messages::TYPE[:sent]).size
  end

  def get_archived_message_count
    current_user.message_threads.where("message_threads.status = ?", GlobalConstants::MessageThreads::STATUS[:archived]).size   
  end

  def set_selected action_name, view
    if action_name == view
      return 'selected'
    end  
  end  

  def hide_if_archived message

    if action_name == ''
      return 'hidden'
    end  
    
  end

end
