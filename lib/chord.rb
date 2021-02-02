class Chord
    NOTES = {
        "A" => 0,
        "A# / Bb" => 1,
        "B" => 2,
        "C" => 3,
        "C# / Db" => 4,
        "D" => 5,
        "D# / Eb" => 6,
        "E" => 7,
        "F" => 8,
        "F# / Gb" => 9,
        "G" => 10,
        "G# / Ab" => 11
    }
    CHORDS = {
        "I" => {type: "Major", notes: [0, 4,7]},
        "ii" => {type: "Minor", notes: [2, 5, 9]},
        "iii" => {type: "Minor", notes: [4, 7, 11]},
        "iv" => {type: "Major", notes: [5, 9, 0]},
        "V" => {type: "Major", notes: [7,11,2]},
        "Vi" => {type: "Major", notes: [9,0,4]},
        "Vii" => {type: "Minor", notes: [11,2,5]}
    }
    attr_accessor :beats
    attr_reader :chord, :scale, :root
    @@all = []
    def initialize(root:, scale:, beats:)
        self.beats = beats
        @root = NOTES[root]
        @scale = CHORDS[scale]
        chords_notes = self.scale.notes
        @chord = []
        self.make_chord(self.root, chord_notes)
        @@all << self
    end
    def make_chord(base, chord_notes)
        chord_notes.each do |c|
            note = c + base 
            note_value = note >= 12 ? (note % 12) : note 
            letter = NOTES.index(note_value)
            self.chord << letter
        end
    end

end