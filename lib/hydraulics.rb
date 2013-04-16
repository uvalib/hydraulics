require "hydraulics/engine"

module Hydraulics
  require 'hydraulics/custom_validators'
  ActiveRecord::Base.send(:include, CustomValidators)

  #TODO: Remove these and replace with decorator method as described in Rails 4 documentation
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
