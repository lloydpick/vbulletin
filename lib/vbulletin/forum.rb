module VBulletin
  class Forum < Base

    attr_reader :id, :name

    def initialize(*params)
      params.each do |key|
        key.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end

  end
end