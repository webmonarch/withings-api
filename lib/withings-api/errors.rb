module Withings
  module Api
    class Error < StandardError

    end

    class ApiError < Error
      attr_reader :code

      def initialize(code)
        super(code)

        @code = code
      end
    end

    class InvalidFormat < Error

    end

    class TransportError < Error

    end

    class HttpNotSuccessError < Error
      attr_accessor :code, :body

      def initialize(code, body = "")
        super(code)

        @code = code
        @body = body
      end
    end

  end
end