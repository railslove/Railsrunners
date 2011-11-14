class RunsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @runs = Run.registerable(:order => "runs.start_at DESC", :include => [:user])
  end

  def results
    @runs = Run.past(:order => "runs.start_at DESC", :include => [:user])
  end

  def insert_result
    @participant = Participant.find_by_result_token(params[:token])
    @run = Run.find(params[:id])
    if @participant.present? && @participant.run == @run
      # Do stuff
    elsif !@run.past?
      redirect_to @run, :alert => 'You cannot add results to runs that have not been finished.'
    else
      redirect_to @run, :alert => 'Your result token is invalid.'
    end
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(params[:run].merge(:user_id => current_user.id))
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
