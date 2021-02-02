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

    def new_from_array(hash)
        hash[:chords].each do |chord_string|
            return nil if !self.valid?(chord_string)
            @chords << Chord.new(chord: self.key, scale: chord_string, beats: hash[:beats])
        end
    end

    def valid?(string)
        Chord.chords.keys.include?(string)
    end
    def self.all
        @@all
    end
end