# frozen_string_literal: true

require 'debug'

require_relative 'player'
require_relative './colours'
require_relative './cpu'
require_relative './text'

# Basic game logic and operations
class Game
  attr_reader :hints
  attr_accessor :mode, :code

  include Text
  include Colours

  def initialize(mode = 'human')
    @code = []
    @mode = mode
    @turns = 12
    @guess = nil
    @gameover = false
  end

  def self.check_guess(guess, secret)
    black_peg = 0
    white_peg = 0
    secret.length.times do |i|
      if secret[i] == guess[i]
        black_peg += 1
      else
        secret.include?(guess[i]) ? white_peg += 1 : next
      end
    end
    # puts "Black pegs: #{black_peg} \nWhite pegs: #{white_peg}" unless Game.game_over?
    [black_peg, white_peg]
  end

  def generate_code
    4.times do |i|
      @code[i] = rand(1..6).to_s
    end
    @code = @code.join('')
    puts 'Code generated: ****'
    # puts @code
  end

  def play(player)
    loop do
      @guess = player.make_guess
      @turns -= 1
      player.guesses << @guess
      feedback = Game.check_guess(@guess, @code)

      matches = HINT_COLOURS['!'] * feedback[0]
      partial = HINT_COLOURS['?'] * feedback[1]
      miss_count = 4 - feedback.sum
      miss = HINT_COLOURS['x'] * miss_count
      if feedback == [4, 0]
        win(@mode)
        break
      end
      puts "Feedback for guess is #{matches}#{partial}#{miss}"
      player.record_feedback(feedback)
      @mode == '2' ? player.calc_next_guess(feedback, @guess) : next

      break if @gameover || @turns.zero?
    end
  end

  def win(mode)
    player = mode.capitalize
    print "#{@guess} is correct! #{player} solved it with #{@turns} left"
    @gameover
  end

  def self.game_over?
    if Game.code == @guess
      puts "Good job, the code #{Game.code} matches your guess #{@guess}. Game finished with #{@turns} turns left"
      @gameover = true
      true
    end
    false
  end

  def prompt(*args)
    print(*args)
    gets.chomp
  end
end
