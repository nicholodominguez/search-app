require 'rspec'
require 'json'
require 'readline'
require_relative '../lib/search'

RSpec.describe Search do
  let(:json_data) do
    [
      { "full_name" => "Dreadking Rathalos", "email" => "dk.rathalos@example.com" },
      { "full_name" => "Guardian Rathalos", "email" => "guardian.rathalos@example.com" },
      { "full_name" => "Jin Dahaad", "email" => "long.boi@example.com" }
    ].to_json
  end

  before do
    allow(File).to receive(:read).and_return(json_data)
  end

  describe '#search' do
    let(:search_instance) { Search.new([]) }

    it 'returns matching records for full_name' do
      expect { search_instance.send(:search, 'rathalos') }.to output(/Found 2 matching record\(s\) for 'rathalos'/).to_stdout
    end

    it 'returns matching records for email' do
      expect { search_instance.send(:search, 'long.boi@example.com') }.to output(/Found 1 matching record\(s\) for 'long.boi@example.com'/).to_stdout
    end

    it 'handles empty search query gracefully' do
      expect { search_instance.send(:search, '') }.to output("Search query cannot be empty.\n").to_stdout
    end

    it 'returns no records if no match is found' do
      expect { search_instance.send(:search, 'nonexistent') }.to output("No matching records found.\n").to_stdout
    end
  end
end