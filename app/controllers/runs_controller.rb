class RunsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @runs = Run.all(:order => "runs.start_at DESC", :include => [:user])
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(params[:run].merge(:user_id => current_user.id))
    if @run.save
      redirect_to root_path
    else
      render :new
    end
  end

end
