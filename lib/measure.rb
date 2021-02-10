# class Measure 
#     attr_accessor :beats
#     attr_reader :chords
#     def initialize(num_of_beats)
#         self.beats = num_of_beats
#         @chords = []
#     end
#     def add_chords(array)
#         array.each do |chord| 
#             self.chords << chord
#         end
#     end

#     def valid_num_of_beats?(array)
#         self.beats >= array.inject {|sum, chord| sum + chord.beats}
#     end
#     def total_beats
#         self.chords.inject {|sum, chord| sum + chord.beats}
#     end

#     def measure_format
#         arr = []
#         chords.each do |chord|
#             self.beats.times{arr << chord.value}
#         end
#         "/ #{arr.join (" , ")} /"
#     end
# end