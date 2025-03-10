#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'readline'

@options = {}

OptionParser.new do |opts|
  opts.on("-f", "--file FILENAME", "Filename to be read") do |value|
    @options[:file_name] = value
  end
end.parse!

filename = @options[:file_name].nil? ? "clients.json" : @options[:file_name]

file = File.read(filename)
data = JSON.parse(file)

prompt = "> "
while buf = Readline.readline(prompt, true)
  buf = buf.to_s
  case
  when buf.start_with?("exit")
    return
  else
    puts "Your input was: '#{buf}'"
  end
end