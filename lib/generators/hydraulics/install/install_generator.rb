module Hydraulics
	module Generators
		class InstallGenerator < Rails::Generators::Base
			desc "Installs Hydraulics and generates the necessary migrations."

			include Rails::Generators::Migration

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end
    end
  end
end