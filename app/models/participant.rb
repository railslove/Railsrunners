class Participant < ActiveRecord::Base
  validates_presence_of :name, :run, :distance

  scope :confirmed, :conditions => "participants.confirmed_at IS NOT NULL"

  belongs_to :run
  belongs_to :distance

  validate :cannot_participate_in_past_run

  before_save :calculate_time, :on => :update
  # right now just automatically accept the runners
  before_save :accept, :on => :create
  before_save :create_result_token, :on => :create
  after_save :send_an_email, :on => :create

  ["hours", "minutes", "seconds"].each do |time_frame|
    redefine_method :"#{time_frame}=" do |value|
      self.instance_variable_set(:"@#{time_frame}", value)
    end
  end

  def hours
    instance_variable = @hours.to_i rescue nil
    if instance_variable.present?
      instance_variable
    else
      if self.time.present?
        self.time.divmod(1.hour)[0]
      end
    end
  end

  def minutes
    instance_variable = @minutes.to_i rescue nil
    if instance_variable.present?
      instance_variable
    else
      if self.time.present?
        self.time.divmod(1.hour)[1].divmod(1.minute)[0]
      end
    end
  end

  def seconds
    instance_variable = @seconds.to_i rescue nil
    if instance_variable.present?
      instance_variable
    else
      if self.time.present?
        self.time.divmod(1.hour)[1].divmod(1.minute)[1]
      end
    end
  end

  private

  def cannot_participate_in_past_run
    errors.add(:run, 'has already took place. You can only register for upcoming runs.') if self.run && self.run.past?
  end

  def accept
    self.confirmed_at = Time.now
  end

  def create_result_token
    self.result_token = Digest::MD5.hexdigest(Kernel.rand.to_s).upcase
  end

  def send_an_email
    ParticipantMailer.result_insert_link(self).deliver
  end

  def calculate_time
    h = self.hours
    m = self.minutes
    s = self.seconds
    self.time = h.hours + m.minutes + s.seconds
  end
end
