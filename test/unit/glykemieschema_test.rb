require 'test_helper'

class GlykemieschemaTest < ActiveSupport::TestCase

  
  test "Stappen voor 3.6" do
    
    glykemie_values = [2.1, 3.4, 5.0, 9.0, 11.7, 13.6, 26.8 ]
    
    glykemie_values.each do |glykemie_value|
      puts "Bloedglucose waarde #{glykemie_value}:"
      Glykemieschema.current( glykemie_value ).stappen.each do |stap|
        puts "   Stap #{stap.wanneer}: #{stap.activiteit.omschrijving} - #{stap.advies}"
      end
      
      puts ""
    end
    
    thecount = Glykemieschema.current( 8 ).glykemieschema_stap.count
    
    assert thecount == 0, "Expected zero steps for normal glucose level, not #{thecount}"
  end
end
