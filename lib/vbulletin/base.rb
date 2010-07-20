module VBulletin
  class Base

    attr_accessor :uri, :mechanize, :debug

    def initialize(url, options = {})
      @uri = URI::parse(url)
      @debug = options[:debug] || false
      @api = self
    end

    def login(username, password)
      mechanize = Mechanize.new
      mechanize.get(construct_full_url('login.php', { 'do' => 'login' })) do |login_page|

        # Submit the login form
        login_page.form_with(:action => 'login.php?do=login') do |f|
          f.vb_login_username = username
          f.vb_login_md5password = password
        end.click_button

      end

      #raise mechanize.inspect
      self.mechanize = mechanize

    end

    def get_index
      index = self.mechanize.get(construct_full_url('index.php'))
      puts index.body
    end

    def forums
      VBulletin::Forum.new(self)
    end

    def search
      VBulletin::Search.new(self)
    end
    

    
    def construct_url(path, params = nil)
      "#{self.uri.path}/#{path}#{VBulletin::Base.hash2get(params)}"
    end

    def construct_full_url(path, params = nil)
      "#{self.uri.scheme}://#{self.uri.host}#{construct_url(path, params)}"
    end

    private
    # Converts a hash to a GET string
    def self.hash2get(h)
      unless h.nil?
        get_string = "?"
        h.each_pair do |key, value|
          if value.is_a?(String)
            get_string += "#{key.to_s}=#{CGI::escape(value.to_s)}&"
          elsif value.is_a?(Integer)
            get_string += "#{key.to_s}=#{CGI::escape(value.to_s)}&"
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