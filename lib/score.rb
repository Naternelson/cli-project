class Score
    attr_reader :key, :beats_per_measure, :measures, :name, :artist, :progressions
    @@all = []
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        @measures = [],
        @progressions = []
    end

end