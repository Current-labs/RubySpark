module RubySpark

  class Cloud

    class CloudError < StandardError; end

    def initialize(base_url=nil, version=nil)

      @base_url  = base_url || RubySpark.cloud_url
      @version   = version  || RubySpark.cloud_version

      # Configure Faraday
      @connection = Faraday.new(url: @base_url) do |faraday|
        faraday.request   :url_encoded
        # faraday.response  :logger
        faraday.adapter   Faraday.default_adapter
      end

      raise ArgumentError.new("Cloud URL cannot be empty") if @base_url.nil?
      raise ConfigurationError.new("Cloud version cannot be nil") if @version.nil?
    end

    def authenticate!(username, password)
      response = @connection.post '/oauth/token', auth_params(username, password)

      case response.status
        when 200
          @auth_token = JSON.parse(response.body)
        else
          raise CloudError.new('Unable to retrieve AuthToken')
      end
    end

    def devices
      get('/devices')
    end

    def auth_token
      @auth_token
    end

    def to_s
      url.to_s
    end

    def get(path)
      response = @connection.get "v#{@version}#{path}" do |req|
        req.headers['Authorization'] = "Bearer #{@auth_token['access_token']}"
      end

      case response.status
        when 200
          JSON.parse(response.body)
        else
          # raise CloudError.new JSON.parse(response.body)['error_description']
          raise CloudError.new response.body
      end
    end

    def post(path, arguments)
      response = @connection.post "v#{@version}#{path}", arguments do |req|
        req.headers['Authorization'] = "Bearer #{@auth_token['access_token']}"
      end

      case response.status
        when 200
          JSON.parse(response.body)
        else
          # raise CloudError.new JSON.parse(response.body)['error_description']
          raise CloudError.new response.body
      end
    end

    private

    def auth_params(username, password)
      { 
        grant_type:     'password',
        username:       username,
        password:       password,
        client_id:      'RubySpark',
        client_secret:  'i_cant_believe_this_doesnt_matter'
      }
    end

    def auth_header

    end

  end
end
