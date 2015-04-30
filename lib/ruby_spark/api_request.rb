module RubySpark

  class ApiRequest
    class ApiError < StandardError; end

    attr_reader :response

    def initialize()
    end

    def devices
      get('/devices')
    end

    def function
      post("/devices/#{core}/#{function}", arguments)
    end

    def var
      get("/devices/#{core}/#{var}", arguments)
    end

    def attributes
      get("/devices/#{core}")
    end
    
    private

    def authorization_header(access_token)
      {"Authorization" => "Bearer #{access_token}"} if access_token
    end

    def basic_auth_params(username, password)
      {:username => username, :password => password}
    end

    def timeout
      RubySpark.timeout
    end

  end
end
