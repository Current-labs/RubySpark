module RubySpark

  class AccessToken

    def initialize(token, cloud: cloud)
      raise ArgumentError.new("Access token cannot be empty") if token.to_s == ""

      @token_info = {}

      if token.kind_of?(Hash)
        update_info(token)
      else
        @token_info[:token] = token.to_s
      end

      @cloud = RubySpark::Cloud.sure(cloud)
    end

    def to_s
      @token_info[:token].to_s
    end

    def self.all(username, password, cloud: nil)
      tokens = RubySpark::ApiRequest.send( "access_tokens", cloud: cloud,
                                           username: username, password: password )

      tokens.collect{|token| RubySpark::AccessToken.new(token)}
    end

    def self.create(username, password, cloud: nil)
      auth_params = { "grant_type" => "password",
                      "username" => username,
                      "password" => password }

      token = RubySpark::ApiRequest.send( "oauth/token", cloud: cloud,
                                          method: :post, params: auth_params,
                                          username: "spark", password: "spark" )

      new(token["access_token"], cloud: cloud)
    end

    def self.sure(token=nil, cloud: cloud)
      token ||= RubySpark.access_token
      raise RubySpark::ConfigurationError.new("Access token not defined") if token.to_s == ""

      token.kind_of?(RubySpark::AccessToken) ? token : new(token, cloud: cloud)
    end

    def delete(username, password)
      RubySpark::ApiRequest.send( "access_tokens/#{self}", method: :delete,
                                  username: username, password: password,
                                  cloud: @cloud )
    end

    private

    def update_info(info)
      @token_info.merge!(info.transform_keys{ |key| key.to_sym rescue key })
    end

  end

end
