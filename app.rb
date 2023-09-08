# frozen_string_literal: true

require_relative './lib/logic'
require 'debug'

game = Game.new('cpu')

game.welcome_screen

puts 'Pick a number to play as code breaker (human) or maker (CPU breaks)'
puts <<~HEREDOC

  ========================================================================
  1) Human
  2) CPU
  ========================================================================

HEREDOC

print 'Choose mode: '
mode = gets.chomp until %w[1 2].include?(mode)

game.mode = mode
if game.mode == '2'
  player = CPU.new
  human = Player.new
else
  player = Player.new
end

game.mode == '2' ? game.code = human.create_code : game.generate_code
game.play(player)
