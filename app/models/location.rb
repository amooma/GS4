class Location < ActiveRecord::Base
  set_table_name "location"
before_validation {
    raise ActiveRecord::ReadOnlyRecord
}

def before_destroy
    raise ActiveRecord::ReadOnlyRecord
end
end
