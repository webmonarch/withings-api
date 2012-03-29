Feature: withings-api measure/getmeas API support

  To make the withings-api implementation complete,
  As a withings-api user,
  I need to be able to make the measure/getmeas call to the Withings API.

  See: http://www.withings.com/en/api/wbsapiv2#getmeas

  @stubbed
  Scenario: Successful Request with No Parameters
    Given the stubbed Withings API
    And a valid consumer token
    And a valid access token
    And stubbing the HTTP response with measure_getmeas/success
    When requesting the measure/getmeas API
    Then the measure/getmeas call should succeed