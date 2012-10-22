require 'test_helper'

class DagboekTest < ActiveSupport::TestCase
  test "wachtrij" do
    nr = Insuline.find_by_afkorting('NR')
    
    queue = Dagboek.voor
    
    puts "#{queue.length} activiteiten wachten op uitvoering"
    
    nu = DateTime.now.strftime('%H:%M')
    
    queue.each do |act|
      puts "  #{act.status} #{act.tijdstip}: #{act.activiteit.omschrijving}"
      
      if act.tijdstip <= nu
        act.aantal_kh = act.dagschema.aantal_kh if act.dagschema
        
        if act.activiteit.neem_insuline>0
          act.eenheden_insuline = 15
          act.insuline = nr
        end
        act.glykemie = 9.9
        
        act.gedaan! 
      end
    end

    puts "--"
    
    Dagboek.voeg_glykemie_schema_toe Glykemieschema.current( 15 ).stappen

    queue = Dagboek.voor
    
    puts "\nNa BG15 om #{nu}, wachten nog #{queue.length} activiteiten op uitvoering"
    
    queue.each do |act|
      puts "   #{act.status} #{act.tijdstip}: #{act.activiteit.omschrijving}"
    end

    puts "--"


    puts "\nExtra activiteiten"
    
    Activiteit.extras.each do |act|
      todo = ""
      todo += 'prikken' if act.meet_bg>0
      todo += ' spuiten' if act.neem_insuline>0
      todo += ' eten' if act.neem_kh>0
      todo += ' ketonen' if act.meet_ketonen>0
      
      puts "   #{act.omschrijving} #{todo}"
    end

    puts "--"


    puts "\nVoor het ziekenhuis"
    
    Dagboek.log.each do |act|
      
      todo = ""
      todo += "BG=#{act.glykemie}" if act.activiteit.meet_bg>0
      todo += " #{act.eenheden_insuline}#{act.insuline.afkorting}"  if act.activiteit.neem_insuline>0
      todo += " #{act.aantal_kh}g KH" if act.activiteit.neem_kh>0
      todo += " #{act.hoeveelheid_ketonen} ketonen" if act.activiteit.meet_ketonen>0
      
      puts "   #{act.status} #{act.tijdstip}: #{act.activiteit.omschrijving} #{todo}"
      
    end
    
    puts "---"
        
    assert true
   end
end
