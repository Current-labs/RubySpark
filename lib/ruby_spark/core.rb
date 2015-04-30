module RubySpark

  class Core
    attr_reader :info

    def initialize(core_id, username, password)
      @info  = { :id => core_id.to_s }
      @cloud = Cloud.new
      @cloud.authenticate!(username, password)
    end

    def attributes
      @cloud.get( path )
    end

    def variable(name)
      @cloud.get( path(name) )
    end

    def function(name, arguments)
      @cloud.post( path(name), args: arguments )
    end

    def online?
      attributes['connected']
    end

    def to_s
      @info[:id]
    end

  private

    def path(method_path=nil)
      "#{self.class.path}#{self}/#{method_path}"
    end

    def self.path
      "/devices/"
    end

  end

end
