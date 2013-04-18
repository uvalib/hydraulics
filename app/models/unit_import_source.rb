class UnitImportSource < ActiveRecord::Base
  belongs_to :unit

  validates :unit_id, :presence => true
  validates :unit, :presence => {
    :message => "association with this Unit is no longer valid because the Unit object no longer exists."
  }
end