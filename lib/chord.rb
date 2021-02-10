class Chord
    NOTES = {
        "A" => 0, "A# | Bb" => 1,"B" => 2,
        "C" => 3,"C# | Db" => 4,"D" => 5,
        "D# | Eb" => 6,"E" => 7,"F" => 8,
        "F# | Gb" => 9,"G" => 10,"G# | Ab" => 11
    }
    CHORDS = {
        "I" => {type: "Major", notes: [0, 4,7]},
        "ii" => {type: "Minor", notes: [2, 5, 9]},
        "iii" => {type: "Minor", notes: [4, 7, 11]},
        "IV" => {type: "Major", notes: [5, 9, 0]},
        "V" => {type: "Major", notes: [7,11,2]},
        "vi" => {type: "Minor", notes: [9,0,4]},
        "vii" => {type: "Minor", notes: [11,2,5]}
    }

    attr_reader :chord, :scale, :root, :value
    
    #Creates a new chord and retrieves its chord array, the scale array, and the base value
    def initialize(root:, scale:)
        @root = NOTES[root]
        @scale = CHORDS[scale]
        chord_notes = self.scale[:notes]
        @chord = []
        self.make_chord(self.root, chord_notes)
        @value = self.scale[:type] == "Minor" ? "#{self.chord[0]} min" : self.chord[0]  
    end

    #Adds notes to chord
    def make_chord(base, chord_notes)
        chord_notes.each do |c|
            note = c + base 
            note_value = note >= 12 ? (note % 12) : note 
            letter = NOTES.key(note_value)
            self.chord << letter
        end
    end
    
    #transpose this chord
    def transpose(new_root)
        @root = NOTES[new_root]
        @chord = []
        make_chord(self.root, self.scale[:notes])
        @value = self.scale[:type] == "Minor" ? "#{self.chord[0]} min" : self.chord[0]  
    end

    # def self.chord_key(hash)
    #     CHORDS.key(hash)
    # end

    #Class method to retrieve CHORDS
    def self.chords 
        CHORDS
    end
    #Class method to retrieve NOTES
    def self.notes 
        NOTES
    end


end