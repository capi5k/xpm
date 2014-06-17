module XPM

  module Depmanager 
    
    class Abstract
    
      def install(package=nil)
        raise MethodUnavailableError
      end

      def link(name=nil)
        raise MethodUnavailableError
      end

      def cacheclean
        raise MethodUnavailableError
      end

      def cachelist
        raise MethodUnavailableError
      end

      def export
        raise MethodUnavailableError
      end

    end

  end

end

