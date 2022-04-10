module Moves

end

module Navigation

    LETTERS = ('A'..'H').to_a
    NUMBERS = (1..8).to_a
    BOARD_UI = LETTERS.map { | l | NUMBERS.map { | n | "#{l}#{n}" } }.flatten

    def convert_back_to_front(index)
        converted = BOARD_UI[index]
        puts converted
    end

    def convert_front_to_back(coords)
        converted = BOARD_UI.index(coords)
        puts converted
    end

end

class Board
    attr_accessor :board
    include Navigation

    def initialize
        @board = make_board
    end

    def make_board
        Array.new(64, nil)
    end

    def display_board

    end

end



class Knight
    attr_accessor :position
    include Moves, Navigation
    STANDARD_MOVESET = [10, -15, -6, 17, 15, 6, -10, 17]

    def initialize(board, player = 1)
        @player = player
        @symbol = "K"
        @position = rand(0..63)
        board.board[@position] = @symbol
    end

    def move_piece(board, destination)
        board.board[@position] = nil
        @position = destination
        board.board[destination] = @symbol
    end

end


chess = Board.new
chess.make_board
horsey = Knight.new(chess)
puts horsey.position
puts horsey.convert_back_to_front(horsey.position)
horsey.move_piece(chess, 53)
puts horsey.position
puts horsey.convert_back_to_front(horsey.position)