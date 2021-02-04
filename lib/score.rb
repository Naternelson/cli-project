class Score
    attr_accessor :name, :artist
    attr_reader :key, :beats_per_measure, :measures
    @@all = []
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        @measures = []
    end

    #Returns an array of associated Progressions
    def progressions
        Progressions.all.select {|prog| prog.score == self}
    end

    #Adds new measures based off a progression, repeated 
    def add_measures_from_progression(:progression, :repeat = 1)
        count = 0
        measure = nil
        repeat.times {progression.chords.each do |chord|
                measure ||= Measure.new(self.beats_per_measure)
                measure.chords << chord
                count += chord.beats
                if count == self.beats_per_measure
                    measure == nil
                    count == 0
                end
                
            end
        }
    end

end