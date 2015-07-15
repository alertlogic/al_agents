class Chef
  class Recipe
    # preparing the Egress URL
    class Egress
      require 'uri'
      attr_accessor :url

      def initialize(node)
        @url = node['al_agent']['agent']['egress_url']
      end

      def host
        parsed_url.host || 'vaporator.alertlogic.com'
      end
      alias_method :sensor_host, :host

      def port
        parsed_url.port || 443
      end
      alias_method :sensor_port, :port

      private

      def schemed_url
        schemed = url
        schemed = "http://#{url}" unless url =~ %r{^http:\/\/}i || url =~ %r{^https:\/\/}i
        schemed
      end

      def parsed_url
        URI.parse(schemed_url)
      end
    end
  end
end
