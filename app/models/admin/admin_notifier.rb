class Admin::AdminNotifier < ActionMailer::Base
  def create_account_notification(user)
    recipients user.email
    from "asleep@umich.edu"
    subject "[Computer Poker Analysis] Account creation"
    body :user=>user
  end
  
  def password_change_notification(user)
    recipients user.email
    from "asleep@umich.edu"
    subject "[Computer Poker Analysis] Password Changed"
    body :user=>user
  end
end
