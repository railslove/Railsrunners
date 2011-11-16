class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new
    @runs = Run.registerable

    @distances = {}
    @runs.registerable.each do |run|
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

  # TODO TEST  
  def edit
    @participant = Participant.find_by_result_token(params[:token])
  end

  # TODO TEST
  def update
    @participant = Participant.find_by_result_token(params[:token])
    if @participant && !@participant.run.past?
      redirect_to runs_url, :alert => 'Thanks for your time entry.'
    else
      redirect_to root_url, :alert => 'Something went wrong'    
    end
  end

end
