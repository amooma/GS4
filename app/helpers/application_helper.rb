module ApplicationHelper

  # Renders html for given menu array 
  # OPTIMIZE: @stefan
  def menu_html( menu, params_controller=nil, indent=0 )
    out = []
    out << ("\t"*indent) << "<ul>\n"
    menu.each { |item|
      out << ("\t"*indent) << "\t<li><a"
      if item[:url] != nil
        out << ' href="' << h( item[:url] ) << '"'
      end
      
      element_classes = []
      element_classes << 'navcur' if menu_item_current?( item, params_controller )
      out << ' class="' << element_classes.join(' ') << '"' if element_classes.length > 0
      
      out << '>' << h( item[:text] ) << '</a>'
      if item[:sub] != nil
        out << "\n" << menu_html( item[:sub], params_controller, indent+2 )
        out << ("\t"*indent) << "\t"
      end
      out << "</li>\n"
    }
    out << ("\t"*indent) << "</ul>\n"
    return out.join
  end
  
  # Emulates current_page? recursive
  # OPTIMIZE: @stefan
  def menu_item_current?( menu_item, params_controller )
    return false if params_controller == nil
    current_url = params_controller.to_s.dup
    current_url = '/' + current_url if ! current_url.start_with?('/')
    
    if menu_item[:url]
      if menu_item[:url].gsub(/\/$/,'') == current_url
        return true
      end
    end
    if menu_item[:sub]
      menu_item[:sub].each { |item|
        return true if menu_item_current?( item, params_controller )
      }
    end
    return false
  end
  
end
