class Board
	attr_reader :word, :tries, :board_drawing
	attr_accessor :covered_word, :discarded_letters, :won

	def initialize
		@word = get_word_from_dict
		@tries = 0
		@covered_word = "_" * @word.length
		@won = won
		@discarded_letters = []
	end

	def drawing
@drawing =
	[%{
         +-------+
         |       |
         |       |
         |       
         |
         |
         |
         |
         |},
     %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |  
         |      
         |     
         |    
         |   
         |},
     %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |      | |
         |      | |
         |       V
         |    
         |   
         |},   
         %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |  x===| |
         |      | |
         |       V 
         |    
         |   
         |},
     %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |  x===| |===x
         |      | |
         |       V 
         | 
         |   
         |},
     %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |  x===| |===x
         |      | |
         |     / V
         |    / /
         |   ---  
         |},
     %{
         +-------+
         |       |
         |       |
         |       _
         |      (_)
         |  x===| |===x
         |      | |
         |     / V \\
         |    / / \\ \\
         |   ---   ---
         |},
	 %{
              ____
             /    \\
            / X  X \\
            \\      /
             | .. |
             (----)
              \\__/
		}
]
	end

	def covered_word
		@covered_word
	end

	def print_covered_word
		@covered_word.length.times do |x|
			print "#{@covered_word[x]} "
		end
		puts
	end
	
	def won
		@word == covered_word
	end

	def word
		@word
	end

	def get_word_from_dict
		dict_terms = File.readlines("5desk.txt")
		random_word = nil
		loop do
			random_word = dict_terms[Random.rand(dict_terms.length)].chomp.downcase
			break if random_word.length > 5 and random_word.length < 12
		end
		return random_word
	end

	def guess letter
		if @word.include? letter
			@word.length.times do |x|
				if @word[x] == letter
					@covered_word[x] = letter
				end
			end
			message = "Well done."
		else
			@tries += 1
			@discarded_letters << letter unless @discarded_letters.include? letter
			message = "No, you're wrong. #{tries} tries left"
		end
		message
	end

	def save_game game, filename
		saved_game = YAML::dump game
		date = DateTime.now
		filename += " - #{date}"
		File.open("#{filename}.yml", 'w'){|game| game.write(saved_game)}
		filename
	end
end