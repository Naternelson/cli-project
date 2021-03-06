class Progression
    @@all = []

    attr_reader :key, :chords, :scores
    def initialize(key = "C")
        @key = key
        @chords = []
        @scores = []
    end

    #Saves this Progression if it hasn't already been saved
    def save
        if !self.class.all.include?(self)
            self.class.all << self  
        end
    end

    #Creates new chords from the provided hash
    def new_from_hash(hash)
        hash[:chords].each do |chord|
            self.chords << Chord.new(root: self.key, scale: chord[:chord_string])
        end
        self.save if hash[:save] == true
        self.chords
    end

    #Creates and adds a chord to the progression
    def add_chord(scale, beats)
        beats.to_i.times{self.chords << Chord.new(root:self.key, scale: scale)}
    end

    #Associates a score with this progression
    def add_score(score)
        self.scores << score
    end

    #Returns true if the provided scale string is a vaild scale
    def valid?(string)
        Chord.chords.keys.include?(string)
    end


    #Changes the beats for each chord to the same beat
    def change_beats_for_all(beats)
        self.chords.each {|chord| chord.beats=beats}
    end

    #Copies the current chord structures and returns an array of transpose chords
    def transpose(key)
        self.chords.each do |chord|
            chord.transpose(key)
        end
    end

    #Changes the Instance Variables to the new chords
    def transpose_and_save(key)
        self.transpose(key)
        @key = key
    end

    #Removes all chords
    def delete_chords
        @chords.clear
    end

    #Returns chord's base value
    def chord_values(chords=self.chords)
        chords.each_with_index.collect{|chord, i| chord.value if chords[i-1] != chord.value}
    end

    #Returns the total number of beats in this progression
    def total_beats
        self.chords.count
    end

    #Returns every saved instance 
    def self.all
        @@all
    end

    #Returns progressions associated with a certain score
    def self.get_progressions_from_score(score)
        self.all.select {|prog| prog.scores.include?(score)}
    end

    #Returns an array of chords in measure format
    def progression_list(bpm=4)
        arr = []
        measure = []
        self.chords.each do |chord|
            measure << chord.value
            if measure.count == bpm.to_i
                arr << "  / #{measure.join(" , ")} /"
                measure = []
            end
            if self.chords.last == chord && measure.count != 0
                until measure.count == bpm.to_i
                    measure << " "
                end
                arr << "  / #{measure.join(" , ")} /"
            end
        end
        arr
    end
end