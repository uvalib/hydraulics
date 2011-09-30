module Hydraulics
  require 'hydraulics/engine' if defined?(Rails)
  require 'hydraulics/custom_validators'
  ActiveRecord::Base.send(:include, CustomValidators)

  def self.root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

  def self.models_dir
    "#{root}/app/models"
  end

  def self.helpers_dir
    "#{root}/lib/helpers"
  end
end
end
