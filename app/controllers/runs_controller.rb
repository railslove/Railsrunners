class RunsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @runs = Run.all(:order => "runs.when DESC", :include => [:user])
  end

  def new
    @run = Run.new
  end
  
  def create
    @run = Run.new(params[:run].merge(:user_id => current_user.id))
    if @run.save
      redirect_to :action => :index
    else
      redirect_to :action => :index
    end
  end
end
