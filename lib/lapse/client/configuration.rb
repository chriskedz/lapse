module Lapse
  class Client
    # Client methods for working with configuration.
    module Configuration
      # Get the configuration from the API.
      #
      # @return [Hashie::Mash] A hash of configuration data.
      # @example
      #   Totter.configuration
      def configuration
        get('configuration').body
      end

      # Get the featured timelines and users for Explore.
      #
      # @return [Hashie::Mash] A hash of timelines and users data.
      # @example
      #   Totter.explore
      def explore
        get('explore').body
      end
    end
  end
end
