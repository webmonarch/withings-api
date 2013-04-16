
access_token = 'YOUR ACCESS TOKEN'

### Example for the Singly Withings User/Self API
data = Withings::Api.singly_user_self :access_token => access_token
hash={}
data.user.instance_variables.each { |var| hash[var.to_s.delete("@")] = data.user.instance_variable_get(var) }
puts hash.inspect

### Example for the Singly Withings Measures 
data = Withings::Api.singly_measure_getmeas :access_token => access_token
hash={}
data.measure_groups.each do |group|
 group_hash={}
 group.instance_variables.each do |var| 
   group_hash[var.to_s.delete("@")] = group.instance_variable_get(var)
 end
 hash[group.id]=group_hash
end
puts hash.inspect
