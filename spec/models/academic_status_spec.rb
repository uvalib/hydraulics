require 'spec_helper'

describe AcademicStatus do
   it { should validate_presence_of :name }
   it { should have_many(:customers) }
   it { should have_many(:orders).through(:customers) }
   it { should have_many(:requests).through(:customers) }
   it { should have_many(:units).through(:orders) }
   it { should have_many(:master_files).through(:units) }

end
