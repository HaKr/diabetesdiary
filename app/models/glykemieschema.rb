class Glykemieschema < ActiveRecord::Base
  belongs_to :glykemieschema_geldigheid
  
  has_many :glykemieschema_stap
  
  def self.current( glykemie, fordate = DateTime.now )
    
    GlykemieschemaGeldigheid.order('start_datum DESC').where('start_datum < ?', fordate.to_date ).first.glykemieschema.order('glykemie_tot').where('glykemie_tot > ?', glykemie).first
  end
  
  def stappen( fordate = DateTime.now )
    excl = if fordate.to_time.hour >= 20 
      'D'
    else
      'N'
    end  
      

    self.glykemieschema_stap.where('wanneer <> ?', excl)
  end  

end
