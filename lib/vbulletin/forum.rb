module VBulletin
  class Forum < Base

    def initialize(api, options = {})
      @api = api
      @debug = options[:debug] || false
    end

    def all
      parse_index(@api.construct_url("index.php"))
    end

    private
    def parse_index(url)
      if (result = @api.get_data(url))
        puts result.inspect
      end
    end

  end
end