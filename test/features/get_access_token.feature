Feature: OAuth access_token Call

  In order to make authenticated Withings OAuth calls,
  As a user of th withings-api gem,
  I need to be able to request access tokens from a previously retrieved request token.

  #
  # LIVE
  #

  Scenario: Succeeds On Live Withings
    Given the live Withings API
    And a valid request_token from Withings Live
    And authorized access request
    When making an access_token call
    Then the access_token call should succeed

  Scenario: Fails Due To Not Authrorized Request Token On Live Withings
    Given the live Withings API
    And a valid request_token from Withings Live
    When making an access_token call
    Then the access_token call should fail

  Scenario: Fails Due To Invalid Request Token On Live Withings
    Given the live Withings API
    And a valid consumer token
    And a random request token
    When making an access_token call


  Scenario: Fails Due To Invalid Consumer Token On Live Withings

