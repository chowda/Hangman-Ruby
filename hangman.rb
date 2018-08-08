class Hangman
  def initialize(target_word)
    @target_word = target_word.downcase
    @current_state = "_" * target_word.size
  end

  def current_state
    @current_state
  end

  def guess(character)
    # (0...@target_word.size).find_all { |i| @target_word[i] == 'a' } also works, but is slower
    # find_all     0.000137   0.000025   0.000162 (  0.000175)
    # enum_for     0.000068   0.000002   0.000070 (  0.000073)
    found_indexes = @target_word.enum_for(:scan,/#{character}/).map { Regexp.last_match.begin(0) }

    if found_indexes.any?
      found_indexes.each{|i| @current_state[i] = character }
    end
  end

  def solved?
    !@current_state.include?("_")
  end
end
