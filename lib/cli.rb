class CLI
    DELAY = 0.05
    attr_reader :scores
    def initialize
        @scores = []
        puts
        display_message(self.welcome_message, true)
        puts
        self.main_menu
    end

    def welcome_message
        ["Welcome to my app!","This app help you construct a chord scafold for a music score." , "Here you can puruse commonly used chord progression, create your own progressions and build your own score based off the progressions of your choice."] 
    end
    def mm_message
        [
            "Main Menu",
            "1. See and Learn about Common Chord Progressions",
            "2. Create a New Score",
            "3. Exit out of the Application",
            "--To make a selection just type its number--"
        ]
    end
    
    def exit_app
        display_message(["Sad to see you go!"])
    end

    def help_message
        [
            "To return to the main menu type 'main'",
            "To exit out of the application, type 'exit'",
            "For help, type 'help'"
        ]
    end
    def input_err_message(input)
        display_message(["Sorry, #{input} is not a valid choice"])
        display_message(help_message)
    end

    def scores_message

        [
            "1. Create a New Score",
            "2. Open a Score",
            "3. Return to Main Menu"
        ]
    end

    def display_message(array,delay = true)
        puts
        array.each do |string|
            puts string
            sleep(DELAY) if delay == true
        end
        puts
    end


    def get_input(prompt=nil)
        # puts
        # puts prompt if prompt
        # input = gets.chomp
        # if input.downcase == "help"
        #     display_message(help_message)
        #     input = nil
        #     self.get_input(prompt)
        # end

        loop do
            puts
            puts prompt if prompt
            input = gets.chomp
            break input if input != "help"
            display_message(help_message)
        end

        # input
    end

    def main_menu
        display_message(self.mm_message)
        self.response(mm_options)
    end

    def mm_options
        [
            method(:common_chords_menu),
            method(:scores_menu),
            method(:exit_app)
        ]
    end

    def sm_options
        [
            method(:create_score)
        ]
    end

    #Scores Main Menu
    def scores_menu
        display_message(scores_message)
        self.response(sm_options)
    end
         
    def common_chords_menu
        puts "common chords"
        self.main_menu
    end

    def get_measures
        input = self.get_input("How many measures are in this song?")
        if input.to_i < 0 || input.match(/[a-z,A-Z]/)
            display_message(["Number of measures should be 0 or greater"])
            self.get_measures
        end
        input
    end

    def get_song_bpm
        input = self.get_input("How many beats per measure?")
        if !input.to_i.between?(1,16)
            display_message(["BPM should be between 1-16"])
            self.get_song_bpm
        end
        input
    end

    def get_song_key
        input = self.get_input("What is the key of the song?")
        if !input.upcase.match(/[A-G]/)
            display_message(["Key should be a letter between A and G"])
            self.get_song_key
        end
        input
    end

    def create_score
        score = Score.new
        score.name = self.get_input("What's the name of the Song?")
        score.artist = self.get_input("What is the artist name?")
        score.beats_per_measure = self.get_song_bpm
        score.key = self.get_song_key
        score.add_empty_measures(self.get_measures)
        self.scores << score
        self.edit_score_menu(score)
    end

    def edit_menu_message(score)
        [
            "1. Create Progression",
            "2. Add Progression to Song",
            "3. Add Measure",
            "4. Edit Measure",
            "5. Edit Song Information",
            "--To make a selection just type its number--"
        ]
    end

    def score_information(score)
        [
            "SCORE INFORMATION",
            "Name: #{score.name}",
            "Artist: #{score.artist}",
            "Key: #{score.key}",
            "Beats Per Meausure: #{score.beats_per_measure}",
            "Number of Measures: #{score.num_of_measures}"
        ]
    end

    def create_progression_message
        [
            "PROGRESSION",
            "1. I - Major (Root, iii, V)",
            "2. ii - Minor (ii, iv, Vi)",
            "3. iii - Minor (iii, V, Vii)",
            "4. iv - Major (iv, Vi, Root)",
            "5. V - Major (V, Vii, ii)",
            "6. Vi - Minor (Vi, Root, iii)",
            "7. Vii - Minor (Vii, ii, iv)",
            "Choose a chord and number of beats seperated by a '-'",
            "Example: 1-4 (I chord for 4 beats)"
        ]
    end

    def edit_score_options
        [method(:make_progression),nil,nil,nil,nil]
    end
    def edit_score_menu(score)
        display_message(score_information(score))
        display_message(edit_menu_message(score))
        self.response(edit_score_options,score)
    end

    def make_progression(score)
        prog = Progression.new(score.key)
        display_message(create_progression_message)
        self.create_prog(prog,score)
        edit_score_menu(score)
    end

    def create_prog(progression,score)
        chords = ["I", "ii", "iii", "iv", "V", "Vi", "Vii"]
        input = get_input("What chord would you like to add? - Type 'stop' to finish the progression")
        if input.downcase != "stop"
            string_arr = input.split("-")
            progression.add_chord(chords[string_arr[0].strip.to_i - 1], string_arr[1].strip.to_i)
            puts "#{progression.chords.last.value} - #{progression.chords.last.beats} beats"
            create_prog(progression,score)
        end
        display_message(progression.chord_values)
        input = get_input("Would you like to save this progression? yes/no")
        progression.add_score(score) if input == "yes"
    end

    # Multi-Choice input and response method, implements the callback function if the input matches the index plus 1
    def response(options,params = nil)
        input = self.get_input.downcase
        return self.main_menu if input == "main"
        return self.exit_app if input =="exit"
        options.each_with_index do |option, index| 
            if (index+1).to_s == input
                return option.call(params) if params
                return option.call
            end
        end
        input_err_message(input)
        self.response(options)
    end
end