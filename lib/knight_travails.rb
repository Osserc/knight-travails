module Moves

    def move_piece(board, destination)
        if check_legality(destination)
            board.board[@position] = " "
            @position = destination
            board.board[destination] = self
        else
            puts "Illegal move."
        end
    end

    def check_legality(destination)
        moves = define_moveset
        differential = destination - @position
        return true if moves.include?(differential)
        return false
    end

    def define_moveset
        case self.class.name
        when "Knight"
            moves = self.class::STANDARD_MOVESET
        else
            puts "Gombloddo"
        end
    end

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
        Array.new(64, " ")
    end

    def display_board
        i = 0
        b = 0
        print "   | " + NUMBERS.join(" | ").to_s + " |\n"
        print "---+---+---+---+---+---+---+---+---+\n"
        until i == 8 && b == 64
            # row = @board.slice(b, 8)
            # row.map! do | element |
            #     if element.class.ancestors.include?(Piece)
            #         self.symbol
            #     else
            #         element
            #     end
            # end
            print " " + LETTERS[i] + " | " + @board.slice(b, 8).map { | element | element.class.ancestors.include?(Piece) ? element.symbol : element }.join(" | ").to_s + " |\n"
            print "---+---+---+---+---+---+---+---+---+\n"
            i += 1
            b += 8
        end
    end

end

# print " " + LETTERS[i] + " | " + @board.slice(b, 8).map { | element | element = self.@symbol if element.class.name == "Piece" }.join(" | ").to_s + " |\n"
# print " " + LETTERS[i] + " | " + @board.slice(b, 8).join(" | ").to_s + " |\n"

class Piece

end

class Knight < Piece
    attr_accessor :position
    attr_reader :symbol
    include Moves, Navigation
    STANDARD_MOVESET = [10, -15, -6, 17, 15, 6, -10, 17]

    def initialize(board, player = 1)
        @player = player
        @symbol = "K"
        @position = rand(0..63)
        board.board[@position] = self
    end

end


chess = Board.new
chess.make_board
horsey = Knight.new(chess)
chess.display_board
puts horsey.position
puts horsey.convert_back_to_front(horsey.position)
# horsey.move_piece(chess, 35)
# chess.display_board
# puts horsey.position
# puts horsey.convert_back_to_front(horsey.position)