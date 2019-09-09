require 'colorize'

# class Output
#     def green_string; "\e[31m#{self}\e[0m" end
#     def red_string; "\e[32m#{self}\e[0m" end
# end

module CodeThing

    def validate_code? code
        #checks if code input is valid
        code.length == 4 && code.all? { |digit| digit >=1 && digit <=6}
    end

    def generate_code
        @code = []
        for i in (0..3)
            @code[i] = rand(1..6)
        end
        @code
    end

end

class CodeMaker
    include CodeThing

    def set_secret_code
        #prompts code "MAKER" to insert the code
        #returns the code
        loop do
            puts "\nSet Secret Code:"
            #@secret_code = gets.chomp.split("").map{|num| num.to_i}
            @secret_code = gets.chomp.split("").map(&:to_i)
            break if validate_code? @secret_code
            puts "Error: Number must be 4 digits ranging between 1~6"
        end
        puts "Your Code is: #{@secret_code.join}"
        @secret_code
    end

end

class CodeBreaker
    include CodeThing

    def guess_secret_code
        #prompts code "BREAKER" to insert the code
        #returns the code
        loop do
            puts "Guess Secret Code:"
            @guess = gets.chomp.split("").map(&:to_i)
            break if validate_code? @guess
            puts "Error: Number must be 4 digits ranging between 1~6"
        end 
        @guess
    end
end

class Game

    def initialize
        @cm = CodeMaker.new
        @cb = CodeBreaker.new
        greet
        get_player_role
        instructions
        play
    end

    def greet
        #welcome message
        puts " "
        puts "\t\t\t- Welcome To The Mastermind Game -"
        puts ""
    end

    def get_player_role
        #prompts the player to choose his role
        loop do
            choice_msg = "\nPress 'm' if you want to be a 'Code-Maker' \n\tOR\nPress 'b' if you want to be a 'Code-Breaker'"
            puts choice_msg
            @player_choice = gets.chomp
            break if @player_choice.downcase == 'm' || @player_choice.downcase == 'b'
            puts "\n\t\tINAVLID INPUT..!!"
        end
        @player_choice.downcase
    end

    def instructions
        puts " "
        puts "\t\t\t- Instructions -"
        puts ""
        @player_choice.downcase == 'm'? code_maker_rules : code_breaker_rules
        puts "3. Each time you enter your guesses...."
        puts "   The computer will give you some hints"
        puts "   on whether your guess had correct digit,"
        puts "   incorrect digits or correct digits"
        puts "   that are in the incorrect position\n "
        puts "***************************************"
        puts "*********** GUIDES TO HINTS ***********"
        puts "***************************************"
        puts "======================================="
        puts "1. If you get a digit correct and it is"
        puts "   in the correct position, the digit "
        puts "   will be colored #{"green".green}"
        puts "2. If you get a digit correct but in the"
        puts "   wrong position, the digit will be colored white"
        puts "3. If you get the digit incorrect, the "
        puts "   digit will be colored #{"red".red}\n "
        puts "For example:"
        puts "If the secret code is:"
        puts "1523"
        puts "and your guess was:"
        puts "1562"
        puts "You will see the following result:"
        puts "#{"15".green}#{"6".red}2"
    end

    def code_maker_rules
        puts "1. You will create a 4 digits secret code."
        puts "   The code must be between 1 to 6."
        puts "2. The Computer will have 5 guesses to"
        puts "   try and crack your secret code. You win"
        puts "   if your secret code is not cracked"
    end

    def code_breaker_rules
        puts "1. You have to break the secret code in"
        puts "   order to win the game"
        puts "2. You are given 5 guesses to break the"
        puts "   code. The code ranges between 1 to 6"
        puts "   A number can be repeated more than once!"
    end

    def display_turns
        puts "\nAttempts: #{@turns}"
    end

    def no_attempts?
        @turns -= 1
        keinen_versuche = false

        if @turns == 0
            keinen_versuche = true
            puts "The Secret Code was #{@secret_code_copy.join}\nThe Code Maker wins.." if !player_win?
        end
        keinen_versuche
    end

    def give_hint(rateversuch)
        hint = ""
        code_judge = @secret_code_copy.dup

        @secret_code_copy.each_index do |i|
            if @secret_code_copy[i] == rateversuch[i]
                hint << rateversuch[i].to_s.green

                code_judge[i] = 0
            elsif code_judge.include? rateversuch[i]
                hint << rateversuch[i].to_s
            else
                hint << rateversuch[i].to_s.red
            end
        end
        puts "Hint: #{hint}."
    end

    def player_win?
        victory = false
        win_code = []

        @secret_code_copy.each_index do |i|
            if @secret_code_copy[i] == @guess_copy[i]
                win_code << @guess_copy[i]
            end
        end
        if win_code.length == 4
            puts "Code Cracked, Code Breaker wins"
            victory = true
        end   
        victory
    end

    def game_over?
       player_win? || no_attempts? 
    end

    def restart?
        loop do
            puts "\nPlay Again ??\n(Y/N)"
            @response = gets.chomp.upcase
            break if @response == 'Y' || @response == 'N'
            puts "\n\tInvalid Response"
        end

        if @response == 'Y'
            get_player_role
            play
        else
            puts "\n\tAu Revoir.. :)"
        end
    end 

    def play
        @turns = 5
        @secret_code_copy = @player_choice == 'm'? @cm.set_secret_code : @cm.generate_code
    
        loop do
            display_turns
            @guess_copy = @player_choice == 'b'? @cb.guess_secret_code : @cb.generate_code
            puts "Guess: #{@guess_copy.join}."
            give_hint(@guess_copy)
            break if game_over?
        end
        restart?
    end

end

new_game = Game.new


