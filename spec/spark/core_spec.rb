require 'spec_helper'
require 'pry'

describe RubySpark::Core do

  context "when things go right" do
    before  { 
			RubySpark.cloud_url 		= "http://192.168.1.15:8080"
    	@core = RubySpark::Core.new('54ff6b066667515138551467', 'anderson.brandon@gmail.com', 'passw0rd')
    }

    describe "#attributes" do
      it "succeeds when Access Token and Core ID are correct" do
        VCR.use_cassette("attributes") do
          info = @core.attributes

          info.should be_a Hash
          info.keys.should =~ ["id", "name", "connected", "variables", "functions"]
        end
      end
    end

    describe "#function" do
      it "succeeds when Access Token and Core ID are correct" do
        VCR.use_cassette("function") do
          r = @core.function("digitalwrite", "D3,LOW")

          r.should be_a Hash
          r.keys.should =~ ['id', 'name', 'last_app', 'connected', 'return_value']
          r['return_value'].should == 1
        end
      end
    end

    # describe "#variable" do
    #   it "succeeds when Access Token and Core ID are correct" do
    #     VCR.use_cassette("variable") do
    #       subject.variable("temperature").should == 70
    #     end
    #   end
    # end

  end

  context "when things go wrong" do

    it "returns the appropriate error when Core ID is bad" do
      RubySpark.access_token = "good_access_token"
      subject = described_class.new("bad_core_id")

      VCR.use_cassette("bad_core_id") do
        expect {
          subject.info
        }.to raise_error(RubySpark::Cloud::ApiError)
      end

      VCR.use_cassette("bad_core_id") do
        begin
          subject.info
        rescue => e
          e.message.should == "Permission Denied: Invalid Core ID"
        end
      end
    end

  end

end
