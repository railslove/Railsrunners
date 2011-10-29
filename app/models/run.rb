class Run < ActiveRecord::Base
  validates_presence_of :name, :user, :distances
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_format_of :charity_url, :with => URI::regexp(%w(http https))
  # not validated: :start_at, :notes

  has_many :participants
  has_many :distances
  belongs_to :user

  accepts_nested_attributes_for :distances, :allow_destroy => true, :reject_if => proc { |attributes| attributes['distance_in_km'].blank? }

  scope :registerable, where('runs.start_at > ?', Time.now)

  def visual_name
    "#{self.name} (#{distances_in_km})"
  end
  
  def distances_in_km
    distances = self.distances.map(&:distance_in_km)
    if distances.size > 1
      "#{distances.min} km - #{distances.max} km"
    else
      "#{distances.min} km"
    end
  end
end
