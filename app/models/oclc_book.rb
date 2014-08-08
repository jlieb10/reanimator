class OclcBook < ActiveRecord::Base
  serialize :descriptions, Array
  serialize :titles      , Array
end
