Rails.application.config.action_mailer.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "share-n-roll.com",
  :user_name            => "team@railslove.com",
  :password             => "railsislovebaby",
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
