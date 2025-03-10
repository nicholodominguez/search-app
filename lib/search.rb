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

    # Use default json file if no file name is supplied
    filename = @options[:file_name] || "clients.json"

    # Read and parse file
    begin
      file = File.read(filename)
      @data = JSON.parse(file)
    rescue Errno::ENOENT
      puts "Error: File '#{filename}' not found."
      exit
    rescue JSON::ParserError
      puts "Error: Failed to parse JSON in '#{filename}'."
      exit
    end
  end

  def run
    puts <<~HELP


    ===================================================================================================
    Commands:
    - search [STRING]: Searches the dataset with records containing STRING in their full_name
    - find_dup: Returns records with duplicate emails
    - exit: Exit the program
    ===================================================================================================


    HELP

    while (buf = Readline.readline("> ", true))
      buf = buf.strip
      case
      when buf.start_with?("exit")
        return
      when buf.start_with?("search ")
        query = buf.sub(/^search\s+/, '')
        search(query)
      when buf.eql?("find_dup")
        find_duplicates
      else
        puts "Unknown command: '#{buf}'"
      end
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
  end

  private

  # Search for records containing the query string in the 'full_name' field
  def search(query)
    results = @data.select { |client| client["full_name"].include?(query) }
    if results.empty?
      puts "No matching records found."
    else
      results.each { |client| pretty_print client }
    end
  end

  # Find records with duplicate emails
  def find_duplicates
    duplicates = @data.group_by { |client| client["email"] }
                      .select { |_, clients| clients.size > 1 }
                      .values.flatten
    if duplicates.empty?
      puts "No duplicate emails found."
    else
      duplicates.each { |client| pretty_print client }
    end
  end

  # Print client information
  def pretty_print(client)
    puts "Name: #{client["full_name"].ljust(20)} Email: #{client["email"]}"
  end
end