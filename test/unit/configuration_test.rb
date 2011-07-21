require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
	should "have a valid factory" do
		assert Factory.build(:configuration).valid?
	end

	should "be valid with nil value" do
		assert Factory.build(:configuration, :value => nil).valid?
	end

	should "not be valid with nil name" do
		assert ! Factory.build(:configuration, :name => nil).valid?
	end

	should "not be valid with duplicate name" do
		entry = Factory.create(:configuration)
		assert ! Factory.build(:configuration, :name => entry.name).valid?
	end
end
