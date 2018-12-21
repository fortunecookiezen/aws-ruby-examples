#!/usr/bin/env ruby
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

ec2 = Aws::EC2::Client.new(region: 'us-east-1')

key_pair_name = ARGV[0]

raise RuntimeError, 'empty argument' if ARGV[0].nil?

# Create a key pair.
begin
  key_pair = ec2.create_key_pair({
    key_name: key_pair_name
  })
  puts "Created key pair '#{key_pair.key_name}'."
  puts "\nSHA-1 digest of the DER encoded private key:"
  puts "#{key_pair.key_fingerprint}"
  puts "\nUnencrypted PEM encoded RSA private key:"
  puts "#{key_pair.key_material}"
rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
  puts "A key pair named '#{key_pair_name}' already exists."
end

# Get information about Amazon EC2 key pairs.
key_pairs_result = ec2.describe_key_pairs()

if key_pairs_result.key_pairs.count > 0
  puts "\nKey pair names:"
  key_pairs_result.key_pairs.each do |key_pair|
    puts key_pair.key_name
  end
end
