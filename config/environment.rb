# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gemeinschaft4::Application.initialize!

AUTH_DB_ENGINE = 'dbtext'

if (Rails.env.production?)
  DBTEXT_SUBSCRIBER_FILE = '/opt/kamailio-3.1/etc/kamailio/db_text/subscriber'
elsif (Rails.env.test?)
  DBTEXT_SUBSCRIBER_FILE = '/tmp/subscriber.test'
else
  DBTEXT_SUBSCRIBER_FILE = '/tmp/subscriber.test'
end