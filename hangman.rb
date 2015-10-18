require_relative 'Board'
require 'io/console'
require 'yaml'

def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
  ensure
    STDIN.echo = true
    STDIN.cooked!

  return input
end

def main
	puts "Welcome to the gallows, choose an option"
	puts "1)\tLoad game"
	puts "2\tNew game"
	option = gets.chomp.to_s.downcase

	case option
	when '1'
		system "clear"
		puts "Saved games:"
		puts
		games = File.open("saved_games.txt").read
		games_list = []

		games.each_line.with_index do |game, index|
			games_list << game.chomp
			puts "#{index+1})   #{game}"
		end
		puts "Choose the number of the game to load:  "
		game_to_load = gets.chomp.to_i
		game_to_load = YAML::load_file games_list[game_to_load-1] + ".yml"
		play game_to_load  

	when '2'
		board = Board.new()
		play board
	else
		puts "Choose a valid option."
	end
end

def play game
	board = game
	message = ''

	while board.tries > 0 do
		#puts board.drawing
		system("clear")
		puts board.inspect
		puts message
		puts "guesses left: #{board.tries}"
		board.print_covered_word
		print "Discarded letters:\t"
		board.discarded_letters.each{|letter| print "#{letter}  "}
		puts
		print "Guess a letter: (Esc to quit game)"
		#letter = gets.chomp.downcase
		letter = read_char
		
		if letter == "\e"
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
		puts "You've lost the game, the secret word is #{board.word.upcase}"
	end
end

main