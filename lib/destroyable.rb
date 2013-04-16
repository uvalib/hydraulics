module Destroyable
  def destroyable?
    self.class.reflect_on_all_associations.all? do |assoc|
      assoc.options[:dependent] != :restrict || (assoc.macro == :has_one && self.send(assoc.name).nil?) || (assoc.macro == :has_many && self.send(assoc.name).empty?)
    end
  end
end

ActiveRecord::Base.send(:include, Destroyable)
