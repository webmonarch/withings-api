Feature: OAuth access_token Call

  In order to make authenticated Withings OAuth calls,
  As a user of th withings-api gem,
  I need to be able to request access tokens from a previously retrieved request token.

  #
  # LIVE
  #

  @live
  Scenario: Succeeds On Live Withings
    Given the live Withings API
    And a valid request_token from Withings Live
    And authorized access request
    When making an access_token call
    Then the access_token call should succeed

  @live
  Scenario: Fails Due To Not Authrorized Request Token On Live Withings
    Given the live Withings API
    And a valid request_token from Withings Live
    When making an access_token call
    Then the access_token call should fail

  @live
  Scenario: Fails Due To Invalid Request Token On Live Withings
    Given the live Withings API
    And a valid consumer token
    And a random request token
    When making an access_token call
    Then the access_token call should fail

  @live
  Scenario: Fails Due To Invalid Consumer Token On Live Withings
    Given the live Withings API
    And a valid request_token from Withings Live
    And a random consumer token
    When making an access_token call
    Then the access_token call should fail

  @stubbed
  Scenario: Success On Stubbed Withings
    Given the stubbed Withings API
    And a valid consumer token
    And a valid request token
    And stubbing the HTTP response with access_token/success
    When making an access_token call
    Then the access_token call should succeed

  @stubbed
  Scenario: Fails With Invalid Stubbed Withings
    Given the stubbed Withings API
    And a valid consumer token
    And a random request token
    And stubbing the HTTP response with access_token/invalid
    When making an access_token call
    Then the access_token call should fail

  @stubbed
  Scenario: Fails With Unauthorized Stubbed Withings
    Given the stubbed Withings API
    And a valid consumer token
    And a random request token
    And stubbing the HTTP response with access_token/unauthorized_token
    When making an access_token call
    Then the access_token call should fail



