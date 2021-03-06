class Admin::PermissionsController < Admin::BaseController

  before_action :set_user

  def index
    @ability = Ability.new(@user)
    @projects = Project.all
  end

  def set
    @user.permissions.clear
    # {"1"=>{"view"=>"1"}, "2"=>{"view"=>"1"}, "6"=>{"view"=>"1"}}
    params[:permissions].each do |id, permissions|
      project = Project.find(id)
      permissions.each do |permission, _|
        Permission.create!(user: @user, thing: project, action: permission)
      end
    end
    redirect_to admin_user_permissions_path(@user), notice: 'Permissions updated.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
