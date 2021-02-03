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

    #Creates new chords from the provided hash
    def new_from_hash(hash)
        hash[:chords].each do |chord|
            @chords << Chord.new(root: self.key, scale: chord[:chord_string], beats: chord[:beats])
        end
        self.save if hash[:save] == true
        self.chords
    end

    #Returns true if the provided scale string is a vaild scale
    def valid?(string)
        Chord.chords.keys.include?(string)
    end

    #With a provided chord, changes the beat of that chord
    def change_beats(chord:, beats:)
        chord.beats = beats
    end

    #Changes the beats for each chord to the same beat
    def change_beats_for_all(beats)
        self.chords.each {|chord| chord.beats=beats}
    end

    #Copies the current chord structures and returns an array of transpose chords
    def transpose(key)
        new_chords = []
        self.chords.each do |chord|
            new_chords << Chord.new(root: key, scale: Chord.chord_key(chord.scale), beats: chord.beats)
        end
        new_chords
    end

    #Changes the Instance Variables to the new chords
    def transpose_and_save(key)
        new_chords = self.transpose(key)
        self.delete_chords
        @key = key
        @chords = new_chords
    end

    def delete_chords
        @chords.clear
    end

    def chord_values(chords=self.chords)
        chords.collect{|chord| chord.value}
    end
    def self.all
        @@all
    end
end