class Score
    attr_accessor :name, :artist
    attr_accessor :key, :beats_per_measure, :chords
    @@all = []
    def initialize()#attributes)
        # attributes.each {|key, value| self.send(("#{key}="), value)}
        # @measures = []
        @chords = []
    end

    # def add_empty_measures(num)
    #     num.to_i.times {self.chords << nil}
    # end
    #Returns an array of associated Progressions
    def progressions
        Progression.all.select {|prog| prog.scores.include?(self)}
    end

    #Adds new measures based off a progression, repeated 
    def add_chords_from_progression(progression, repeat =1)
        # count = 0
        # measure = nil
        
        # repeat.times {progression.chords.each do |chord|
        #         new_measure = measure ? self.measures.last : Measure.new(self.beats_per_measure)
        #         new_measure.chords << chord
        #         count += chord.beats.to_i
        #         measure = true
        #         if count >= self.beats_per_measure
        #             measure = nil
        #             count = 0
        #         end
        #         self.measures << new_measure if !self.measures.include?(new_measure)
        #     end
        # }
        repeat.times { 
            progression.chords.each do |chord|
                self.chords << chord 
            end
        }
    end
    def num_of_measures
        # self.chords.inject{|sum, el| sum + el.beats} /self.beats_per_measure
        (self.chords.count / self.beats_per_measure.to_f).ceil
    end

    def delete_measures(start, end_measure)
        # start_index = start.to_i - 1
        # end_index = end_measure.to_i
        # i = start_index
        # while i < end_index
        #     self.measures.delete_at(start_index)
        #     i+=1
        # end
        start_index = (start.to_i * self.beats_per_measure)-self.beats_per_measure-1
        end_index = (end_measure.to_i * self.beats_per_measure)-1
        i = start_index
        while i < end_index
            self.chords.delete_at(start_index)
            i+=1
        end
    end
    # def get_measure_by_number(measure_num, num_of_measures=1)
    #     i = measure_num.to_i - 1
    #     j = num_of_measures.to_i
    #     arr = []
    #     while i < i+j
    #         arr << self.measure[i] if self.measure[i]
    #         i+=1
    #     end
    #     arr
    # end

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
        # binding.pry
        self.progressions.each {|prog| prog.transpose_and_save(key)}
        self.key = key
    end

    def measure_format
        i = 1
        arr = []
        measure = []
        self.chords.each do |chord|
            measure << chord.value
            if measure.count == self.beats_per_measure
                arr << "  #{i}. / #{measure.join(" , ")} /"
                measure = []
                i +=1
            end
            if chord == self.chords.last && measure.count != 0
                until measure.count == self.beats_per_measure
                    measure << " "
                end
                arr << "  #{i}. / #{measure.join(" , ")} /"
            end
        end
        arr
    end
end