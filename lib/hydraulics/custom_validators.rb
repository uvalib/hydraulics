require 'active_model'

module Hydraulics
  module CustomValidators

    class AutomationMessageAssociationValidator < ActiveModel::EachValidator
      def validate_each(record)
        if not value =~ /^[a-z0-9_\.-]+@[a-z0-9_\.-]+\.[a-z0-9_-]+$/i
          record.errors.add(attribute, "should be of the format user@host.domain")
        end
      end
    end

    class CityFormatValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if not value =~ /^([a-z\. -]+)$/i
          record.errors.add(attribute, "should only contain alphabetic characters, period, hyphen, and spaces")
        end
      end
    end

    class EmailValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if not value =~ /^[a-z0-9_\.-]+@[a-z0-9_\.-]+\.[a-z0-9_-]+$/i
          record.errors.add(attribute, "should be of the format user@host.domain")
        end
      end
    end

    class PersonNameFormatValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if not value =~ /^([a-z\.\, \-']+)$/i
          record.errors.add(attribute, "should only contain alphabetic characters, period, comma, hyphen, and spaces")
        end
      end
    end

    class PhoneFormatValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if not value =~ /^([0-9\.+ -]+)$/i
          record.errors.add(attribute, "should only contain digits, period, plus sign, hyphen, and spaces")
        end
      end
    end

    class XssValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if value =~ /<|>/
          record.errors.add(attribute, "cannot have greater or less than (< or >) characters")
        end
      end
    end

  end
end