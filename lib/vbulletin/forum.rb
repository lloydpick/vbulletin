module VBulletin
  class Forum < Base

    def initialize(api, options = {})
      @api = api
      @debug = options[:debug] || false
    end

    def all
      parse_index(@api.construct_full_url("index.php"))
    end

    private
    def parse_index(url)
      if (result = @api.mechanize.get(url))
        puts result.body
      end
    end

  end
end