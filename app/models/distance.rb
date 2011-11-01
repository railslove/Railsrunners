class Distance < ActiveRecord::Base
  belongs_to :run
  has_many :participants, :dependent => :destroy

  validates_numericality_of :distance_in_km, :greater_than => 0

  def distance_in_mi
    (self.distance_in_km * 0.6214).round(2)
  end

  def distance_in_mi=(value)
    self.distance_in_km = value * 1.609
  end
end
