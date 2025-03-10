#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'readline'

@options = {}

OptionParser.new do |opts|
  opts.on("-f", "--file FILENAME", "Filename to be read") do |value|
    @options[:file_name] = value
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

filename = @options[:file_name].nil? ? "clients.json" : @options[:file_name]

file = File.read(filename)
data = JSON.parse(file)

puts <<~HELP


   ===================================================================================================
   Commands:
   - search [STRING]: Searches the dataset with records containing STRING in their full_name
   - find_dup: Returns records with duplicate emails
   ===================================================================================================


   HELP

while buf = Readline.readline(prompt, true)
  buf = buf.to_s
  case
  when buf.start_with?("exit")
    return
  when buf.start_with?("search ")
    buf.slice!("search ")
    puts data.select{ |client| client["full_name"].include? buf }
  when buf.eql?("find_dup")
    puts data.group_by { |client| client["email"] }.values.select { |a| a.size > 1 }.flatten
  else
    puts "Your input was: '#{buf}'"
  end
end