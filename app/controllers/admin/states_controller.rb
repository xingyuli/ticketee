class Admin::StatesController < Admin::BaseController

  def index
  end

  def new
    @state = State.new
  end

  def make_default
    @state = State.find(params[:id])
    @state.default!
    redirect_to admin_states_path, notice: "#{@state.name} is now the default state."
  end

  def create
    state = State.new(state_params)
    if state.save
      redirect_to admin_states_path, notice: 'State has been created.'
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
