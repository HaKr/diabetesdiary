class Dagschema < ActiveRecord::Base
  belongs_to :activiteit
  belongs_to :insuline
  belongs_to :dagschema_geldigheid      


  def self.current( fordate = DateTime.now.to_date )
    
    DagschemaGeldigheid.order('start_datum DESC').where('start_datum < ?', fordate ).first.dagschema
  end
  
  
end
