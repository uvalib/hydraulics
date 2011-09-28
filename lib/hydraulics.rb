module Hydraulics
  require 'hydraulics/engine' if defined?(Rails)
  require 'hydraulics/custom_validators'
  ActiveRecord::Base.send(:include, CustomValidators)
end
