class Score
    attr_accessor :name, :artist
    attr_reader :key, :beats_per_measure, :measures
    @@all = []
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        @measures = []
    end

    def progressions
        Progressions.all.select {|prog| prog.score == self}
    end

    def add_measures_from_progression(:progression, :repeat = 1)
        repeat.times {
            progression.each do |chord|
                self.measures << chord
            end
        }
        
    end

    def progression_num_of_measures(progression)
        (progression.total_beats / self.beats_per_measure.to_f).ceil
    end

end