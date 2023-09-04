class Game
  require_relative 'player'

  def initialize
    @code = Array.new(4)
    @hints = Array.new(4)
    @turns = 12
    @guess = nil
    @gameover = false
  end

  def check_guess(guess)
    match = 0
    partial = 0
    @code.length.times do |i|
      if @code[i] == guess[i]
        match += 1
      elsif @code.include?(guess[i])
        partial += 1
      end
    end
    if match == @code.length
      puts "Good job, the code #{@code} matches your guess #{guess}. Game finished with #{@turns} turns left"
      @gameover = true
    else
      puts "You got #{match} correct guesses and #{partial} numbers correct but in the wrong position"
    end
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
    loop do
      guess = prompt "Guess the code (#{@turns} left): "
      if guess.length != 4
        puts 'Please input 4 digits'
      elsif guess.match?(/\D/)
        puts 'All characters must be numeric'
      else
        @turns -= 1
        return guess
      end
    end
  end

  def prompt(*args)
    print(*args)
    gets.chomp
  end

  def play(player)
    loop do
      @guess = make_guess
      player.guesses << @guess
      check_guess(@guess)

      break if @gameover || @turns.zero?
    end
  end
end
game = Game.new
player = Player.new

game.generate_code

game.play(player)
