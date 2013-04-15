require 'json'

module Withings::Api
  
  # Class encapsulating a User
  #
  # See www.withings.com/en/api/wbsapiv2
  class User 
    include ResultsHelpers

    attr_reader :id, :firstname, :lastname, :shortname, :gender, :fatmethod, :birthday
    
    def initialize(json_string_or_hash)
      hash = coerce_hash json_string_or_hash

      #"id": 29, "firstname": "John", "lastname": "Doe", "shortname": "JON", "gender": 0,"fatmethod": 0,"birthdate": 211629600,
      @id = hash["id"]
      @firstname = hash["firstname"]
      @lastname = hash["lastname"]
      @shortname = hash["shortname"]
      #@gender = GenderType.lookup(hash["gender"])
      @gender = ( hash["gender"]==0 ? "M" : ( hash["gender"] == 1 ? "F" : "" ) )
      @fatmethod = hash["fatmethod"]
      @birthdate = hash["birthdate"]      
    end

    def date
      Time.at(date_raw)
    end
  end
  
  # Class encapsulating the response to a call to
  # user/self through Single
  #
  # See www.withings.com/en/api/wbsapiv2
  class UserSelfResults
    include ResultsHelpers

    attr_accessor :user
    
    def initialize(json_or_hash)
      hash = coerce_hash json_or_hash
      self.user = User.new(hash)
    end

    def update_time
      Time.at(update_time_raw)
    end

  end
  
end