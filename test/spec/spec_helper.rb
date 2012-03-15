require 'withings-api'
require File.join(File.dirname(__FILE__), "../helpers/http_stubber")

API = Withings::Api
API_MODULE = API

SAMPLE_JSON_DIR = File.join(File.dirname(__FILE__), "..", "sample_json")

