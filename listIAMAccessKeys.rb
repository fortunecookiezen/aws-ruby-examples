#!/usr/bin/env ruby

require 'aws-sdk-iam'  # v2: require 'aws-sdk'

iam = Aws::IAM::Client.new(region: 'us-east-1')

user_name = ARGV[0]
#user_name = "jamesp"
raise RuntimeError, 'empty argument' if ARGV[0].nil?

# list keys and determine when access keys were last used.
puts " Access Key(s) for #{user_name} were last used:"

list_access_keys_response = iam.list_access_keys({ user_name: user_name })

list_access_keys_response.access_key_metadata.each do |key_metadata|
  resp = iam.get_access_key_last_used({ access_key_id: key_metadata.access_key_id })

  puts "  Key '#{key_metadata.access_key_id}' last used on #{resp.access_key_last_used.last_used_date}"

end

=begin

  # Deactivate access keys.
  puts "  Trying to deactivate this key..."

  iam.update_access_key({
    user_name: user_name,
    access_key_id: key_metadata.access_key_id,
    status: "Inactive"
  })
end

puts "\nAfter deactivating access key(s)..."
list_keys(iam, user_name)

# Delete the access key.
puts "\nDeleting access key..."

iam.delete_access_key({
  user_name: user_name,
  access_key_id: list_access_keys_response.access_key_metadata[0].access_key_id
})

puts "\nAfter deleting access key..."
list_keys(iam, user_name)
=end
