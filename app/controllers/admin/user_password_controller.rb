class Admin::UserPasswordController < Admin::AdminController
  before_filter :get_user
  
  def show
  end
  
  def create
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]    
    if @user.save
      Admin::AdminNotifier.deliver_password_change_notification(@user)
       flash[:notice] = "Password successfully updated."
      redirect_to [:admin,@user]
    else
      @old_password = nil
      flash.now[:error] = @user.errors.on_base || "There was a problem updating your password."
      render :action => 'show'
    end
  end
  
  protected
  
  def get_user
    @user = User.find params[:user_id]
  end
end
