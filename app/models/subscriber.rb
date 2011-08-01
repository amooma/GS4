class Subscriber < ActiveRecord::Base
  set_table_name "subscriber"
  validates_presence_of :username
  validates_uniqueness_of :username, :scope => [:domain]
  validates_presence_of :domain
  validates_uniqueness_of :domain, :case_sensitive => false, :scope => [:username]
  

  after_save :generate_auth_db
  after_destroy :generate_auth_db
  
  private
  def generate_auth_db
    if (Configuration.get(:auth_db_engine) == 'dbtext')
      generate_dbtext()
    end
  end
  
  def generate_dbtext
    dbtext = File.open(File.expand_path(Configuration.get(:dbtext_subscriber_file, '/etc/kamailio/db_text/subscriber')), "w")
    dbtext.puts("username(str) domain(str) password(str) email_address(str) datetime_created(int) datetime_modified(int) ha1(str) ha1b(str) rpid(str,null)")
    Subscriber.all().each do |subscriber|
      if (subscriber.domain == nil || subscriber.domain == "")
        subscriber.domain = "x"
      end
      if (subscriber.password == nil || subscriber.password == "")
        subscriber.password = "x"
      end
      if (subscriber.email_address == nil || subscriber.email_address == "")
        subscriber.email_address = "x"
      end
      if (subscriber.ha1 == nil || subscriber.ha1 == "")
        subscriber.ha1 = "x"
      end
      if (subscriber.ha1b == nil || subscriber.ha1b == "")
        subscriber.ha1b = "x"
      end
      if (subscriber.username)
        dbtext.puts("#{subscriber.username}:#{subscriber.domain}:#{subscriber.password}:#{subscriber.email_address}:#{subscriber.created_at.to_i}:#{subscriber.updated_at.to_i}:#{subscriber.ha1}:#{subscriber.ha1b}::");
      end
    end
    dbtext.close()
  end
end
