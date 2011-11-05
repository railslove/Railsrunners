class Run < ActiveRecord::Base
  validates_presence_of :name, :user, :distances, :start_at
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_format_of :charity_url, :with => URI::regexp(%w(http https))
  validate :url_is_a_valid_map_url
  validate :start_at_in_future
  # not validated: :notes

  has_many :participants, :dependent => :destroy
  has_many :distances, :dependent => :destroy
  belongs_to :user

  accepts_nested_attributes_for :distances, :allow_destroy => true, :reject_if => proc { |attributes| attributes['distance_in_km'].blank? }

  scope :registerable, where('runs.start_at > ?', Time.now)
  scope :past, where('runs.start_at < ?', Time.now)

  def visual_name(unit = 'km')
    unit = 'km' unless unit == 'mi'
    "#{self.name} (#{self.send(:"distances_in_#{unit}")})"
  end

  def distances_in_km
    distances = self.distances.map(&:distance_in_km)
    # let's do that to get rid of "1.0 km" and show "1 km" instead
    distances = distances.map{ |distance| distance.to_i == distance ? distance.to_i : distance }
    if distances.size > 1
      "#{distances.min} km - #{distances.max} km"
    else
      "#{distances.min} km"
    end
  end

  def distances_in_mi
    distances = self.distances.map(&:distance_in_mi)
    distances = distances.map{ |distance| distance.to_i == distance ? distance.to_i : distance }
    if distances.size > 1
      "#{distances.min} mi - #{distances.max} mi"
    else
      "#{distances.min} mi"
    end
  end

  private

  def start_at_in_future
     errors.add(:base, "You can't add a run in past") if self.start_at.present? && !self.start_at.future?
  end

  # this is hackish... want to use api's here.
  def url_is_a_valid_map_url
    errors.add(:map_url, "This isn't a google maps url") if self.map_url.present? && /^http:\/\/maps\.google\.com\//.match(self.map_url).nil? && /^http:\/\/www\.gmap-pedometer\.com\//.match(self.map_url).nil?
  end
end
