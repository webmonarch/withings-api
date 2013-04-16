require "withings-api/results/measure_getmeas_results"
require "withings-api/results/user_getbyuserid_results"

module Withings
  module Api

    # Contains a method corresponding to each API action provided by Withings.
    #
    # For a complete list of available API actions, see @ http://www.withings.com/en/api/wbsapiv2
    module ApiActions
      include OAuthBase
      include SinglyBase

      
      # user/self API call via Singly.  Full details @ http://www.withings.com/en/api#user-getbyuserid and https://singly.com/docs/withings
      #
      # @overload singly_user_self(options = {})
      #   @option api_parameters [String] :access_token  The access_token from Singly
      #   @param [Hash] options
      #
      # @return [UserSelfResults]
      # @raise [ApiError, Error]
      
      def singly_user_self(params) 
        access_token = access_token(params[:access_token])
        http_response = singly_request!(access_token, "/self")
        
        api_response = Withings::Api::SinglyApiResponse.create!(http_response, Withings::Api::UserSelfResults)
        raise Withings::Api::ApiError.new(api_response.code) unless api_response.success?
        api_response.body
      end
      
      
      # measure/getmeas API call.  Full details @ www.withings.com/en/api/wbsapiv2#getmeas
      #
      # @overload measure_getmeas(consumer_token, access_token, api_parameters, options = {})
      #   @param [ConsumerToken]
      #   @param [AccessToken]
      #   @param [Hash] api_parameters Parameters passed to the Withings API.
      #   @option api_parameters [String] :user_id  The userid of the target user. This value is obtained when your user links his/her Withings account with your application.
      #   @option api_parameters [Time, Number] :start_date Will prevent retrieval of values dated prior to the supplied parameter. (number in EPOCH format)
      #   @option api_parameters [Time, Number] :end_date Will prevent retrieval of values dated after the supplied parameter. (number in EPOCH format)
      #   @option api_parameters [DeviceType] :device_type Restrict the returned data to a specific devices only.  Only supports {DeviceType::BODY_SCALE} and {DeviceType::USER} (per Withings)
      #   @option api_parameters [MeasurementType] :measurement_type Retstrict the returned data to a specific type only.  Only supports {MeasurementType::WEIGHT} and {MeasurementType::HEIGHT} (per Withings)
      #   @option api_parameters [Time, Number] :last_update Only entries which have been added or modified since the specified time are retrieved. (number in EPOCH format)
      #   @option api_parameters [CategoryType] :category_type Restrict the returned data to a specific category.
      #   @option api_parameters [Fixnum] :limit limit the number of measure groups returned in the result.
      #   @option api_parameters [Fixnum] :offset skip the 'offset' most recent measure group records of the result set.
      #   @param [Hash] options
      #
      # @return [MeasureGetmeasResults]
      # @raise [ApiError, Error]
      def measure_getmeas(*arguments)
        arguments = parse_arguments arguments

        # extract arguements
        consumer_token = consumer_token(arguments.delete(:consumer_token))
        access_token = access_token(arguments.delete(:access_token))
        parameters = arguments.delete(:api_parameters)

        # parse parameters
        parsed_parameters = parse_measure_getmeas_parameters parameters

        http_response = api_http_request!(consumer_token, access_token, "/measure?action=getmeas", {:parameters => parsed_parameters})

        api_response = Withings::Api::ApiResponse.create!(http_response, Withings::Api::MeasureGetmeasResults)
        raise Withings::Api::ApiError.new(api_response.code) unless api_response.success?
        api_response.body
      end

      private

      def parse_arguments(args)
        parsed_args = {}

        index = 0
        args[index].kind_of?(ConsumerToken) ?
            parsed_args[:consumer_token] = args[index] : raise(ArgumentError, :consumer_token)

        index += 1
        args[index].kind_of?(AccessToken) ?
            parsed_args[:access_token] = args[index] : raise(ArgumentError, :access_token)

        index += 1
        args[index].kind_of?(Hash) ?
            parsed_args[:api_parameters] = args[index] : raise(ArgumentError, :api_parameters)

        parsed_args
      end

      def parse_measure_getmeas_parameters(parameters)
        parsed_parameters = {}

        param = :user_id
        if parameters.key? param
          parsed_parameters[:userid] = parameters.delete(param).to_s
        end

        param = :start_date
        if parameters.key? param
          parsed_parameters[:startdate] = parameters.delete(param).to_i
        end

        param = :end_date
        if parameters.key? param
          parsed_parameters[:enddate] = parameters.delete(param).to_i
        end

        param = :device_type
        if parameters.key?(param) && parameters[param].kind_of?(Withings::Api::TypeBase)
          parsed_parameters[:devtype] = parameters.delete(param).to_query_param_value
        end

        param = :measurement_type
        if parameters.key?(param) && parameters[param].kind_of?(Withings::Api::TypeBase)
          parsed_parameters[:meastype] = parameters.delete(param).to_query_param_value
        end

        param = :last_update
        if parameters.key?(param)
          parsed_parameters[:lastupdate] = parameters.delete(param).to_i
        end

        param = :category_type
        if parameters.key?(param) && parameters[param].kind_of?(Withings::Api::TypeBase)
          parsed_parameters[:category] = parameters.delete(param).to_query_param_value
        end

        param = :limit
        if parameters.key? param
          parsed_parameters[:limit] = parameters.delete(param).to_i
        end

        param = :offset
        if parameters.key? param
          parsed_parameters[:offset] = parameters.delete(param).to_i
        end

        if ! parameters.empty?
          raise ArgumentError, parameters.keys.inspect
        end

        parsed_parameters
      end

      def consumer_token(o)
        @consumer_token || o || raise(StandardError, "No consumer token")
      end

      def access_token(o)
        @access_token || o || raise(StandardError, "No access token")
      end
    end
  end
end