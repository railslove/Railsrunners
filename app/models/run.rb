class Run < ActiveRecord::Base
  validates_presence_of :name, :user, :distances, :start_at
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_format_of :charity_url, :with => URI::regexp(%w(http https))
  validate :start_at_in_future
  before_validation :remove_duplicate_distances
  before_save :encode_google_map, :if => :msid_changed?
  # not validated: :notes

  has_many :participants, :dependent => :destroy
  has_many :distances, :dependent => :destroy
  belongs_to :user

  accepts_nested_attributes_for :distances, :allow_destroy => true, :reject_if => proc { |attributes| attributes['distance_in_km'].blank? }

  scope :registerable, where('runs.start_at > ?', Time.now)
  scope :past, where('runs.start_at < ?', Time.now)

  def visual_name(unit = 'km')
    unit = 'km' unless unit == 'mi'
    "#{name} (#{distances_in(unit)})"
  end

  def past?
    start_at.past?
  end

  private

  def distances_in(unit)
    my_distances = (unit == "km" ? distances.map(&:distance_in_km) : distances.map(&:distance_in_mi))
    my_distances = my_distances.map{ |distance| distance.to_i == distance ? distance.to_i : distance }
    if my_distances.size > 1
      "#{my_distances.min} #{unit} - #{my_distances.max} #{unit}"
    else
      "#{my_distances.min} #{unit}"
    end
  end

  def encode_google_map
    response = HTTParty.get "http://static-maps-generator.appspot.com/url?msid=#{msid}&size=950x300"
    self.map_url = response.body
  end

  #####################################
  ##  VALIDATING FUNCTIONS
  #####################################

  def remove_duplicate_distances
    distances.each do |distance|
      ary = distances - [distance]
      ary.each do |distance_to_check|
        distance_to_check.destroy if distance.distance_in_km == distance_to_check.distance_in_km && (!distance.destroyed? && !distance_to_check.destroyed?)
      end
    end
  end

  def start_at_in_future
     errors.add(:base, "You can't add a run in past") if start_at.present? && !start_at.future?
  end
end
