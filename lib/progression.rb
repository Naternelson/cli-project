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
            self.chords << Chord.new(root: self.key, scale: chord[:chord_string], beats: chord[:beats])
        end
        self.save if hash[:save] == true
        self.chords
    end

    def add_chord(scale, beats)
        self.chords << Chord.new(root:self.key, scale: scale, beats: beats)
    end

    def add_score(score)
        self.scores << score
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

    def total_beats
        self.chords.inject{|sum, chord| sum + chord.beats}
    end
    def self.all
        @@all
    end
    def self.get_progressions_from_score(score)
        self.all.select {|prog| prog.scores.include?(score)}
    end

    #Returns an array of chords in measure format
    def progression_list(bpm=4)
        arr = []
        measure = []
        self.chords.each do|chord|
            num_of_beats = chord.beats
            loop do
                if num_of_beats > (bpm-measure.count)
                    (bpm-measure.count).times{measure << chord.value}
                    arr << "/ #{measure.join(" , ")} /"
                    num_of_beats -= bpm
                    measure = []
                elsif num_of_beats == (bpm-measure.count)
                    (bpm-measure.count).times{measure << chord.value}
                    arr << "/ #{measure.join(" , ")} /"
                    num_of_beats -= bpm
                    measure = []
                    break chord
                else
                    measure << num_of_beats.times{chord.value}
                    break chord
                end
            end
        end
        arr
    end
end