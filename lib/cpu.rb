require_relative './player'

class CPU
  attr_accessor :guesses

  def initialize
    @first_guess = '1122'
    @possible_codes = ('1'..'6').to_a.repeated_permutation(4).to_a.map { |code| code.join('') }
    @guesses = []
    @feedback = {}
    @num_guesses = 0
    @next_guess = nil
  end

  def make_guess
    if @num_guesses.zero?
      puts 'First guess is 1122!'
      guess = @first_guess
    elsif @possible_codes.length == 1
      puts 'Only one option left'
      guess = @possible_codes[0].to_s
    elsif !@next_guess.nil?
      guess = @next_guess
    else
      guess = @possible_codes.sample
    end
    @num_guesses += 1

    puts "Computer is guessing: #{guess}"
    puts "Remaining combinations: #{@possible_codes.to_a.length}"
    guess
  end

  def record_feedback(feedback)
    @feedback = feedback
  end

  def calc_next_guess(game)
    puts 'Calculating next guess'
    if @feedback.values.all? { |v| v == 0 }
      puts "Rejecting all options including #{@guesses[-1]}"
      @possible_codes.reject! do |code|
        code.chars.any? { |digit| guesses[-1].include?(digit) }
      end
    else
      puts "Selecting all other options with feedback #{@feedback}"
      @possible_codes.select! do |code|
        game.check_guess(code) == @feedback
      end

    end
    @next_guess = @possible_codes.sample
  end
end
