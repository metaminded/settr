require 'test_helper'
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

class SettrTest < ActiveSupport::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    Setting.clean!
    DatabaseCleaner.clean
  end

  test "truth" do
    assert_kind_of Module, Settr
  end

  test "Access default setting" do
    assert_equal Setting['string_1'], 'abc'
    assert_equal Setting.find_by(key: 'string_1').value, 'abc'

    assert_equal Setting['integer_1'], 5
    assert_equal Setting.find_by(key: 'integer_1').value, '5'
  end

  test "Update stored setting" do
    assert_equal Setting['string_1'], 'abc'
    assert_equal Setting.find_by(key: 'string_1').value, 'abc'

    Setting['string_1'] = 'def'

    assert_equal Setting['string_1'], 'def'
    assert_equal Setting.find_by(key: 'string_1').value, 'def'
  end

  test "Create new setting" do
    Setting['string_1'] = 'def'
    assert_equal Setting.find_by(key: 'string_1').value, 'def'
    assert_equal Setting['string_1'], 'def'
  end

  test "Use Settings for setting forms" do
    s = Settings.new
    s.setting_model = Setting
    assert_equal s.string_1, 'abc'
  end
end
