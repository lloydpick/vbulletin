module VBulletin
  class Base

    attr_accessor :uri, :debug

    def initialize(url, options = {})
      @uri = URI::parse(url)
      @debug = options[:debug] || false
    end

    def forums
      VBulletin::Forum.new(self)
    end
    

    protected
    def construct_url(path, params = nil)
      "#{self.uri.path}/#{path}#{VBulletin::Base.hash2get(params)}"
    end

    # GET's the specified url from the forum
    def get_data(url)
      data = nil
      EM.run do
        client = EM::Protocols::HttpClient2.connect(:host => @uri.host, :port => 80).get(url)
        client.callback {
          data = client.content
          EM.stop
        }
        client.errback { self.fail }
      end
      data
    end

    private
    # Converts a hash to a GET string
    def self.hash2get(h)
      unless h.nil?
        get_string = "?"
        h.each_pair do |key, value|
          if value.is_a?(String)
            get_string += "#{key.to_s}=#{CGI::escape(value.to_s)}"
          elsif value.is_a?(Array)
            value.each do |vals|
              get_string += "#{key.to_s}=#{CGI::escape(vals.to_s)}&"
            end
          end
        end
        get_string
      end
    end



  end
end