class Progression
    @@all = []

    attr_reader :key, :chords, :scores
    def initialize(key = "C")
        @key = key
        @chords = []
        @scores = []
    end

    def save
        if !self.class.all.include?(self)
            self.class.all << self  
        end
    end

    def new_from_string(string:, save: false)
        @chords << Chord.new(root: self.key, scale: chord_string, beats: 4)
        self.save if save == true
    end

    def new_from_hash(hash:, save: false)
        hash.each do |chord|
            @chords << Chord.new(root: self.key, scale: chord[:chord_string], beats: chord[:beats])
        end
        self.save if save == true
    end

    def new_from_array(array:, beats: 4, save: false)
        array.each {|chord_string| @chords << Chord.new(root: self.key, scale: chord_string, beats: beats)}
        self.save if save == true
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

    def transpose(key)
        new_chords = []
        chords.each do |chord|
            new_chords << Chord.new(root: key, scale: chord.scale, beats: chord.beats)
        end
        new_chords
    end

    def transpose_and_save(key)
        new_chords = self.transpose(key)
        self.delete_chords
        @key = key
        @chords = new_chords
    end

    def delete_chords
        @chords.clear
    end
    def self.all
        @@all
    end
end