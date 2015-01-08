class Settings
  include ActiveModel::Model

  attr_accessor :setting_model

  def self.human_attribute_name(a)
    I18n.translate "activerecord.attributes.settings.#{a}"
  end

  def column_for_attribute(attribute)
    # in ActiveRecord this returns a ActiveRecord::ConnectionAdapters::Column
    # so we need to return something that satisfies simple_form's expectations
    ducktyped_column_from(attribute, setting_model.get(attribute).kind)
  end

  def method_missing(method_name, *arguments, &block)
    if (setting = setting_model[method_name]).present?
      setting
    else
      setting_model.send(method_name, *arguments, &block)
    end
  end

  def respond_to?(method_name, include_private = false)
    setting_model[method_name].present? || super
  end

  private

  def ducktyped_column_from(attribute, kind)
    Struct.new(:limit, :name, :type).new(
      nil,
      attribute,
      kind.to_sym
    )
  end
end
