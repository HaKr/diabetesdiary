module DagboekHelper
  
  def slider(value, label, id, options={})
    idedit = id + "_text"
    idlbl = id + "_label"
    
    options = options.stringify_keys
    if range = options.delete("in") || options.delete("within")
      options.update("min" => range.min, "max" => range.max)
    end
    
    html = capture {label_tag idedit, label, :id=>idlbl}
    html << capture {range_field_tag idedit, value, options.merge(:style=>'border: 0;')} 
    html << capture { content_tag :div, '', :id=>id, :class=>'slider' }
    
    js =  "$( '##{id}' ).slider({"
    js << '  range: "min",'
    js << "  min:  #{options['min']},"  if options.has_key?('min')
    js << "  max:  #{options['max']},"  if options.has_key?('max')
    js << "  step: #{options['step']}," if options.has_key?('step')
    js << "  value: #{value},"
    js << "  slide: function( event, ui ) {"
    js << "        $( '#' + event.target.id + '_text' ).val( ui.value  );"
    js << "      }"
    js << "    });"
    js << ""

    #html << capture {javascript_tag( js ) }
    
    html
  end
end
