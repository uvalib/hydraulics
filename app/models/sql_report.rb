class SqlReport < ActiveRecord::Base
  validates :name, :sql, :presence => true
  validates :name, :uniqueness => true
end