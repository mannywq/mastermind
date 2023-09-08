# frozen_string_literal: true

module Colours
  CODE_COLOURS =
    {
      '1' => "\e[101m 1 \e[0m", # pink
      '2' => "\e[41m 2 \e[0m",  # red
      '3' => "\e[42m 3 \e[0m",  # green
      '4' => "\e[43m 4 \e[0m",  # yellow
      '5' => "\e[44m 5 \e[0m",  # blue
      '6' => "\e[45m 6 \e[0m"   # purple
    }.freeze

  HINT_COLOURS = {
    '?' => "\e[97m \u25CF \e[0m",
    '!' => "\e[32m \u25CF \e[0m",
    'x' => "\e[31m \u274C \e[0m"

  }.freeze

  def colored_numbers(number_array)
    number_array.map { |number| code_colors(number.to_s) }.join(' ')
  end
end
