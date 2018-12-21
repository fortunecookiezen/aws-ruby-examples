#!/usr/bin/env ruby

require 'aws-sdk-iam'  # v2: require 'aws-sdk'

iam = Aws::IAM::Client.new(region: 'us-east-1')

user_name = ARGV[0]

raise RuntimeError, 'empty argument' if ARGV[0].nil?

# List user access keys.
def list_keys(iam, user_name)
  begin
    list_access_keys_response = iam.list_access_keys({ user_name: user_name })

    if list_access_keys_response.access_key_metadata.count == 0
      puts "No access keys."
    else
      puts "Access keys:"
      list_access_keys_response.access_key_metadata.each do |key_metadata|
        puts "  Access key ID: #{key_metadata.access_key_id}"
      end
    end

  rescue Aws::IAM::Errors::NoSuchEntity
    puts "Cannot find user '#{user_name}'."
    exit(false)
  end
end

# list keys and determine when access keys were last used.
puts "Access Key(s) for #{user_name} were last used:"

list_access_keys_response = iam.list_access_keys({ user_name: user_name })

list_access_keys_response.access_key_metadata.each do |key_metadata|
  resp = iam.get_access_key_last_used({ access_key_id: key_metadata.access_key_id })

  puts " Key '#{key_metadata.access_key_id}' last used on #{resp.access_key_last_used.last_used_date}"

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

=begin

# Delete the access key.
puts "\nDeleting access key..."

iam.delete_access_key({
  user_name: user_name,
  access_key_id: list_access_keys_response.access_key_metadata[0].access_key_id
})

puts "\nAfter deleting access key..."
list_keys(iam, user_name)
=end
