class HydraulicsGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration

  desc "Installs Hydraulics and generates the necessary migrations."

  def self.source_root
    File.expand_path("../templates", __FILE__)
  end  

  def self.next_migration_number(dirname)
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def create_migrations
    Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
      name = File.basename(filepath)
      migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
      sleep 1
    end
  end
end
