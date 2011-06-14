require 'test_helper'

class PhoneKeyFunctionDefinitionTest < ActiveSupport::TestCase
  
  should "be valid" do
    assert Factory.build(:phone_key_function_definition).valid?
  end

  # Test valid name
  [
    '',
    nil
  ].each do |name|
    should "not allow #{name} as name" do
      assert !Factory.build( :phone_key_function_definition, :name => name ).valid?
    end
  end
  
  # Test valid type_of_class
  [
    'string',
    'integer',
    'boolean',
    'url',
    'uri',
  ].each do |type_of_class|
    should "allow #{type_of_class.inspect} as type_of_class" do
      assert Factory.build( :phone_key_function_definition, :type_of_class => type_of_class ).valid?
    end
  end
  
  # Test invalid type_of_class
  [
    'String',
    'Str',
    'str',
    'Integer',
    'Int',
    'int',
    'FixNum',
    'Fixnum',
    'fixnum',
    'Boolean',
    'Bool',
    'bool',
    'Url',
    'URL',
    'Uri',
    'URI',
    '',
    nil,
    'Object',
  ].each do |type_of_class|
    should "not allow #{type_of_class.inspect} as type_of_class" do
      assert ! Factory.build( :phone_key_function_definition, :type_of_class => type_of_class ).valid?
    end
  end
  
  
  # Test valid regex_validation
  [
    nil,
    '',
    //                .to_s,  # "(?-mix:)"
    /^$/              .to_s,  # "(?-mix:^$)"
    /^ .* $/x         .to_s,  # "(?x-mi:^ .* $)"
    /[\\x00]/         .to_s,
    /[\\u0000]/       .to_s,
    /[\\u{00}]/       .to_s,
    /[\\u{000000}]/   .to_s,
    /[\\u{10ffff}]/   .to_s,
  ].each { |regex_validation|
    should "allow #{regex_validation.inspect} as regex_validation" do
      assert Factory.build(
        :phone_key_function_definition,
        :regex_validation => regex_validation
      ).valid?
    end
  }
  
  # Test invalid regex_validation
  [
    '\\',             # too short escape sequence
    '\\(?-mix:)',     # unmatched close parenthesis
    '(',              # end pattern with unmatched parenthesis
    '(?-mix:^$',      # end pattern with unmatched parenthesis
    '[',              # premature end of char-class
    '{0,2}',          # target of repeat operator is not specified
    '*',              # target of repeat operator is not specified
    '?',              # target of repeat operator is not specified
    '[]',             # empty char-class
    '[\\x]',          # invalid hex escape
    '[z-a]',          # empty range in char class
    '[\\u00]',        # invalid Unicode escape
    '[\\u{FFFFFF}]',  # invalid Unicode range
    '[\\u{110000}]',  # invalid Unicode range
    '[\\u{0000000}]', # invalid Unicode range
    '[\u{00-}]',      # invalid Unicode list
    '[\u{}]',         # invalid Unicode list
  ].each { |regex_validation|
    should "not allow #{regex_validation.inspect} as regex_validation" do
      assert ! Factory.build(
        :phone_key_function_definition,
        :regex_validation => regex_validation
      ).valid?
    end
  }
  
  
end
