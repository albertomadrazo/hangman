require_relative 'Board'
require 'io/console'
require 'yaml'


def main
	puts "Welcome to the gallows, choose an option"
	option = show_options

	case option[0]
	when '1', 'n'
		board = Board.new()
		play board

	when '2', 'l'
		begin
			games = File.open("saved_games.txt").read
			show_saved_games games		
		rescue
			puts "You have not saved games yet."
			sleep 1
			board = Board.new
			play board
		end

	else
		puts "Choose a valid option."
	end
end

def show_options
	puts "1)   (N)ew game"
	puts "2)   (L)oad game"
	option = gets.chomp.to_s.downcase
end

def show_saved_games games
	system "clear"
	puts "   Saved games:"
	puts

	games_list = []
	
	games.each_line.with_index do |game, index|
		games_list << game.chomp
		puts "#{index+1})   #{game}"
	end

	puts
	puts "Choose the number of the game to load:  "
	game_to_load = gets.chomp.to_i
	game_to_load = YAML::load_file games_list[game_to_load-1] + ".yml"
	play game_to_load  
end

def play game
	board = game
	message = ''

	while board.tries < 7 do
		system("clear")
		puts board.drawing[board.tries]
		puts message
		board.print_covered_word
		puts
		print "Discarded letters:\t"
		board.discarded_letters.each{|letter| print "#{letter}  "}
		puts
		print "Guess a letter: (press 0 to quit game)  "
		letter = gets.chomp.downcase
		
		if letter == '0'
			puts "Do you want to save the game? (Y/N)"
			save = gets.chomp.downcase
			if save == 'y'
				name = board.covered_word
				filename = board.save_game board, name

				File.open("saved_games.txt", 'a'){|game| game.puts filename}
				system(exit)
			end

		elsif letter == "[a-zAZ]"
			letter = letter.chomp.downcase
		else
			puts letter
		end
		puts
		message = board.guess letter
		board.print_covered_word
		break if board.won
	end

	if board.won
		puts "You've won the game!" 
	else
		system "clear"
		puts board.drawing[board.tries]
		puts "You've lost the game, the secret word is #{board.word.upcase}"
	end
end

main