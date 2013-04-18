class AutomationMessage < ActiveRecord::Base
  
  MESSAGE_TYPES = %w[error success failure info]
  WORKFLOW_TYPES = %w[administrative archive delivery patron production qa repository unknown]
  APPS = %w[hydraulics]

  belongs_to :messagable, :polymorphic => true, :counter_cache => true

  validates :message, :app, :processor, :message_type, :workflow_type, :presence => true
  validates :workflow_type, :inclusion => { :in => WORKFLOW_TYPES, 
      :message => 'must be one of these values: ' + WORKFLOW_TYPES.join(", ")}
  validates :message_type, :inclusion => { :in => MESSAGE_TYPES, 
      :message => 'must be one of these values: ' + MESSAGE_TYPES.join(", ")}
  validates :app, :inclusion => { :in => APPS, 
      :message => 'must be one of these values: ' + APPS.join(", ")}
  validates :messagable, :presence => true

  scope :has_active_error, where('active_error = 1')
  scope :has_inactive_error, where('active_error = 0')
  scope :archive_workflow, where("workflow_type = 'archive'")
  scope :qa_workflow, where("workflow_type = 'qa'")
  scope :patron_workflow, where("workflow_type = 'patron'")
  scope :repository_workflow, where("workflow_type = 'repository'")
  scope :delivery_workflow, where("workflow_type = 'delivery'")
  scope :administrative_workflow, where("workflow_type = 'administrative'")
  scope :production_workflow, where("workflow_type = 'production'")
  scope :errors, where("message_type = 'error'")
  scope :failures, where("message_type = 'failure'")
  scope :success, where("message_type = 'success'")
end