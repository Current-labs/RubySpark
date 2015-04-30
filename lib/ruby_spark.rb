require 'httparty'
require 'time'

require 'ruby_spark/version'
require 'ruby_spark/cloud'
require 'ruby_spark/api_request'
require 'ruby_spark/access_token'
require 'ruby_spark/core'
require 'ruby_spark/tinker'
require 'ruby_spark/helpers/configuration'

module RubySpark
  class ConfigurationError < StandardError; end

  include Configuration

  define_setting :access_token
  define_setting :timeout, 30
  define_setting :cloud_url, "https://api.spark.io/"
  define_setting :cloud_version, "1"
end
