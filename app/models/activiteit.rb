class Activiteit < ActiveRecord::Base
  
  def self.extras
    self.where('mag_extra > 0').order('mag_extra')
  end
end
