# encoding: utf-8

require 'test_helper'

class CodecTest < ActiveSupport::TestCase
  should "be valid" do
     assert Factory.build(:codec).valid?
  end
  
  # A codec name must be unique
  #
  should "not be valid with a not unique name" do
    codec = Factory.create(:codec)
    assert ! Factory.build(:codec, :name => codec.name).valid?
  end
  
  # A codec has to have a name (can not be nil)
  #
  should "not be valid with nil name" do
    codec = Factory.create(:codec)
    assert ! Factory.build(:codec, :name => nil).valid?
  end

  # A codec has to have a name (can not be empty)
  #
  should "not be valid with an empty name" do
    codec = Factory.create(:codec)
    assert ! Factory.build(:codec, :name => '').valid?
  end
  
  # A codec name with a space is not valid
  #
  should "not have a name with a space" do
    codec = Factory.create(:codec)
    assert ! Factory.build(:codec, :name => 'A Test Codec').valid?
  end
  
  # A codec name should be lowercase
  #
  should "have a lowercase name" do
    codec = Factory.create(:codec, :name => 'GSM')
    assert codec.name == 'gsm'
  end

  # A codec name should not be longer than 40 characters
  #
  should "not be longer than 40 characters" do
    codec_name = 'c' * 41
    assert ! Factory.build(:codec, :name => codec_name).valid?
  end
  
  
  # valid name
  [
    'gsm',
    'GSM',
    'alaw',
    'aLaw',
    'g711a',
    'G.711a',
    'G.711-a',
    'G.711.1',
  ].each { |name|
    should "be possible to use #{name.inspect} as name" do
      assert Factory.build( :codec, :name => name ).valid?
    end
  }
  
  # invalid name
  [
    nil,
    '',
    ' ',
    'G.711 a',
    'μ-law',
  ].each { |name|
    should "not be possible to use #{name.inspect} as name" do
      assert ! Factory.build( :codec, :name => name ).valid?
    end
  }
  
end
