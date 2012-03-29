require 'uri'

class Hash
  QUERY_STRING_RESERVERED = /[\$&\+,\/:;=\?@ <>"#%\{\}\|\\\^~\[\]`]/

  def to_query_string
    hash = self

    params = []
    hash.keys.each do |key|
      params << [key, hash[key]]
    end

    params.map { |p| p.map { |v| URI.escape(v.to_s, QUERY_STRING_RESERVERED) }.join("=") }.join("&")
  end
end