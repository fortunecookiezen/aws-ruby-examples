#!/usr/bin/env ruby
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

ec2 = Aws::EC2::Resource.new(region: 'us-east-1')

# To only get the first 10 instances:
# ec2.instances.limit(10).each do |i|
ec2.instances.each do |i|
  case i.state.code
  when 48 # terminated
    puts "#{i.id} is terminated"
  when 64 #stopping
    puts "#{i.id} is stopping"
  when 80 #stopped
    puts "#{i.id} is already stopped"
  else
    i.stop
  end
end
