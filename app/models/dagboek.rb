class Dagboek < ActiveRecord::Base
  belongs_to :insuline
  belongs_to :activiteit
  belongs_to :glykemieschema_stap
  belongs_to :dagschema
  
  
  def self.add_schema_entries( day = DateTime.now )
    
    schema = Dagschema.current( day )
    
    schema.each do |entry|
      Dagboek.create :datum => day.to_date,
        :tijdstip => entry.tijdstip,

        :activiteit => entry.activiteit,
        :dagschema => entry,
      
      
        :aantal_kh => entry.aantal_kh,
        :eenheden_insuline => entry.eenheden_insuline,
        :insuline => entry.insuline
    end

 
  end
  
  def self.voor( day = DateTime.now )
    
    nr_of_entries = self.where('datum = ?', day.to_date ).count
    
    if nr_of_entries < 1
      self.add_schema_entries( day )
    end
    
    self.where("datum = ? ", day.to_date ).order('tijdstip')
    
  end
  
  def self.log( day = DateTime.now )
    
    self.where("datum = ? AND status = 'F'", day.to_date ).order('tijdstip')
    
  end
  
  def self.voeg_glykemie_schema_toe( stappen, day = DateTime.now )
      #t.string :advies
      #t.integer :wachttijd, :default => 0
      #t.string :wanneer, :limit => 1
      #
      #t.references :activiteit
      #t.integer :aantal_kh
      #t.decimal :eenheden_insuline, :precision => 4, :scale => 1
      #t.references :insuline

      tijdstip = (day.to_datetime + ((60-day.to_time.sec).seconds))
            
      stappen.each do |stap|
        entry = {
          :datum => day.to_date,
          :tijdstip => (tijdstip.to_time + stap.wachttijd.minutes).strftime('%H:%M'),
          :activiteit => stap.activiteit,
          :glykemieschema_stap => stap
        }
        
        if stap.activiteit.neem_kh
          entry[:aantal_kh] = stap.aantal_kh
        end
        
        if stap.activiteit.neem_insuline
          entry[:eenheden_insuline] = stap.eenheden_insuline
          entry[:insuline] = stap.insuline
        end
        
        Dagboek.create entry       
        
      end
    
  end



  def uitgevoerd!
    self.status = 'F'
    self.save
    if self.activiteit.meet_bg > 0
      advies = Glykemieschema.current( self.glykemie )
      Dagboek.voeg_glykemie_schema_toe advies.stappen unless advies.nil?
    end
  end
  
  def overgeslagen!
    self.status = 'X'
    self.save    
  end

  def wacht!
    attrs = {}
    advies = nil
    if self.dagschema
        attrs[:tijdstip] = self.dagschema.tijdstip,

        advies = self.dagschema
     elsif self.glykemieschema_stap

        advies = self.glykemieschema_stap
        
    end
    
    unless advies.nil?
        if self.activiteit.neem_kh
          attrs[:aantal_kh] = advies.aantal_kh
        end
        
        if self.activiteit.neem_insuline
          attrs[:eenheden_insuline] = advies.eenheden_insuline
          attrs[:insuline] = advies.insuline
        end
     end

    self.update_attributes( attrs )
    self.status = 'Q'
    self.save    
  end
  
  def wacht?
    self.status == 'Q'
  end
  
  def overgeslagen?
    self.status == 'X'    
  end
  
  def uitgevoerd?
    self.status == 'F'    
  end
  

end
