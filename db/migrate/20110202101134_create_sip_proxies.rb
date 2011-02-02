class CreateSipProxies < ActiveRecord::Migration
  def self.up
    create_table :sip_proxies do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_proxies
  end
end
