#!/usr/bin/env ruby
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

ec2 = Aws::EC2::Client.new(region: 'us-east-1')

key_pair_name = ARGV[0]

raise RuntimeError, 'empty argument' if ARGV[0].nil?

# Delete the key pair.
ec2.delete_key_pair({
  key_name: key_pair_name
})

# Get information about Amazon EC2 key pairs.
key_pairs_result = ec2.describe_key_pairs()

if key_pairs_result.key_pairs.count > 0
  puts "\nKey pair names:"
  key_pairs_result.key_pairs.each do |key_pair|
    puts key_pair.key_name
  end
end
