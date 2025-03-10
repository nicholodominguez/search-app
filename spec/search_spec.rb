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
end