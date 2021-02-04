class CLI
    DELAY = .5
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

    def display_message(array,delay = false)
        array.each do |string|
            puts string
            sleep(DELAY) if delay == true
        end
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

    def get_input
        input = gets.chomp
        if input.downcase == "help"
            display_message(help_message)
            self.get_input
        end
        input
    end

    def main_menu
        display_message(self.mm_message, false)
        case get_input
        when "1"
        when "2"
        when "3"
        when "main"
            self.main_menu
        when "exit"
            self.exit_app
        else
            puts "Sorry, not a valid choice"
            display_message(help_message)
            self.main_menu
        end
    end



end