module Withings
  module Api
    class Error < StandardError

    end

    class InvalidFormat < Error

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