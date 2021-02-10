require 'pry'
class Test
    
    def testing_1
        display([ "-----  TESTING  -----"])
    end

    def testing_2(message = nil)
        display(["-----  END #{message}  -----"])
    end

    def self.help_message 
        ["'help' To see a list of options", "'main' To return to the main menu", "'exit' To Exit out of the app"]
    end

##
##
## USER INTERACTION
##
##
    #Creates a standard format for displaying information to the user
    def display(arr)
        puts
        puts "----------" if arr.count > 1
        arr.each {| el | puts el } #Puts out each element from the array
        puts "----------" if arr.count > 1
        puts
    end

    #Handles user input and response
    def user_interaction(req,res=nil)
        input = self.request(req)
        res ? self.respond(input, res) : input
    end

    #Retrieves and validates user input
    def request(params)
        loop do 
            display(params[:prompt]) if params[:prompt] #Calls display with prompt if prompt is provided
            input = gets.chomp #Retrieves User input
            test_input = !!input.match(Regexp.new(params[:match])) || !params[:match] #Returns True if there isn't a match key, or if a Regexp is found, false otherwise
            self.display(params[:help_message]) if input == "help"
            break params[:keywords][input.downcase.to_sym].call if params[:keywords].keys.include?(input.downcase.to_sym) #Stops loop and breaks with method based on the keyword from input
            break input if test_input == true #Stops loop and returns the input if match is true
            display(params[:help_message]) #Displays a help message when input fails test
        end
    end

    #Change request paramaters, returns new parameters
    def request_params(add_hash={}, help=self.help_message)
        hash = {
            :keywords => { #Standard list of keywords. If user types any of the keywords, it should activates its coresponding method.
                main: method(:main_menu), #Returns to the Main Menu
                exit: method(:exit_app) #Exits out of App
            },
            :help_message => help
        }
        add_hash.merge(hash) #Returns the standard hash, combined with additional parameters in the add_hash
    end

    #Add Keywords and their methods to the request hash
    def add_keywords(hash, keywords)
        keywords.keys.each do |key|
            hash[:keywords][key] = keywords[key]
        end
        hash
    end

    #Multi-Choice Response
    def respond(input, params)
        index = input.to_i - 1 #Converts input to an index
        #Call the method at options input with or without an argument
        params[:arg] ? params[:options][index].call(params[:arg]) : params[:options][index].call
    end
 

    #Set up standard params for a multi-choice response
    def get_multi_choice_response(messages, options, arg=nil)
        max = options.count
        match = max < 10 ? "^([1-#{max}])$" : "^([1-#{max.to_s[0,1]}][0-#{max.to_s[1,1]}])$"
        help = ["Not a valid option, Please select a number between 1 and #{max}."]
        prompt = ["Please select a number between 1 and #{max}."]
        display(messages)
        hash = request_params({match: match, prompt: prompt}, help)
        res = {options: options, arg: arg}
        user_interaction(hash,{options: options, arg: arg})
    end 

    def test
        messages = ["1.Good Morning America!", "2. Test # 2"]
        options = [method(:testing_1),method(:testing_2)]
        self.get_multi_choice_response(messages, options)
    end
end



foo = Test.new
foo.test

class CLI
    DELAY = 0.05
    attr_reader :scores, :common_progressions
    def initialize(start=true)
        @scores = []
        @common_progressions = Scrapper.scrape_main_page
        # display_message(self.welcome_message, true)
        # self.main_menu if start
        display(self.welcome_message)
        self.main_menu if start
    end

    def self.help_message 
        ["'help' To see a list of options", "'main' To return to the main menu", "'exit' To Exit out of the app"]
    end

##
##
## USER INTERACTION
##
##
    #Creates a standard format for displaying information to the user
    def display(arr)
        puts
        puts "----------" if arr.count > 1
        arr.each do| el | #Puts out each element from the array
            puts el 
            sleep(DELAY)
        end 
        puts "----------" if arr.count > 1
        puts
    end

    #Handles user input and response
    def user_interaction(req=self.request_params,res=nil)
        input = self.request(req)
        res ? self.respond(input, res) : input
    end

    #Retrieves and validates user input
    def request(params)
        loop do 
            display(params[:prompt]) if params[:prompt] #Calls display with prompt if prompt is provided
            input = gets.chomp #Retrieves User input
            test_input = true  #Returns True if there isn't a match key, or if a Regexp is found, false otherwise
            test_input = !!input.match(Regexp.new(params[:match])) if params[:match]
            self.display(params[:help_message]) if input == "help"
            break params[:keywords][input.downcase.to_sym].call if params[:keywords].keys.include?(input.downcase.to_sym) #Stops loop and breaks with method based on the keyword from input
            break input if test_input == true #Stops loop and returns the input if match is true
            display(params[:help_message]) #Displays a help message when input fails test
        end
    end

    #Change request paramaters, returns new parameters
    def request_params(add_hash={}, help=self.help_message)
        hash = {
            :keywords => { #Standard list of keywords. If user types any of the keywords, it should activates its coresponding method.
                main: method(:main_menu), #Returns to the Main Menu
                exit: method(:exit_app) #Exits out of App
            },
            :help_message => help
        }
        add_hash.merge(hash) #Returns the standard hash, combined with additional parameters in the add_hash
    end

    #Add Keywords and their methods to the request hash
    def add_keywords(hash, keywords)
        keywords.keys.each do |key|
            hash[:keywords][key] = keywords[key]
        end
        hash
    end

    #Multi-Choice Response
    def respond(input, params)
        index = input.to_i - 1 #Converts input to an index
        #Call the method at options input with or without an argument
        params[:arg] ? params[:options][index].call(params[:arg]) : params[:options][index].call
    end
 

    #Set up standard params for a multi-choice response
    def get_multi_choice_response(messages, options, arg=nil)
        max = options.count
        match = max < 10 ? "^([1-#{max}])$" : "^([1-#{max.to_s[0,1]}][0-#{max.to_s[1,1]}])$"
        help = ["Not a valid option, Please select a number between 1 and #{max}."]
        prompt = ["Please select a number between 1 and #{max}."]
        display(messages)
        hash = request_params({match: match, prompt: prompt}, help)
        res = {options: options, arg: arg}
        user_interaction(hash,{options: options, arg: arg})
    end 



##
##
## PRIVIOUS VERSION
##
##





    def welcome_message
        ["Welcome to my app!","This app will help you construct a chord scafold for a music score." , "Here you can puruse commonly used chord progression, create your own progressions and build your own score based off the progressions of your choice."] 
    end
    def mm_message
        [
            "Main Menu",
            "1. Create a New Score",
            "2. Exit out of the Application",
            "--To make a selection just type its number--"
        ]
    end

    def help_message
        [
            "To return to the main menu type 'main'",
            "To exit out of the application, type 'exit'",
            "For help, type 'help'"
        ]
    end
    
    # def input_err_message(input)
    #     display_message(["Sorry, #{input} is not a valid choice"])
    #     display_message(help_message)
    # end


    # def display_message(array,delay = true)
    #     puts
    #     array.each do |string|
    #         puts string
    #         sleep(DELAY) if delay == true
    #     end
    #     puts
    # end

    def exit_app
        # display_message(["Sad to see you go!"])
        # exit
        display(["Sad to see you go!"])
        exit
    end

    # def get_input(params=nil)
    #     loop do
    #         puts
    #         if params
    #             puts params[:prompt] if params[:prompt]
    #         end
    #         input = gets.chomp
    #         if input != "help"
    #             if params
    #                 if params[:match] != nil
    #                     break input  if input.match(Regexp.new(params[:match]))
    #                 else
    #                     break input
    #                 end
    #             else
    #                 break input
    #             end
    #         end
    #         display_message(help_message)
    #     end
    # end

    def main_menu
        # display_message(self.mm_message)
        # self.response(mm_options)
        get_multi_choice_response(self.mm_message, mm_options)
    end

    def mm_options
        [method(:scores_menu), method(:exit_app)]
    end


    # def response(options,params = nil)
    #     input = self.get_input.downcase
    #     return self.main_menu if input == "main"
    #     return self.exit_app if input =="exit"
    #     options.each_with_index do |option, index| 
    #         if (index+1).to_s == input
    #             return option.call(params) if params
    #             return option.call
    #         end
    #     end
    #     input_err_message(input)
    #     self.response(options)
    # end

#
#SCORES
#
    def sm_options
        [method(:create_score), method(:nil_option), method(:main_menu)]
    end
    def nil_option
        display(["This item has not been added quite yet"])
    end

    def scores_menu
        # display_message(scores_message)
        # self.response(sm_options)
        get_multi_choice_response(scores_message, sm_options)
    end
    ####SONG MESSAGES###
    
    def edit_menu_message(score)
        [
            "1. Create Progression",
            "2. Add Progression to Song",
            "3. Delete Measures",
            "4. Edit Song Information",
            "5. See all measures",
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

    def song_message
        [
            "Song Options",
            "1. Change Name of Song",
            "2. Change Name of Artist",
            "3. Change Key",
            "4. Delete Song"
        ]
    end
    def scores_message
        ["SCORES", "1. Create a New Score", "2. Open Score", "3. Main Menu"]
    end
    ########

    ##Song Callback functions##

    def song_options
        [method(:change_name), method(:change_artist), method(:change_key), method(:delete_song)]
    end
    def edit_score_options
        [method(:make_progression),method(:add_progression),method(:delete_measures),method(:edit_song), method(:display_all_measures)]
    end

    #Song Methods#
    def edit_song(score)
        # display_message(song_message)
        # response(song_options,score)
        get_multi_choice_response(song_message, song_options,score)
        self.edit_score_menu(score)
    end
    def change_name(score)
        # display_message(["Current Name",score.name])
        # input = get_input({prompt: "What would you like to rename this song to?"})
        display(["Current Name",score.name])
        input = user_interaction(request_params({prompt: ["What would you like to rename this song to?"]}))
        score.name = input
        edit_score_menu(score)
    end
    def change_artist(score)
        # display_message(["Current Artist",score.artist])
        # input = get_input({prompt: "What would you like to rename the Artist to?"})
        display(["Current Artist",score.artist])
        input = user_interaction(request_params({prompt: ["What would you like to rename the Artist to?"]}))
        score.artist = input
        edit_score_menu(score)
    end
    def change_key(score)
        # display_message(["Current key:#{score.key}"])
        # input = get_input({prompt: "What would you like to change the Key to?", match: "[A-G]"}) 
        display(["Current key:  #{score.key}"])
        params = request_params({prompt: ["What would you like to change the Key to?"], match: "^([A-G])$"})
        input = user_interaction(params)
        score.transpose(input)
        edit_score_menu(score)
    end
    def delete_song(score)
        # display_message(["Delete Song: #{score.name}"])
        # input = get_input({prompt: "Are you sure you want to delete? y/n"})
        display(["Delete Song: #{score.name}"])
        params = request_params({prompt: ["Are you sure you want to delete? y/n"], match: "^([yn])$"})
        input = user_interaction(params)
        input == 'y' ? self.scores_menu : self.edit_score_menu(score)
    end

    def edit_score_menu(score)
        # display_message(score_information(score))
        # display_message(edit_menu_message(score))
        # self.response(edit_score_options,score)
        display(score_information(score))
        get_multi_choice_response(edit_menu_message(score), edit_score_options, score)
    end

    def get_song_key
        # input = self.get_input({prompt: "What is the key of the song?", match: "[A-G]"})
        params = request_params({
            prompt: ["What is the key of the song?"], 
            match: "^([A-G])$",
            help_message: ["Input should be an uppercase letter between A-G."]
        })
        input = user_interaction(params)
    end
    
    def create_score
        score = Score.new
        # score.name = self.get_input({prompt: "What's the name of the Song?"})
        # score.artist = self.get_input({prompt: "What is the artist name?"})
        # score.beats_per_measure = self.get_song_bpm.to_i
        # score.key = self.get_song_key

        score.name =  self.user_interaction(request_params({prompt: ["What's the name of the Song?"]}))
        score.artist = self.user_interaction(request_params({prompt: ["What is the artist name?"]}))
        score.beats_per_measure = self.get_song_bpm
        score.key = self.get_song_key
        self.scores << score
        self.edit_score_menu(score)
    end

    def get_song_bpm
        # input = self.get_input({prompt:"How many beats per measure?", match: "^[1-9]+$"})
        # if !input.to_i.between?(1,16)
        #     display_message(["BPM should be between 1-16"])
        #     self.get_song_bpm
        # end
        # input
        params = request_params({
            prompt: ["How many beats per measure?"], 
            match: "^([1-9])|([1][0-6])$",
            help_message: ["BPM should be between 1-16."]
        })
        self.user_interaction(params)
    end

    #
    #Working With Chords
    #
        ####CHORD MESSAGES####
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
    
    #
    # Display Score Infomation
    #


    def display_progressions(arr,score=nil)
        i = 1
        # display_message(["-----", "User Progressions", "------"])
        display(["-----", "User Progressions", "------"])
        arr.each do |pro|
            puts "#{i}. USER PROGRESSION"
            # score ? display_message(pro.progression_list(score.beats_per_measure)) : display_message(pro.progression_list)
            score ? display(pro.progression_list(score.beats_per_measure)) : display(pro.progression_list)
            i+=1
        end
        self.display_common_progs(score, i)
    end
    def display_common_progs(score = nil, i =1)
        progs = create_common_progressions(score)
        # display_message(["-----", "Common Chord Progressions from the Web", "------"])
        display(["-----", "Common Chord Progressions from the Web", "------"])
        progs.each do |pro|
            puts "#{i}. COMMON PROGRESSION"
            # score ? display_message(pro.progression_list(score.beats_per_measure)) : display_message(pro.progression_list)
            score ? display(pro.progression_list(score.beats_per_measure)) : display(pro.progression_list)
            i+=1
        end
    end
    def create_common_progressions(score=nil)
        arr = []
        key = score ? score.key : "C"
        bpm = score ? score.beats_per_measure : 4
        self.common_progressions.each do|c|
            prog = Progression.new(key)
            prog.save
            c.each {|scale| prog.add_chord(scale, bpm)}
            arr << prog
        end
        arr
    end

    def display_all_measures(score)
        binding.pry
        measures = score.measure_format
        # display_message([score.name, "MEASURES"])
        # display_message(measures)
        display([score.name, "MEASURES"] + measures)
        edit_score_menu(score)
    end

        ########

    #CHORD METHODS#

    def delete_measures(score)
        display(["Choose which measures to delete?"])
        # s_m = get_input({prompt: "Starting measure?", match: "[0-9]+"})
        # e_m = get_input({prompt: "Ending measure?", match: "[0-9]+"})
        s_m = user_interaction(request_params({prompt: ["Starting measure?"], match: "^[0-9]+$"}))
        e_m = user_interaction(request_params({prompt: ["Ending measure?"], match: "^[0-9]+$"}))

        score.delete_measures(s_m,e_m)
        self.display_all_measures(score)
        self.edit_score_menu(score)
    end

    def add_progression(score)
        progressions = Progression.get_progressions_from_score(score)
        display_progressions(progressions, score)
        all_prog = progressions + create_common_progressions(score)
        # choice = get_input({prompt: "Please choose a progression number", match: "[0-9]+"})
        choice = user_interaction(request_params({prompt: ["Please choose a progression number"], match: "^[0-9]+$"}))
        all_prog[choice.to_i-1].add_score( self) if !all_prog[choice.to_i-1].scores.include?(self)

        repeat = user_interaction(request_params({prompt: ["How many times would you like this progression to repeat?"], match: "^[0-9]+$"}))
        score.add_chords_from_progression(all_prog[choice.to_i-1],repeat.to_i)
        # puts "Added Measures"
        display(["Measures added to score"])
        binding.pry
        self.display_all_measures(score)
        self.scores_menu
    end

    def make_progression(score)
        prog = Progression.new(score.key)
        # display_message(create_progression_message)
        display(create_progression_message)
        self.create_prog(prog,score)
        edit_score_menu(score)
    end

    def create_prog(progression,score)
        chords = Chord.chords.keys
        params = request_params({
            prompt: ["What chord would you like to add? - Type 'stop' to finish the progression"],
            match: "^([1-7])(-)(([0-9])|(1[0-6]))|(stop)$",
            help_message: ["Please use chord - beats notation (ie 1-4)"]
        })
        loop do 
            # input = get_input({prompt: "What chord would you like to add? - Type 'stop' to finish the progression"})
            input = user_interaction(params)
            break input if input == "stop"
            # if input.match(/[-]/)
            #     string_arr = input.split("-")
            #     progression.add_chord(chords[string_arr[0].strip.to_i - 1], string_arr[1].strip.to_i)
            #     puts "#{progression.chords.last.value} - #{string_arr[1].to_i} beats"
            # else
            #     puts "Please use chord - beats notation (ie 1-4)"
            # end
            string_arr = input.split("-")
            progression.add_chord(chords[string_arr[0].strip.to_i - 1], string_arr[1].strip.to_i)
            puts "#{progression.chords.last.value} - #{string_arr[1].to_i} beats"
        end
        self.save_progression(progression,score)
    end

    def save_progression(progression, score)
        # display_message(progression.chord_values)
        binding.pry
        display(progression.chord_values)
        params = request_params({prompt: ["Would you like to save this progression? y/n"], match: "^[yn]$"})
        # save_prog = get_input({prompt: "Would you like to save this progression? y/n"})
        save_prog = user_interaction(params)
        if save_prog == "y"
            progression.add_score(score)
            progression.save
            display( ["Progression saved!"])
        end
    end

end