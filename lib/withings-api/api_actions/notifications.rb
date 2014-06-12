require 'withings-api/results/notifications/notify_result'

module Notifications
  # notify / subscribe API call.  Full details @ http://oauth.withings.com/api#notify-subscribe
  #
  # @overload notify(consumer_token, access_token, api_parameters, options = {})
  #   @param [ConsumerToken]
  #   @param [AccessToken]
  #   @param [Hash] api_parameters Parameters passed to the Withings API.
  #   @option api_parameters [String] :user_id  The userid of the target user. This value is obtained when your user links his/her Withings account with your application.
  #   @option api_parameters [String] :callback_url The URL the API notification service will call WBS API notification are merely HTTP POST requests to this URL
  #   @option api_parameters [String] :comment The comment string is used as a description displayed to the user when presenting him your notification setup
  #   @option api_parameters [String] :appli This field specifies the device or measure type for which the notification is to be activated
  # @return [MeasureGetmeasResults]
  # @raise [ApiError, Error]
  def notify(*arguments)
    arguments = parse_arguments arguments

    # extract arguements
    consumer_token = consumer_token(arguments.delete(:consumer_token))
    access_token = access_token(arguments.delete(:access_token))
    parameters = arguments.delete(:api_parameters)

    # parse parameters
    parsed_parameters = subscibe_params(parameters)

    http_response = api_http_request!(consumer_token, access_token, "/notify?action=subscribe", {:parameters => parsed_parameters})
    api_response = Withings::Api::ApiResponse.create!(http_response, Withings::Api::NotifyResult)
    api_response.body
  end

  protected

  def subscibe_params(args)
    {
      userid: args[:user_id],
      callbackurl: args[:callback_url],
      comment: args[:comment],
      appli: args[:type]
    }
  end
end
