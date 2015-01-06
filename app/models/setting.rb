class Setting  < ActiveRecord::Base
  validates_presence_of   :key, :kind
  validates_uniqueness_of :key

  # See Rails.root/config/initializers/setting.rb for defaults
  cattr_accessor :defaults

  def self.defaults
    @@defaults || {}
  end

  def self.[](key)
    setting = store[key.to_s]

    return nil if setting.value.nil?
    case setting.kind
    when 'string'  then setting.value.to_s
    when 'float'   then setting.value.to_f
    when 'integer' then setting.value.to_i
    when 'boolean' then to_bool(setting.value)
    else
      raise ArgumentError.new("Unknown kind: #{setting.kind}")
    end
  end

  def self.[]=(key, val)
    setting = store[key.to_s]

    setting.value = case setting.kind
    when 'string'  then val.to_s
    when 'float'   then val.to_f
    when 'integer' then val.to_i
    when 'boolean' then to_bool(val)
    else
      raise ArgumentError.new("Unknown kind: #{setting.kind}")
    end
    setting.save!
    setting.value
  end

  def self.clean!
    RequestStore.store[:settr_settings] = {}
    @_latest_update   = nil
    @_saved_settings  = nil
  end

  private

  # TODO: Move into String ext class
  def self.to_bool(value)
    return true   if value == true   || value =~ (/(true|t|yes|y|1)$/i)
    return false  if value == false  || value.blank? || value =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("Invalid boolean: #{value}")
  end

  def self.store
    return RequestStore.store[:settr_settings] if RequestStore.store[:settr_settings].present?
    ns = maximum(:updated_at).to_f
    if @_latest_update && (@_latest_update == ns)
      return(RequestStore.store[:settr_settings] = @_saved_settings)
    end
    reload
  end

  def self.reload
    @_latest_update = maximum(:updated_at).to_f
    st = Time.now.to_f
    db = Hash[all.map do |s| [s.key, s] end]
    ss = defaults.map do |key, vv|
      if db.has_key? key
        v = db[key]
      else
        setting = Setting.create!(
        key: key,
        kind: vv[:kind],
        value: vv[:value]
        )
        v = setting
      end
      [ key, v ]
    end
    @_saved_settings = (RequestStore.store[:settr_settings] = Hash[ss])
  end
end
