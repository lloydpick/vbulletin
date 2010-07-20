module VBulletin
  class Thread < Base

    attr_reader :id, :title, :api, :created_at

    def initialize(*params)
      params.each do |key|
        key.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end

    def created_at
      # Yesterday at 05:06 PM
      @created_at.gsub!('Yesterday', Date.yesterday.strftime("%m-%d-%Y"))
      @created_at.gsub!(',', '')
      @created_at = DateTime.strptime(@created_at, '%m-%d-%Y %I:%M %p')
    end

  end
end