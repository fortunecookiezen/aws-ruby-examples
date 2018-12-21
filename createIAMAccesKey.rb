#!/usr/bin/env ruby

=begin
This should only be used for testing. Users should create their own access key pairs
=end

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

begin
  iam.create_access_key({ user_name: user_name })
  puts "\nAfter creating access key..."
  list_keys(iam, user_name)
rescue Aws::IAM::Errors::LimitExceeded
  puts "Too many access keys. Can't create any more."
end
