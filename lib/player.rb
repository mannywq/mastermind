# frozen_string_literal: true

class Player
  attr_accessor :guesses

  def initialize
    @guesses = []
    @turns = 12
  end

  def make_guess
    guess = ''
    loop do
      guess = prompt "Guess the code (#{@turns} left): "
      break if valid_code?(guess)
    end
    @turns -= 1
    guess
  end

  def create_code
    code = ''
    loop do
      code = prompt 'Create a code for the computer to crack (4 digits): '
      break if valid_code?(code)
    end
    @turns -= 1
    code
  end

  def record_feedback(feedback)
    @feedback = feedback
  end

  private

  def prompt(*args)
    print(*args)
    gets.chomp
  end

  def valid_code?(code)
    if code.length != 4
      puts 'Please input 4 digits'
      false
    elsif code.match?(/\D/)
      puts 'All characters must be numeric'
      false
    else
      true
    end
  end
end
