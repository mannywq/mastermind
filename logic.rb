class Game
  require_relative 'player'

  def initialize
    @code = Array.new(4)
    @hints = Array.new(4)
    @turns = 12
    @guess = nil
    @gameover = false
    @match = 0
    @partial = 0
  end

  def check_guess(guess)
    @code.length.times do |i|
      if @code[i] == guess[i]
        @match += 1
      else
        @code.include?(guess[i]) ? @partial += 1 : next
      end
    end
    game_over?
  end

  def generate_code
    @code.length.times do |i|
      @code[i] = rand(1..6)
    end
    @code = @code.join('')
    puts 'Code generated: ****'
    puts @code
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

  def play(player)
    loop do
      @guess = make_guess
      player.guesses << @guess
      check_guess(@guess)

      break if @gameover || @turns.zero?
    end
  end

  private

  def prompt(*args)
    print(*args)
    gets.chomp
  end

  def game_over?
    if @match == @code.length
      puts "Good job, the code #{@code} matches your guess #{@guess}. Game finished with #{@turns} turns left"
      @gameover = true
    else
      puts "You got #{code} correct guesses and #{@partial} numbers correct but in the wrong position"
    end
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
game = Game.new
player = Player.new

game.generate_code

game.play(player)
