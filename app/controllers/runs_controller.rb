class RunsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]

  def index
    @runs = Run.registerable(:order => "runs.start_at DESC", :include => [:user])
  end

  def results
    @runs = Run.past(:order => "runs.start_at DESC", :include => [:user])
  end

  def new
    @run = Run.new
  end

  def create
    @run = current_user.runs.build(params[:run])
    if @run.save
      redirect_to runs_url
    else
      render :new
    end
  end

  def edit
    @run = current_user.runs.find(params[:id])
  end

  def update
    @run = current_user.runs.find(params[:id])
    if @run.update_attributes(params[:run])
      redirect_to runs_url
    else
      render :edit
    end
  end

end
