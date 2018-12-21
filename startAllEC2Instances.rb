#!/usr/bin/env ruby
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

ec2 = Aws::EC2::Resource.new(region: 'us-east-1')

# To only get the first 10 instances:
# ec2.instances.limit(10).each do |i|
ec2.instances.each do |i|
  case i.state.code
  when 0  # pending
    puts "#{id} is pending"
  when 16  # started
    puts "#{id} is already started"
  when 48  # terminated
    puts "#{id} is terminated"
  else
    i.start
  end
end
