module Withings
  module Api
    # Encapsulates a consumer app key/secret pair
    class ConsumerToken
      attr_accessor :key, :secret

      # @overload initialize()
      # @overload initialize(key, secret)
      #   @param [String] key OAuth token key
      #   @param [String] secret OAuth token secret
      def initialize(*arguments)
        if arguments.length == 0
        elsif arguments.length == 2
          self.key = arguments.shift
          self.secret = arguments.shift
        else
          raise ArgumentError
        end
      end

      # returns the token values as a [key, value] array
      def to_a
        [key, secret]
      end

    end

    class RequestToken < ConsumerToken

    end

    class AccessToken < ConsumerToken

    end
  end
end