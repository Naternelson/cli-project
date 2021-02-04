class CLI
    DELAY = 3
    def initialize
        puts
        display_message(self.class.welcome_message)
        puts
        display_message(self.class.main_menu,false)
    end

    def self.welcome_message
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

    def display_message(array,delay = true)
        array.each do |string|
            puts string
            sleep(DELAY) if delay == true
        end
    end


end