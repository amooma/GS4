class AddManualUrlToPhoneModels < ActiveRecord::Migration
  def self.up
    add_column :phone_models, :manual_url, :string
  end

  def self.down
    remove_column :phone_models, :manual_url
  end
end
