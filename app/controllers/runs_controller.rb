class RunsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @runs = Run.all(:order => "runs.when DESC", :include => [:user])
  end

  def new
    @run = Run.new
  end
  
  def create
    @run = Run.create(params[:run].merge(:user_id => current_user.id))
    redirect_to :action => :index
  end
end
