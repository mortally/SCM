class Admin::UserRolesController < Admin::AdminController
  before_filter :get_user
  def index
    @roles = Role.all
  end
  
  def create
    @roles = (Role.find(params[:user][:role_ids]) if params[:user] && params[:user][:role_ids])
    
    @user.roles = (@roles || [])
    
    if @user.save
      flash[:notice] = "User roles were successfully updated."      
    else
      flash[:error] = 'There was a problem updating the roles for this user.'
    end
    
    redirect_to admin_user_roles_path(@user)
  end
  
  protected
  
  def get_user
    @user = User.find params[:user_id]
  end
end
