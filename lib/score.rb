class Score
    attr_accessor :name, :artist
    attr_reader :key, :beats_per_measure, :measures
    @@all = []
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        @measures = []
    end

    def add_empty_measures(num)
        num.to_i.times {self.measures << nil}
    end
    #Returns an array of associated Progressions
    def progressions
        Progressions.all.select {|prog| prog.score == self}
    end

    #Adds new measures based off a progression, repeated 
    def add_measures_from_progression(progression, repeat =1)
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
    def num_of_measures
        self.measures.count + 1
    end

    def get_measure_by_number(measure_num, num_of_measures=1)
        i = measure_num.to_i - 1
        j = num_of_measures.to_i
        arr = []
        while i < i+j
            arr << self.measure[i] if self.measure[i]
            i+=1
        end
        arr
    end

    def get_measure_chords(int)
        arr = []
        self.measure[int.to_i -1].chords.each do |chord|
            hash = {
                value: chord.value
                beats: chord.beats
            }
            arr << hash
        end
        arr
    end
end