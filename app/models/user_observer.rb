class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #This doesn't appear to work on aifa
    #Admin::AdminNotifier.deliver_create_account_notification(user)
  end
end
