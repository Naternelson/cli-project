class CLI
    DELAY = 0.05
    def initialize
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
        puts
        puts "Sad to see you go!"
        puts
    end

    def help_message
        [
            "",
            "To return to the main menu type 'main'",
            "To exit out of the application, type 'exit'",
            "For help, type 'help'",
            ""
        ]
    end
    def input_err_message(input)
        display_message(["Sorry, #{input} is not a valid choice"])
        display_message(help_message)
    end

    def scores_message
        [
            "",
            "1. Create a New Score",
            "2. Open a Score",
            "3. Return to Main Menu"
        ]
    end

    def display_message(array,delay = true)
        array.each do |string|
            puts string
            sleep(DELAY) if delay == true
        end
    end


    def get_input
        puts
        input = gets.chomp
        if input.downcase == "help"
            display_message(help_message)
            input = self.get_input
        end
        input
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
    def scores_menu
        display_message(scores_message)
        input = get_input
    end
        
    def common_chords_menu
        puts "common chords"
        self.main_menu
    end

    #Multi-Choice input and response method, implements the callback function if the input matches the index plus 1
    def response(options)
        input = self.get_input.downcase
        return self.main_menu if input == "main"
        return self.exit_app if input =="exit"
        options.each_with_index {|option, index| return option.call if (index+1).to_s == input}
        input_err_message(input)
        self.response(options)
    end
end