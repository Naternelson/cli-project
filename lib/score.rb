class Score
    attr_accessor :name, :artist
    attr_accessor :key, :beats_per_measure, :chords
    @@all = []
    def initialize()
        @chords = []
    end
    def progressions
        Progression.all.select {|prog| prog.scores.include?(self)}
    end

    #Adds new measures based off a progression, repeated 
    def add_chords_from_progression(progression, repeat =1)
        repeat.times { 
            progression.chords.each do |chord|
                self.chords << chord 
            end
        }
    end
    def num_of_measures
        (self.chords.count / self.beats_per_measure.to_f).ceil
    end

    def delete_measures(start, end_measure)

        start_index = (start.to_i * self.beats_per_measure.to_i)-self.beats_per_measure.to_i-1
        end_index = (end_measure.to_i * self.beats_per_measure.to_i)-1
        i = start_index
        while i < end_index
            self.chords.delete_at(start_index)
            i+=1
        end
    end

    def get_measure_chords(int)
        arr = []
        self.measure[int.to_i -1].chords.each do |chord|
            hash = {
                value: chord.value,
                beats: chord.beats
            }
            arr << hash
        end
        arr
    end
    def transpose(key)
        self.progressions.each {|prog| prog.transpose_and_save(key)}
        self.key = key
    end

    def measure_format
        i = 1
        arr = []
        measure = []
        binding.pry
        self.chords.each do |chord|
            measure << chord.value
            if measure.count == self.beats_per_measure.to_i
                arr << "  #{i}. / #{measure.join(" , ")} /"
                measure = []
                i +=1
            end
            if chord == self.chords.last && measure.count != 0
                until measure.count == self.beats_per_measure.to_i
                    measure << " "
                end
                arr << "  #{i}. / #{measure.join(" , ")} /"
            end
        end
        arr
    end
end