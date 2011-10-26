class ParticipationController < ApplicationController

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
    Participant.create(params[:participant])
    redirect_to root_path
  end
end
