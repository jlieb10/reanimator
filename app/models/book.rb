class Book < ActiveRecord::Base


  serialize :titles         , Array
  serialize :authors        , Array
  serialize :descriptions   , Array
  #============================#
  serialize :links          , Hash
end
