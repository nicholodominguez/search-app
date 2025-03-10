#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'readline'

class Search
  def self.run(args)
    new(args).run
  end

  def initialize(args)
    @options = {}

    OptionParser.new do |args|
      args.on("-f", "--file FILENAME", "Filename to be read") do |value|
        @options[:file_name] = value
      end

      args.on("-h", "--help", "Prints this help") do
        puts args
        exit
      end
    end.parse!

    filename = @options[:file_name].nil? ? "clients.json" : @options[:file_name]

    file = File.read(filename)
    @data = JSON.parse(file)
  end

  def run
    puts <<~HELP


    ===================================================================================================
    Commands:
    - search [STRING]: Searches the dataset with records containing STRING in their full_name
    - find_dup: Returns records with duplicate emails
    ===================================================================================================


    HELP

    while buf = Readline.readline("> ", true)
      buf = buf.to_s
      case
      when buf.start_with?("exit")
        return
      when buf.start_with?("search ")
        buf.slice!("search ")
        puts @data.select{ |client| client["full_name"].include? buf }
      when buf.eql?("find_dup")
        puts @data.group_by { |client| client["email"] }.values.select { |a| a.size > 1 }.flatten
      else
        puts "Your input was: '#{buf}'"
      end
    end
  rescue Errors => e
    puts e.message
  end
end