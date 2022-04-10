module Moves

end

class Board
    attr_accessor :board

    LETTERS = ('A'..'H').to_a
    NUMBERS = (1..8).to_a
    BOARD_UI = LETTERS.map { | l | NUMBERS.map { | n | "#{l}#{n}" } }.flatten

    def initialize
        @board = make_board
    end

    def make_board
        Array.new(64) { | i | i += 1 }
    end

    def display_board
        
    end

    def convert_back_to_front(index)
        converted = BOARD_UI[index]
        puts converted
    end

    def convert_front_to_back(coords)
        converted = BOARD_UI.index(coords)
        puts converted
    end

end



class Knight
    attr_accessor :position
    include Moves
    ALLOWED_MOVES = [10, -15, -6, 17, 15, 6, -10, 17]

    def initialize(player = 1)
        @position = @board.sample
        @player = player
    end

end


chess = Board.new
chess.make_board
chess.convert_back_to_front(3)
chess.convert_front_to_back("C7")
