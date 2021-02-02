class Score
    attr_accessor :name, :artist
    attr_reader :key, :beats_per_measure, :measures
    @@all = []
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        @measures = [],
        @progressions = []
    end

    def progressions
        Progressions.all.select {|prog| prog.score == self}
    end

    def add_measures_from_progression(:progression, :repeat = 1)

    end

    def whole_measure?(chord)
        chord.beats == self.beats_per_measure
    end
end