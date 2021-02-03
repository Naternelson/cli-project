class Measure 
    attr_accessor :beats
    attr_reader :chords
    def initialize(num_of_beats)
        self.beats = num_of_beats
        self.chords = []
    end
    def add_chords(array)
        array.each {|chord| self.chords << chord}
    end

    def valid_num_of_beats?(array)
        self.beats >= array.inject {|sum, chord| sum + chord.beats}
    end
end