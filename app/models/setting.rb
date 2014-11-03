class Setting  < ActiveRecord::Base
  validates_presence_of   :key, :kind
  validates_uniqueness_of :key

  # See Rails.root/config/initializers/setting.rb for defaults
  cattr_accessor :defaults

  def self.defaults
    @@defaults || {}
  end

  def self.[](key)
    # Try to load the setting for the given key
    setting = get(key)

    # Returning the proper value.
    if setting.value.present?
      case setting.kind
      when 'string'  then setting.value.to_s
      when 'float'   then setting.value.to_f
      when 'integer' then setting.value.to_i
      when 'boolean' then to_bool(setting.value)
      else
        raise ArgumentError.new(t7e(:errors, :invalid_kind, kind: "\"#{setting.kind}\""))
      end
    else
      nil
    end
  end

  def self.[]=(key, val)
    # Try to load the setting for the given key
    setting = get(key)
    # Returning the proper value.
    setting[:value] = case setting.kind
    when 'string'  then val.to_s
    when 'float'   then val.to_f
    when 'integer' then val.to_i
    when 'boolean' then to_bool(val)
    else
      raise ArgumentError.new(t7e(:errors, :invalid_kind, kind: "\"#{setting.kind}\""))
    end
    setting.save!
    setting.value
  end

  def self.get(key)
    setting = Setting.find_or_create_by!(key: key) do |s|
      default = self.defaults[key.to_s]
      raise ArgumentError.new(t7e(:errors, :no_setting, key: "\"#{key}\"")) unless default
      s[:kind]  = default[:kind]
      s[:value] = default[:value]
    end
  end

  private

  def value=(v)
    self[:value] = v
  end

  # TODO: Move into String ext class
  def self.to_bool(value)
    return true   if value == true   || value =~ (/(true|t|yes|y|1)$/i)
    return false  if value == false  || value.blank? || value =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new(t7e(:errors, :invalid_boolean, value: "\"#{value}\""))
  end
end
