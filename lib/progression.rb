class Progression
    @@all = []

    attr_reader :key, :chords, 
    def initialize(key = "C")
        @key = key
        @chords = []
    end

    def save
      self.class.all << self  
    end

    def new_from_hash(hash)
        hash[:chords].each do |chord_string|
            return nil if !self.valid?(chord_string)
            @chords << Chord.new(chord: self.key, scale: chord_string, beats: hash[:beats])
        end
    end

    def create_from_hash(hash)
        self.new_from_hash(hash)
        self.save
    end

    def valid?(string)
        Chord.chords.keys.include?(string)
    end

    def change_beats(chord:, beats:)
        chord.beats = beats
    end

    def change_beats_for_all(beats)
        self.chords.each {|chord| chord.beats=beats}
    end
    def self.all
        @@all
    end
end