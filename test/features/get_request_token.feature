Feature: OAuth Request Token

  In order to make authenticated Withings OAuth calls,
  As a withings-api user,
  I need to be able to get an OAuth request token for subsequent authorization by the Withings user.

  Scenario: Success
    Given withings-api
    And valid consumer credentials
    When requesting request token
    Then the request token request should succeed

  Scenario: Failure due to invalid consumer credentials
    Given withings-api
    And invalid consumer credentials
    When requesting request token
    Then the request token request should fail with exception Net::HTTPFatalError
