class CreateMasterTables < ActiveRecord::Migration
  def change
    
    create_table :insuline do |t|
      t.string :marktnaam, :null => false, :limit => 40
      t.string :afkorting, :null => false, :limit => 3
      
      t.timestamps  
    end
    
    nr = Insuline.create :marktnaam => 'NovoRapid', :afkorting => 'NR'
    lt = Insuline.create :marktnaam => 'Lantus', :afkorting => 'LT'
    
    
    create_table :activiteit do |t|
      t.string :omschrijving, :limit => 15, :null => false
      t.integer :neem_kh
      t.integer :neem_insuline
      t.integer :meet_bg
      t.integer :meet_ketonen
      t.integer :mag_extra
      
      t.timestamps
    end
    
    ontbijt     = Activiteit.create :mag_extra => 0, :omschrijving => 'Ontbijt',                 :neem_kh => 1, :neem_insuline => 1, :meet_bg => 1, :meet_ketonen => 0
    tienuurtje  = Activiteit.create :mag_extra => 0, :omschrijving => 'Tienuurtje',              :neem_kh => 1, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    lunch       = Activiteit.create :mag_extra => 0, :omschrijving => 'Lunch',                   :neem_kh => 1, :neem_insuline => 1, :meet_bg => 1, :meet_ketonen => 0
    drieuurtje  = Activiteit.create :mag_extra => 0, :omschrijving => 'Drieuurtje',              :neem_kh => 1, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    diner       = Activiteit.create :mag_extra => 0, :omschrijving => 'Avondeten',               :neem_kh => 1, :neem_insuline => 1, :meet_bg => 1, :meet_ketonen => 0
    avondfruit  = Activiteit.create :mag_extra => 0, :omschrijving => 'Avond fruit of variatie', :neem_kh => 1, :neem_insuline => 0, :meet_bg => 1, :meet_ketonen => 0
    slapen      = Activiteit.create :mag_extra => 0, :omschrijving => 'Slapen',                  :neem_kh => 0, :neem_insuline => 1, :meet_bg => 1, :meet_ketonen => 0
    sporten     = Activiteit.create :mag_extra => 2, :omschrijving => 'Sporten',                 :neem_kh => 1, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    extra_bg    = Activiteit.create :mag_extra => 1, :omschrijving => 'Extra prikken',           :neem_kh => 0, :neem_insuline => 0, :meet_bg => 1, :meet_ketonen => 0
    bijspuiten  = Activiteit.create :mag_extra => 4, :omschrijving => 'Bijspuiten',              :neem_kh => 0, :neem_insuline => 1, :meet_bg => 0, :meet_ketonen => 0
    extra_suiker= Activiteit.create :mag_extra => 0, :omschrijving => 'Extra suiker',            :neem_kh => 1, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    extra_kh    = Activiteit.create :mag_extra => 3, :omschrijving => 'Extra KH',                :neem_kh => 1, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    bewegen     = Activiteit.create :mag_extra => 0, :omschrijving => 'Bewegen',                 :neem_kh => 0, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    drinken     = Activiteit.create :mag_extra => 0, :omschrijving => 'Extra drinken zonder KH', :neem_kh => 0, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 0
    ketonen     = Activiteit.create :mag_extra => 5, :omschrijving => 'Ketonen meten',           :neem_kh => 0, :neem_insuline => 0, :meet_bg => 0, :meet_ketonen => 1
    
    create_table :dagboek do |t|
      t.date :datum, :null => false
      t.string :tijdstip, :null => false, :limit => 5

      t.references :activiteit
      t.references :dagschema, :null => true
      t.references :glykemieschema_stap, :null => true
      
      # Q = queue, X = cancelled, F = executed 
      t.string :status, :limit => 1, :null => false, :default => 'Q'
      
      t.integer :aantal_kh, :default => 0
      t.integer :hoeveelheid_ketonen, :default => 0, :precision => 3, :scale => 1
      t.decimal :eenheden_insuline, :default => 0, :precision => 4, :scale => 1
      t.references :insuline
      t.decimal :glykemie, :default => 0, :precision => 3, :scale => 1
      t.text :notities, :limit => 250 

      t.timestamps
    end
    
    create_table :dagschema_geldigheid do |t|
      t.date :start_datum

      t.timestamps
    end
    
    huidig_dagschema = DagschemaGeldigheid.create :start_datum => Date.civil( 2012, 07,1 )
    
    create_table :dagschema do |t|
      t.string :tijdstip, :null => false, :limit=>5
      t.references :activiteit
      t.integer :aantal_kh
      t.decimal :eenheden_insuline, :precision => 4, :scale => 1
      t.references :insuline
      t.references :dagschema_geldigheid
      
      t.timestamps
    end
    
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '07:30', :activiteit => ontbijt,    :aantal_kh => 45, :eenheden_insuline => 5, :insuline => nr
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '10:00', :activiteit => tienuurtje, :aantal_kh => 25
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '12:30', :activiteit => lunch,      :aantal_kh => 75, :eenheden_insuline => 4, :insuline => nr
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '15:00', :activiteit => drieuurtje, :aantal_kh => 25
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '18:00', :activiteit => diner,      :aantal_kh => 40, :eenheden_insuline => 3, :insuline => nr
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '20:00', :activiteit => avondfruit, :aantal_kh => 16
    Dagschema.create :dagschema_geldigheid => huidig_dagschema, :tijdstip => '20:30', :activiteit => slapen,                       :eenheden_insuline => 5, :insuline => lt
    
    
    create_table :glykemieschema_geldigheid do |t|
      t.date :start_datum

      t.timestamps
    end

    huidig_glykemieschema = GlykemieschemaGeldigheid.create :start_datum => Date.civil( 2012, 07,1 )

    create_table :glykemieschema do |t|
      t.references :glykemieschema_geldigheid
      
      t.decimal :glykemie_tot, :default => 0, :precision => 3, :scale => 1

      t.timestamps
    end
    
    hypo_ernstig    = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot =>  2.0 
    hypo_erg_laag   = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot =>  3.0 
    hypo_laag       = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot =>  4.0 
    normaal_preventie=Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot =>  7.0
    normaal         = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 10.0
    hyper_licht     = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 12.0
    hyper_zwaarder  = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 15.0
    hyper_zwaar     = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 18.0
    hyper_ernstig   = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 20.0
    hyper_ernstiger = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 22.0
    hyper_gevaarlijk= Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 25.0
    hyper_extreem   = Glykemieschema.create :glykemieschema_geldigheid => huidig_glykemieschema, :glykemie_tot => 99.0
    

    create_table :glykemieschema_stap do |t|
      t.references :glykemieschema
      
      t.string :advies
      t.integer :wachttijd, :default => 0
      t.string :wanneer, :limit => 1
      
      t.references :activiteit
      t.integer :aantal_kh
      t.decimal :eenheden_insuline, :precision => 4, :scale => 1
      t.references :insuline
      
      t.timestamps
    end
    
    
    GlykemieschemaStap.create :glykemieschema => hypo_ernstig,      :wanneer => 'H', :activiteit => extra_suiker, :aantal_kh => 12,                           :advies => 'Neem 4 hartjes of drink 12g limo'
    GlykemieschemaStap.create :glykemieschema => hypo_ernstig,      :wanneer => 'D', :activiteit => extra_kh,     :aantal_kh => 15, :wachttijd => 10, :advies => 'eet 1 hartige boterham'
    GlykemieschemaStap.create :glykemieschema => hypo_ernstig,      :wanneer => 'N', :activiteit => extra_kh,     :aantal_kh => 20, :wachttijd => 10, :advies => 'Halve boterham hartig en halve zoet'
    GlykemieschemaStap.create :glykemieschema => hypo_ernstig,      :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 20
    
    GlykemieschemaStap.create :glykemieschema => hypo_erg_laag,     :wanneer => 'H', :activiteit => extra_suiker, :aantal_kh => 12,                           :advies => 'Neem 4 hartjes of drink 12g limo'
    GlykemieschemaStap.create :glykemieschema => hypo_erg_laag,     :wanneer => 'D', :activiteit => extra_kh,     :aantal_kh => 15, :wachttijd => 10, :advies => 'eet 1 hartige boterham'
    GlykemieschemaStap.create :glykemieschema => hypo_erg_laag,     :wanneer => 'N', :activiteit => extra_kh,     :aantal_kh => 20, :wachttijd => 10, :advies => 'Halve boterham hartig en halve zoet'
    GlykemieschemaStap.create :glykemieschema => hypo_erg_laag,     :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 60
    
    GlykemieschemaStap.create :glykemieschema => hypo_laag,         :wanneer => 'H', :activiteit => extra_suiker, :aantal_kh =>  6,                           :advies => 'Neem 2 hartjes of drink 12g limo'
    GlykemieschemaStap.create :glykemieschema => hypo_laag,         :wanneer => 'D', :activiteit => extra_kh,     :aantal_kh => 15, :wachttijd => 10, :advies => 'eet 1 hartige boterham'       
    GlykemieschemaStap.create :glykemieschema => hypo_laag,         :wanneer => 'N', :activiteit => extra_kh,     :aantal_kh => 20, :wachttijd => 10, :advies => 'Halve boterham hartig en halve zoet'
    GlykemieschemaStap.create :glykemieschema => hypo_laag,         :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 60
    
    GlykemieschemaStap.create :glykemieschema => normaal_preventie, :wanneer => 'N', :activiteit => extra_kh,     :aantal_kh => 10,                           :advies => 'eet 1/2 hartige boterham'

    GlykemieschemaStap.create :glykemieschema => hyper_licht,       :wanneer => 'H', :activiteit => drinken
    GlykemieschemaStap.create :glykemieschema => hyper_licht,       :wanneer => 'H', :activiteit => bewegen

    GlykemieschemaStap.create :glykemieschema => hyper_zwaarder,    :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 0.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_zwaarder,    :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_zwaarder,    :wanneer => 'H', :activiteit => drinken
    GlykemieschemaStap.create :glykemieschema => hyper_zwaarder,    :wanneer => 'H', :activiteit => bewegen

    GlykemieschemaStap.create :glykemieschema => hyper_zwaar,       :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 1.0, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_zwaar,       :wanneer => 'N', :activiteit => bijspuiten,   :eenheden_insuline => 0.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_zwaar,       :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_zwaar,       :wanneer => 'H', :activiteit => drinken
    GlykemieschemaStap.create :glykemieschema => hyper_zwaar,       :wanneer => 'H', :activiteit => bewegen

    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'H', :activiteit => ketonen
    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 1.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'N', :activiteit => bijspuiten,   :eenheden_insuline => 1.0, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'H', :activiteit => drinken
    GlykemieschemaStap.create :glykemieschema => hyper_ernstig,     :wanneer => 'H', :activiteit => bewegen,                                                  :advies => 'Indien geen ketonen'

    GlykemieschemaStap.create :glykemieschema => hyper_ernstiger,   :wanneer => 'H', :activiteit => ketonen
    GlykemieschemaStap.create :glykemieschema => hyper_ernstiger,   :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 2.0, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_ernstiger,   :wanneer => 'N', :activiteit => bijspuiten,   :eenheden_insuline => 1.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_ernstiger,   :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_ernstiger,   :wanneer => 'H', :activiteit => drinken

    GlykemieschemaStap.create :glykemieschema => hyper_gevaarlijk,  :wanneer => 'H', :activiteit => ketonen
    GlykemieschemaStap.create :glykemieschema => hyper_gevaarlijk,  :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 2.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_gevaarlijk,  :wanneer => 'N', :activiteit => bijspuiten,   :eenheden_insuline => 2.0, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_gevaarlijk,  :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_gevaarlijk,  :wanneer => 'H', :activiteit => drinken

    GlykemieschemaStap.create :glykemieschema => hyper_extreem,     :wanneer => 'H', :activiteit => ketonen
    GlykemieschemaStap.create :glykemieschema => hyper_extreem,     :wanneer => 'D', :activiteit => bijspuiten,   :eenheden_insuline => 3.0, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_extreem,     :wanneer => 'N', :activiteit => bijspuiten,   :eenheden_insuline => 2.5, :insuline => nr
    GlykemieschemaStap.create :glykemieschema => hyper_extreem,     :wanneer => 'H', :activiteit => extra_bg,                       :wachttijd => 120
    GlykemieschemaStap.create :glykemieschema => hyper_extreem,     :wanneer => 'H', :activiteit => drinken

#raise "Ellende!"
  end


end
