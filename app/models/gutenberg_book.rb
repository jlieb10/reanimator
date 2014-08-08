class GutenbergBook < ActiveRecord::Base


  serialize :titles         , Array
  serialize :authors        , Array
  #==============================#
  serialize :links          , Hash

  
end
