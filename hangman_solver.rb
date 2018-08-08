class HangmanSolver
  attr_accessor :guesses

  def initialize(hangman)
    @hangman = hangman
    @guesses = []
    @wordlist = setup_wordlist(@hangman.current_state.size)
    @available_chars = ('a'..'z').to_a
  end

  def solve
    while @hangman.solved? == false
      make_guess()
      prune_wordlist(@hangman.current_state)
    end

    p "Congrats! We solved the puzzle in #{@guesses.size} guesses!"
  end

  def make_guess
    guess = find_likely_character()
    @available_chars.delete(guess)
    @guesses << guess
    @hangman.guess(guess)
  end

  private

  def find_likely_character
    return @available_chars.sample if @wordlist.empty?

    letter_counts = {}
    # Mapping over the word list, break each word into its characters.
    # Increment a hash of letters to track character counts.
    @wordlist.map{ |w|
      w.chars.each{ |c|
        letter_counts.has_key?(c) ? letter_counts[c] += 1 : letter_counts[c] = 1
      }
    }

    # This converts the hash into an array to sort based on hash value. It's in ascending order
    # so we pull from the end for the highest value. Character is index 0, count is index 1.
    letter_counts = letter_counts.sort_by{|k,v| v}

    # Remove any characters we have already guessed
    letter_counts.reject!{|l| @guesses.include?(l.first)}

    # Pick the remaining character with the highest count
    letter_counts.last.first
  end

  def prune_wordlist(state)
    # TODO: Instead of pruning the wordlist based on every available character each time,
    # detect which indexes changed between guesses and only purge based on any new changes.
    char_indexes = []
    state.each_char.with_index{|char, idx| char_indexes << [char, idx] if char != '_'}

    char_indexes.each do |char, idx|
      @wordlist.reject!{|w| w[idx] != char}
    end
  end

  def setup_wordlist(wordsize)
    File.readlines("/usr/share/dict/words", "\n")
      .map{|w| w.strip!}
      .select{|w| w.size == wordsize}
      .each{|w| w.downcase!}
  end
end
