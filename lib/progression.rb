class Progression
    @@all = []

    attr_reader :key
    def initialize(key)
        @key = key
    end

    def save
      self.class.all << self  
    end

    def self.all
        @@all
    end
end