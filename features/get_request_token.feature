Feature: OAuth request_token Call

  In order to make authenticated Withings OAuth calls,
  As a withings-api user,
  I need to be able to get an OAuth request token for subsequent authorization by the Withings user.

  #
  # LIVE TESTS
  #

  @live
  Scenario: Succeeds On Live Withings
    Given the live Withings API
    And valid consumer token
    When making a request_token call
    Then the request_token call should succeed

  @live
  Scenario: Fails With Blank Consumer Credentials On Live Withings
    Given the live Withings API
    And blank consumer token
    When making a request_token call
    Then the request_token call should fail

  @live
  Scenario: Fails With Random Consumer Credentials On Live Withings
    Given the live Withings API
    And random consumer token consumer token
    When making a request_token call
    Then the request_token call should fail

  @live
  Scenario: Fails With Invalid Consumer Credentials Secret On Live Withings
    Given the live Withings API
    And invalid_secret consumer token consumer token
    When making a request_token call
    Then the request_token call should fail

  #
  # STUBBED TESTS
  #

  @stubbed
  Scenario: Succeeds On Stubbed Withings
    Given the stubbed Withings API
    And valid consumer token
    And stubbing the HTTP response with request_token/success
    When making a request_token call
    Then the request_token call should succeed
    And the request_token key should be "d677dcdefbfe1d00d86fcdc033d9046c76e92e611b6392893923c121b"
    And the request_token secret should be "379667e6b9c1899f678677ef846f498184c577569b664b6181e4422ee77d4d"

  @stubbed
  Scenario: Fails With Random Consumer Credentials On Stubbed Withings
    Given the stubbed Withings API
    And random consumer token consumer token
    And stubbing the HTTP response with request_token/invalid_consumer_credentials
    When making a request_token call
    Then the request_token call should fail

  @stubbed
  Scenario: Create Request Token With Random Consumer Credentials

  @stubbed
  Scenario: Create Request Token And Connection Connect Timeout

  @stubbed
  Scenario: Create Request Token And Connection Read Timeout
