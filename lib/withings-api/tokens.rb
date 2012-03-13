module Withings
  module Api
    # Encapsulates a consumer app key/secret pair
    class ConsumerToken
      attr_accessor :key, :secret

      # Multiple variations
      #
      # - #initialize()
      # - #initialize(key, secret)
      def initialize(*arguments)
        if arguments.length == 0
        elsif arguments.length == 2
          self.key = arguments.shift
          self.secret = arguments.shift
        else
          raise ArgumentError
        end
      end

    end

    class RequestToken < ConsumerToken

    end

    class AccessToken < ConsumerToken

    end
  end
end