Feature: OAuth Access Token

  In order to make authenticated Withings OAuth calls,
  As a user of th withings-api gem,
  I need to be able to request access tokens from a previously retrieved request token.

  Scenario: Request for Authenticated Request Tokens

  Scenario: Request for Not-Autenticated Request Tokens
    Given a valid request token response
    When requesting access token
    Then the access token request should fail with an exception

  Scenario: Request with Invalid Request Token