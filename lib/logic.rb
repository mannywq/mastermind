require 'debug'

require_relative 'player'
require_relative './colours'
require_relative './cpu'

class Game
  attr_reader :hints
  attr_accessor :code

  include Colours

  def initialize(mode)
    @mode = mode
    @code = Array.new(4)
    @hints = { match: 0, partial: 0 }
    @turns = 12
    @guess = nil
    @gameover = false
  end

  def check_guess(guess)
    @hints.transform_values! { 0 }
    @code.length.times do |i|
      if @code[i] == guess[i]
        @hints[:match] += 1
      else
        @code.include?(guess[i]) ? @hints[:partial] += 1 : next
      end
    end
    unless game_over?
      # puts "You got #{@hints[:match]} correct guesses and #{@hints[:partial]} numbers correct but in the wrong position"
    end
    @hints
  end

  def generate_code
    @code.length.times do |i|
      @code[i] = rand(1..6)
    end
    @code = @code.join('')
    puts 'Code generated: ****'
    puts @code
  end

  def play(player)
    loop do
      @guess = player.make_guess
      @turns -= 1
      player.guesses << @guess
      feedback = check_guess(@guess)
      puts "Feedback for guess is #{feedback}"
      player.record_feedback(feedback)
      @mode == 'cpu' ? player.calc_next_guess(self) : next

      break if @gameover || @turns.zero?
    end
  end

  private

  def prompt(*args)
    print(*args)
    gets.chomp
  end

  def game_over?
    if @code == @guess
      puts "Good job, the code #{@code} matches your guess #{@guess}. Game finished with #{@turns} turns left"
      @gameover = true
      true
    end
    false
  end
end

game = Game.new('cpu')
player = CPU.new
human = Player.new

game.code = human.create_code
game.play(player)
debugger
