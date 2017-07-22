class Admin::StatesController < Admin::BaseController

  def index
  end

  def new
    @state = State.new
  end

  def edit
  end

  def create
    state = State.new(state_params)
    if state.save
      redirect_to admin_users_path, notice: 'State has been created.'
    else
      flash[:alert] = 'State has not been created.'
      render 'new'
    end
  end

  private

  def state_params
    params.require(:state).permit(:name)
  end

end
