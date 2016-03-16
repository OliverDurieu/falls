class MyDeviseMailer < Devise::Mailer

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new
  end 

  def reset_password_instructions(record, token, opts={})
    template_name = "reset-you-password"
    template_content = []
    message = {
      to: [{email: record.email}],
      subject: "Password Reset",
      merge_vars: [{
        rcpt: record.email,
        vars: [
          {name: "RESETLINK", content: "#{BASE_URL}/users/password/edit?reset_password_token=#{token}"},
          {name: "USERNAME", content: record.first_name}
        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content,message
  end

end
