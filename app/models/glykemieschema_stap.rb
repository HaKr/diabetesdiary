class GlykemieschemaStap < ActiveRecord::Base
  belongs_to :glykemieschema
  
  belongs_to :activiteit
  belongs_to :insuline
end
