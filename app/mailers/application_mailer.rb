class ApplicationMailer < ActionMailer::Base
  from_address = ActionMailer::Base.smtp_settings[:user_name]
  default from: "Ticketee App <#{from_address}>"
  layout 'mailer'
end
