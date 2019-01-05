#!/usr/bin/env ruby
require 'aws-sdk-iam'  # v2: require 'aws-sdk'

iam = Aws::IAM::Client.new(region: 'us-east-1')

user_name = ARGV[0]

raise RuntimeError, 'empty argument' if ARGV[0].nil?

# Get information about available AWS IAM users.
def list_user_names(iam)
  list_users_response = iam.list_users
  list_users_response.users.each do |user|
    puts user.user_name
  end
end

puts "User names before creating user " + ARGV[0]
list_user_names(iam)

# Create a user.
puts "\nCreating user " + ARGV[0]

iam.create_user({ user_name: user_name })

puts "\nUser names after creating user " + ARGV[0]
list_user_names(iam)
