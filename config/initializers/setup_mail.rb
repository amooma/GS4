ActionMailer::Base.smtp_settings = {
  :address              => Configuration.get(:smarthost_hostname, '127.0.0.1'),
  :port                 => Configuration.get(:smarthost_port, 25, Integer),
  :domain               => Configuration.get(:smarthost_domain, 'gemeinschaft.local'),
  :user_name            => Configuration.get(:smarthost_username, ''),
  :password             => Configuration.get(:smarthost_password, ''),
  :authentication       => Configuration.get(:smarthost_authentication, 'plain'),
  :enable_starttls_auto => Configuration.get(:smarthost_enable_starttls_auto, true, Configuration::Boolean)
}
