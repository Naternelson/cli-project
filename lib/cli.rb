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


    def get_input(params=nil)
        loop do
            puts
            if params
                puts params[:prompt] if params[:prompt]
            end
            input = gets.chomp
            if input != "help"
                if params
                    if params[:match] != nil
                        break input  if input.match(Regexp.new(params[:match]))
                    end
                else
                    break input
                end
            end
            display_message(help_message)
        end
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
        input = self.get_input(prompt: "How many measures are in this song?")
        if input.to_i < 0 || input.match(/[a-z,A-Z]/)
            display_message(["Number of measures should be 0 or greater"])
            self.get_measures
        end
        input
    end

    def get_song_bpm
        input = self.get_input({prompt:"How many beats per measure?"})
        if !input.to_i.between?(1,16)
            display_message(["BPM should be between 1-16"])
            self.get_song_bpm
        end
        input
    end

    def get_song_key
        input = self.get_input({prompt: "What is the key of the song?"})
        if !input.upcase.match(/[A-G]/)
            display_message(["Key should be a letter between A and G"])
            self.get_song_key
        end
        input
    end

    def create_score
        score = Score.new
        score.name = self.get_input({prompt: "What's the name of the Song?"})
        score.artist = self.get_input({prompt: "What is the artist name?"})
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
            "3. Delete Measures",
            "4. Edit Song Information",
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
    def song_message
        [
            "Song Options",
            "1. Change Name of Song",
            "2. Change Name of Artist",
            "3. Change Key",
            "4. Delete Song"
        ]
    end
    def song_options
        [method(:change_name), method(:change_artist), method(:change_key), method(:delete_song)]
    end
    def edit_score_options
        [method(:make_progression),method(:add_progression),method(:delete_measures),method(:edit_song),nil]
    end
    def edit_song(score)
        display_message(song_message)
        response(song_options,score)
        self.edit_score_menu(score)
    end
    def change_name(score)
        display_message(["Current Name",score.name])
        input = get_input({prompt: "What would you like to rename this song to?"})
        score.name = input
        edit_score_menu(score)
    end
    def change_artist(score)
        display_message(["Current Artist",score.artist])
        input = get_input({prompt: "What would you like to rename the Artist to?"})
        score.artist = input
        edit_score_menu(score)
    end
    def change_key(score)
        display_message(["Current key",score.key])
        input = get_input({prompt: "What would you like to rename the Artist to?", match: "[A-G]"}) 
        score.transpose
        edit_score_menu(score)
    end
    def delete_song(score)
        display_message(["Delete Song: #{score.name}"])
        input = get_input({prompt: "Are you sure you want to delete?"})
        input == 'y' ? self.scores_menu : self.edit_score_menu(score)
    end
    def edit_score_menu(score)
        display_message(score_information(score))
        display_message(edit_menu_message(score))
        self.response(edit_score_options,score)
    end

    def delete_measures(score)
        puts "Choose which measures to delete?"
        s_m = get_input({prompt: "Starting measure?", match: "[0-9]+"})
        e_m = get_input({prompt: "Ending measure?", match: "[0-9]+"})
        score.delete_measures(s_m,e_m)
        self.display_all_measures(score)
        self.edit_score_menu(score)
    end

    def add_progression(score)
        progressions = Progression.get_progressions_from_score(score)
        display_progressions(progressions)
        choice = get_input({prompt: "Please choose a progression number", match: "[0-9]+"})
        repeat = get_input({prompt: "How many times would you like this progression to repeat?", match: "[0-9]+"})
        measure_num = score.num_of_measures == 0 ? 0 : get_input({prompt: "What measure would you like to start from?", match: "[0-9]+"})
        score.add_measures_from_progression(progressions[choice.to_i-1],repeat.to_i)
            puts "Added Measures"
        self.display_all_measures(score)
        self.scores_menu
    end

    def get_prog_choice
        binding.pry
        input = get_input({prompt: "Please choose a progression number", match: "[0-9]+"})
    end
    def make_progression(score)
        prog = Progression.new(score.key)
        display_message(create_progression_message)
        self.create_prog(prog,score)
        edit_score_menu(score)
    end

    def create_prog(progression,score)
        chords = ["I", "ii", "iii", "iv", "V", "Vi", "Vii"]
        loop do 
            input = get_input({prompt: "What chord would you like to add? - Type 'stop' to finish the progression"})
            break input if input == "stop"
            if input.match(/[-]/)
                string_arr = input.split("-")
                progression.add_chord(chords[string_arr[0].strip.to_i - 1], string_arr[1].strip.to_i)
                puts "#{progression.chords.last.value} - #{progression.chords.last.beats} beats"
            else
                puts "Please use chord - beats notation (ie 1-4)"
            end
        end
        self.save_progression(progression,score)
    end

    def save_progression(progression, score)
        display_message(progression.chord_values)
        save_prog = get_input("Would you like to save this progression? yes/no")
        if save_prog.downcase == "yes"
            progression.add_score(score)
            progression.save
            puts "Progression saved"
        end
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

    def display_progressions(arr)
        # binding.pry
        arr.each_with_index do |pro,i|
            puts "#{i+1}. PROGRESSION"
            self.display_measures_from_arr(pro.progression_list)
            puts
        end
    end

    def display_all_measures(score)
        measures = score.measures.collect {|m| m.measure_format}
        display_message([score.name, "MEASURES"])
        display_measures_from_arr(measures)
        edit_score_menu(score)
    end

    def display_measures_from_arr(arr, count =arr.count)
        i = 0
        puts
        while i < count
            puts "    #{i+1}. #{arr[i]} "
            i+=1
            sleep(DELAY)
        end
        puts "..." if arr.count > count 
    end
end