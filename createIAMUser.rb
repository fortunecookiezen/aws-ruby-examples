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

puts "User names before creating user..."
list_user_names(iam)

# Create a user.
puts "\nCreating user..."

iam.create_user({ user_name: user_name })

puts "\nUser names after creating user..."
list_user_names(iam)

=begin

# Update the user's name.
puts "\nChanging user's name..."

begin
  iam.update_user({
    user_name: user_name,
    new_user_name: changed_user_name
  })

  puts "\nUser names after updating user's name..."
  list_user_names(iam)
rescue Aws::IAM::Errors::EntityAlreadyExists
  puts "User '#{user_name}' already exists."
end

# Delete the user.
puts "\nDeleting user..."
iam.delete_user({ user_name: changed_user_name })

puts "\nUser names after deleting user..."
list_user_names(iam)
=end
