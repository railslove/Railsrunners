class Participant < ActiveRecord::Base
  validates_presence_of :name, :run, :distance

  scope :confirmed, :conditions => "participants.confirmed_at IS NOT NULL"

  belongs_to :run
  belongs_to :distance

  validate :cannot_participate_in_past_run

  # right now just automatically accept the runners
  before_save :accept, :on => :create

  private

  def cannot_participate_in_past_run
    errors.add(:run, 'has already took place. You can only register for upcoming runs.') if run && run.past?
  end

  def accept
    self.confirmed_at = Time.now
  end
end
