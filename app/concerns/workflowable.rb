module Workflowable

  extend ActiveSupport::Concern

  included do
    has_many :automation_messages, :as => :messagable, :dependent => :destroy
  end
end
