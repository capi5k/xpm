module XPM

  class Configuration
  
    attr_writer :depmanager

    def depmanager
      @depmanager || XPM::Depmanager::Bower
    end

  end

end

