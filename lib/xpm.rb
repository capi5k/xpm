module XPM

  class << self

    attr_accessor :config

    def config
      @@config ||= Configuration.new
    end

  end

end

require 'xpm/all'
