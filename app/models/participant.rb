class Participant < ActiveRecord::Base
  validates_presence_of :name, :run, :distance

  scope :confirmed, :conditions => "participants.confirmed_at IS NOT NULL"

  belongs_to :run
  belongs_to :distance
end