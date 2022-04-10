module Border
    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
end

module Knight_Limitations
    UPPER_BOUND = (9..14).to_a
    UPPER_LIMITATIONS = [-17, -15]
    LEFT_BOUND = [9, 17, 25, 33, 41, 49]
    LEFT_LIMITATIONS = [-10, 6]
    RIGHT_BOUND = [14, 22, 30, 38, 46, 54]
    RIGHT_LIMITATIONS = [-6, 10]
    LOWER_BOUND = (49..54).to_a
    LOWER_LIMITATIONS = [17, 15]

end

module Moves
    include Border, Knight_Limitations
    def move_piece(board, destination)
        if check_legality(destination)
            board.board[@position] = " "
            @position = destination
            board.board[destination] = self
        else
            puts "Illegal move."
        end
    end

    def define_moveset
        case self.class.name
        when "Knight"
            moves = self.class::STANDARD_MOVESET
            moves = check_borders(moves)
        else
            puts "Gombloddo"
        end
    end

    def check_legality(destination)
        moves = define_moveset
        differential = destination - @position
        return true if moves.include?(differential)
        return false
    end

    def check_borders(moves)
        moves -= UPPER_LIMITATIONS if TOP_BORDER.include?(self.position) || UPPER_BOUND.include?(self.position)
        moves -= LEFT_LIMITATIONS if LEFT_BORDER.include?(self.position) || LEFT_BOUND.include?(self.position)
        moves -= RIGHT_LIMITATIONS if RIGHT_BORDER.include?(self.position) || RIGHT_BOUND.include?(self.position)
        moves -= LOWER_LIMITATIONS if BOTTOM_BORDER.include?(self.position) || LOWER_BOUND.include?(self.position)
        moves
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
    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(board, player = 1)
        @player = player
        @symbol = "K"
        @position = 17
        # @position = rand(0..63)
        board.board[@position] = self
    end

end



chess = Board.new
chess.make_board
horsey = Knight.new(chess)
chess.display_board
puts horsey.position
puts horsey.convert_back_to_front(horsey.position)
horsey.move_piece(chess, 0)
chess.display_board
puts horsey.position
puts horsey.convert_back_to_front(horsey.position)