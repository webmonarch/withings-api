#
# Example script showing common usage of withings-api
#
# This script shows how the steps to gain an access token to access user's data
# in Withings.
#
# see {file:README.rdoc#OAuth_Authorization} for detailed explaination about these steps
#

require 'withings-api'

include Withings::Api

#
# Create a ConsumerToken authenticating the reques to your application
#
# These credentials are test credentials for DEMONSTRATION ONLY...you should
# create credentials for you app @ https://oauth.withings.com/partner/add
#

consumer_token = ConsumerToken.new("08943c64c3ccfe86d5edb40c8db6ddbbc43b6f58779c77d2b02454284db7ec",
                                   "85949316f07fc41346be145fe8fbc18b73f954f280be958033571720510")
#
# Issue request to Withings to gain a request token
#

puts "Requesting a request token from Withings..."

request_token_response = Withings::Api.create_request_token(consumer_token, "https://raw.github.com/webmonarch/withings-api/master/examples/callback_landing.txt")
request_token = request_token_response.request_token

#
# Redirect to Withings to authorize access to user data
#
# NOTE: You need a Withings account to continue!
#

puts "Retrieved request token!!!"
puts
puts "To authorize the request token"
puts "visit #{request_token_response.authorization_url}..."
puts
puts "After logging in and clicking 'Allow'"
print "Press Enter To Continue: ";
STDIN.gets;
puts

#
# Retrieve the permanent access token now that the request token has been authroized.
#

access_token_response = Withings::Api.create_access_token(request_token, consumer_token, "user_id_not_currently_required_by_withings")

# store access token values in your database for subsequent access to your data by your application
access_token = access_token_response.access_token

#
# Success!
#

puts "Success! You've gained access to user_id=#{access_token_response.user_id}"
puts "OAuth Access Token Key/Secret: #{access_token.key}/#{access_token.secret}"