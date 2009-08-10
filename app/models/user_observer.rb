class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Admin::AdminNotifier.deliver_create_account_notification(user)
  end
end
