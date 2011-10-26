class Run < ActiveRecord::Base
  validates_presence_of :name, :user
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_numericality_of :distance_in_km, :greater_than => 0, :allow_nil => true
  validates_format_of :charity_url, :with => URI::regexp(%w(http https))

  # not validated: :when, :notes

  has_many :participants
  belongs_to :user

  def visual_name
    "#{self.name}#{" - #{self.distance_in_km} km" if self.distance_in_km?}"
  end
end
