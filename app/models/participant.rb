class Participant < ActiveRecord::Base
  validates_presence_of :name, :run, :distance

  scope :confirmed, :conditions => "participants.confirmed_at IS NOT NULL"

  belongs_to :run
  belongs_to :distance

  # right now just automatically accept the runners
  before_save :accept, :on => :create

  private

  def accept
    self.confirmed_at = Time.now
  end
end