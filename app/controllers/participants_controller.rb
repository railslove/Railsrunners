class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new
    @runs = Run.registerable

    @distances = {}
    @runs.each do |run|
      @distances[run.id] = {}
      run.distances.each do |distance|
        @distances[run.id][distance.id] = distance.distance_in_km
      end
    end
    @distances = @distances.to_json
  end

  def create
    @participant = Participant.new(params[:participant])
    if @participant.save
      redirect_to runs_url
    else
      render :new
    end
  end

  def edit
    @participant = Participant.find_by_result_token(params[:token])
    if @participant
      redirect_to runs_url, :alert => "this run isn't in the past, please try after #{@participant.run.start_at}" unless @participant.run.past?
    else
      redirect_to runs_url, :alert => "sorry, I didn't found a participation"
    end
  end

  # TODO TEST
  def update
    @participant = Participant.find_by_result_token(params[:token])
    if @participant && @participant.run.past?
      @participant.update_attributes(params[:participant])
      redirect_to runs_url, :alert => 'Thanks for your time entry.'
    else
      redirect_to root_url, :alert => 'Something went wrong. Your run isnt in the past'    
    end
  end

end
