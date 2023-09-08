# frozen_string_literal: true

require_relative './player'
require 'debug'

class CPU
  attr_accessor :guesses

  def initialize
    @first_guess = '1122'
    @possible_codes = ('1'..'6').to_a.repeated_permutation(4).to_a.map { |code| code.join('') }
    @impossible_codes = []
    @guesses = []
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

  def calc_next_guess(feedback, guess)
    puts 'Calculating next guess'
    if feedback == [0, 0]
      puts "Rejecting all options including #{guess}"
      @impossible_codes += guess.chars
      @possible_codes.reject! do |code|
        code.chars.any? { |digit| @impossible_codes.include?(digit) }
      end
    else
      puts 'Generating better options'
      @possible_codes.select! do |code|
        feedback = Game.check_guess(guess, code)
        feedback[0] == @feedback[0] && feedback[1] == @feedback[1]
      end
    end
    puts @possible_codes.length
    @next_guess = @possible_codes[0]
  end
end
