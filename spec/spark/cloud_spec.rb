require 'spec_helper'
require 'pry'
require 'faraday'

describe RubySpark::Cloud do

  context "when things go right" do
    before  { 
      VCR.use_cassette("authenticate") do
        @cloud = RubySpark::Cloud.new('http://192.168.1.15:8080', 1)
        @cloud.authenticate!('anderson.brandon@gmail.com', 'passw0rd')
      end
    }

    describe "#authenticate" do
      it "succeeds when valid credentials given" do
        VCR.use_cassette("authenticate") do
          result = @cloud.authenticate!('anderson.brandon@gmail.com', 'passw0rd')

          result.should be_a Hash
          result.keys.should =~ ['access_token', 'token_type', 'expires_in']
        end
      end
    end

    describe "#devices" do
      it "succeeds when response is correct... i guess" do
        VCR.use_cassette("devices") do
          devices = @cloud.devices

          devices.should be_a Array
          devices[0].keys.should =~ ['id', 'last_heard', 'connected']
        end
      end
    end

    
  end

  # context "when things go wrong" do
  #   it "returns the appropriate error when Access Token is bad" do
  #     RubySpark.access_token = "bad_token"
  #     subject = described_class.new

  #     VCR.use_cassette("bad_token") do
  #       expect {
  #         subject.cores
  #       }.to raise_error(RubySpark::Cloud::ApiError)
  #     end

  #     VCR.use_cassette("bad_token") do
  #       begin
  #         subject.cores
  #       rescue => e
  #         e.message.should == "invalid_grant: The access token provided is invalid."
  #       end
  #     end
  #   end

  #   it "returns proper error if Access Token is not defined" do
  #     RubySpark.access_token = nil

  #     expect {
  #       subject = described_class.new()
  #     }.to raise_error(RubySpark::ConfigurationError)
  #   end

  #   it "returns the appropriate error when the Spark API times out" do
  #     RubySpark.access_token = "good_access_token"
  #     subject = described_class.new

  #     VCR.use_cassette("spark_timeout") do
  #       expect {
  #         subject.cores
  #       }.to raise_error(RubySpark::Cloud::ApiError)
  #     end

  #     VCR.use_cassette("spark_timeout") do
  #       begin
  #         subject.cores
  #       rescue => e
  #         e.message.should == "Timed out."
  #       end
  #     end
  #   end
  # end

end
