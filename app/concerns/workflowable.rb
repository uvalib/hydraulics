module Workflowable

  extend ActiveSupport::Concern

  has_many :automation_messages, :as => :messagable, :dependent => :destroy
end
