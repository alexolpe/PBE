require 'gtk3' #per utilitzar els mètodes que faciliten el disseny de la finestra
require_relative 'puzzle1' #per utilitzar el mètode escriure(str)

class GtkLcd

  def initialize #constructor
    @rf=Rfid.new
    @window=Gtk::Window.new("Puzzle 2")
  end
  
  def montarVentana
    #Disseny de la finestra
    @window.set_size_request(400, 100)
    @window.set_border_width(10)
    
    #Els widgets s'organitzaran a través d'un Grid
    caja = Gtk::Grid.new
    caja.set_row_homogeneous(true)
    caja.set_column_homogeneous(true)

    #Creació i disseny del TextView on l'usuari introduirà el text
    display = Gtk::TextView.new
    display.set_editable(true)
    display.set_cursor_visible(true)
    display.show
    caja.attach(display, 0,0,1,3) #S'afageix el widget al Grid

    #Creació del botó
    button = Gtk::Button.new(:label => "Display")
    button.set_size_request(380, 32)
    button.signal_connect "clicked" do |_widget|
      @rf.escriure(self.coger_mensaje(display.buffer)) #Al clicar el botó s'accedeix al buffer del TextView, s'agafa el text i es mostra al display LCD
    end    
    
    #Disseny en CSS del botó
    css_provider = Gtk::CssProvider.new
    style_provider = Gtk::StyleProvider::PRIORITY_USER

    css_provider.load(data: "button {  background-image: -gtk-gradient (radial,
                                   center center, 0,
                                   center center, 1,
                                   from(yellow), to(red));}\
                            button:hover {background-image: -gtk-gradient (radial,
                                   center center, 0,
                                   center center, 1,
                                   from(yellow), to(cyan));}\
                            button:active {background-image: -gtk-gradient (radial,
                                   center center, 0,
                                   center center, 1,
                                   from(yellow), to(green));}") 
                                                         
    button.style_context.add_provider(css_provider, style_provider)
    
    caja.attach(button, 0, 5,1,1) #S'afageix el widget al Grid

    @window.add(caja) #S'afageix el Grid a la finestra
    @window.signal_connect("delete-event") { |_widget| Gtk.main_quit } #Un cop es tanca la finestra, s'acaba l'execució del programa
    @window.show_all
    
  end
  
  def coger_mensaje(buf)
    #Mitjançant 2 iteradors, agafa el missatge del buffer del TextView i el retorna en format string
    iter1=buf.start_iter
    iter2=buf.end_iter
    missatge=buf.get_text(iter1,iter2,false)
    return missatge
    
  end
  
end

if __FILE__ == $0
	rf=GtkLcd.new
    rf.montarVentana
    Gtk.main
end

