class Integrator
  
  def self.do_it
    Glykemieschema.current( 2.6 ).glykemieschema_stap.each do |stap|
      STDOUT.puts "Stap #{stap.activiteit.omschrijving} - #{stap.omschrijving}"
    end
    
    STDOUT.flush
  end
end