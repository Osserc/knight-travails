module Borders
    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
end

module Knight_Limitations
    include Borders
    UPPER_BOUND = (9..14).to_a
    UPPER_LIMITATIONS = [-17, -15, -10, -6]
    UPPER__BOUND_LIMITATIONS = [-17, -15]
    LEFT_BOUND = [9, 17, 25, 33, 41, 49]
    LEFT_LIMITATIONS = [-17, -10, 6, 15]
    LEFT__BOUND_LIMITATIONS = [-10, 6]
    RIGHT_BOUND = [14, 22, 30, 38, 46, 54]
    RIGHT_LIMITATIONS = [-15, -6, 10, 17]
    RIGHT_BOUND_LIMITATIONS = [-6, 10]
    LOWER_BOUND = (49..54).to_a
    LOWER_LIMITATIONS = [17, 15, 10, 6]
    LOWER__BOUND_LIMITATIONS = [17, 15]

    def check_borders(moves)
        moves -= UPPER_LIMITATIONS if TOP_BORDER.include?(self.position) 
        moves -= UPPER__BOUND_LIMITATIONS if UPPER_BOUND.include?(self.position)
        moves -= LEFT_LIMITATIONS if LEFT_BORDER.include?(self.position)
        moves -= LEFT__BOUND_LIMITATIONS if LEFT_BOUND.include?(self.position)
        moves -= RIGHT_LIMITATIONS if RIGHT_BORDER.include?(self.position)
        moves -= RIGHT_BOUND_LIMITATIONS if RIGHT_BOUND.include?(self.position)
        moves -= LOWER_LIMITATIONS if BOTTOM_BORDER.include?(self.position)
        moves -= LOWER__BOUND_LIMITATIONS if LOWER_BOUND.include?(self.position)
        moves
    end

end

module Moves
    include Knight_Limitations
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
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = check_borders(moves)
        end
    end

    def check_legality(destination)
        moves = define_moveset
        differential = destination - @position
        return true if moves.include?(differential)
        return false
    end

end

class Node_List
    attr_accessor :head

    def initialize(position)
        @head = Node.new(position)
    end

end

class Node
    attr_accessor :local, :parent, :children
    def initialize(local, parent = nil, children = Array.new)
        @local = local
        @parent = parent
        @children = children
    end

end


module Navigation

    LETTERS = ('A'..'H').to_a
    NUMBERS = (1..8).to_a
    BOARD_UI = LETTERS.map { | l | NUMBERS.map { | n | "#{l}#{n}" } }.flatten

    def convert_back_to_front(index)
        converted = BOARD_UI[index]
        converted
    end

    def convert_front_to_back(coords)
        converted = BOARD_UI.index(coords)
        converted
    end

end

module Calculate_Path
    include Borders, Knight_Limitations, Navigation
    def define_moveset_internal(position)
        moves = Array.new.concat(self.class::STANDARD_MOVESET)
        moves -= UPPER_LIMITATIONS if TOP_BORDER.include?(position) 
        moves -= UPPER__BOUND_LIMITATIONS if UPPER_BOUND.include?(position)
        moves -= LEFT_LIMITATIONS if LEFT_BORDER.include?(position)
        moves -= LEFT__BOUND_LIMITATIONS if LEFT_BOUND.include?(position)
        moves -= RIGHT_LIMITATIONS if RIGHT_BORDER.include?(position)
        moves -= RIGHT_BOUND_LIMITATIONS if RIGHT_BOUND.include?(position)
        moves -= LOWER_LIMITATIONS if BOTTOM_BORDER.include?(position)
        moves -= LOWER__BOUND_LIMITATIONS if LOWER_BOUND.include?(position)
        moves
    end

    def shortest_path(board, destination)
        visited_squares = Array.new
        list = Node_List.new(@position)
        queue = Array.new
        batch = Array.new
        batch.push(list.head)
        queue.push(list.head)
        last_child = build_graph(visited_squares, queue, batch, destination)
        ancestry = build_genealogy(last_child)
        unwind_ancestry(ancestry)
        show_path(board, ancestry)
        start_over(board)
    end

    def build_graph(visited_squares, queue, batch, destination)
        until batch.empty?
            explorer = batch[0]
            moves = define_moveset_internal(explorer.local)
            until moves.empty?
                if explorer.local + moves[0] == destination
                    return entry = Node.new(explorer.local + moves[0], explorer)
                else
                    queue.push(Node.new(explorer.local + moves[0], explorer)) unless visited_squares.include?(explorer.local + moves[0]) || find_child(explorer)
                    moves.shift
                end
            end
            batch.shift
            visited_squares.push(explorer.local)
            queue.shift
        end
        batch.concat(queue)
        build_graph(visited_squares, queue, batch, destination)
    end

    def find_child(explorer)
        explorer.children.each do | child |
            return true if child.local == explorer.local
        end
        false
    end

    def build_genealogy(child)
        ancestry = Array.new
        until child.parent.nil?
            ancestry.push(child.local)
            child = child.parent
        end
        ancestry.reverse
    end

    def unwind_ancestry(ancestry)
        i = 0
        count = ancestry.length
        puts "From #{convert_back_to_front(@position)}, the shortest path to #{convert_back_to_front(ancestry.last)} is made of #{count} moves:\n[#{convert_back_to_front(@position)}, #{convert_back_to_front(ancestry.first)}]"
        until i == count - 1
            puts "[#{convert_back_to_front(ancestry[i])}, #{convert_back_to_front(ancestry[i + 1])}]"
            i += 1
        end
    end

    def show_path(board, ancestry)
        puts "Would you like to see your knight gallop across the board? Enter yes or no."
        answer = decision_check
        if answer == "YES"
            i = 0
            until i == ancestry.length
                self.move_piece(board, ancestry[i])
                board.display_board
                i += 1
                puts "What a good little horsey!" if i == ancestry.length
                puts "Press Enter to proceed."                
                gets
            end
        else
            return
        end
    end
    
    def decision_check
        answer = gets.chomp.upcase
        until answer == "YES" || answer == "NO"
            puts "Please answer properly."
            answer = gets.chomp.upcase
        end
        answer
    end

    def start_over(board)
        puts "Would you like to start over? Enter yes or no."
        answer = decision_check
        if answer == "YES"
            board.start
        else
            exit
        end
    end
            
end

class Board
    attr_accessor :board
    include Navigation

    def initialize
        @board = make_board
    end

    def start
        chess = Board.new
        chess.make_board
        horsey = Knight.new(chess, chess.place_knight)
        chess.display_board
        horsey.shortest_path(chess, chess.define_journey)
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

    def place_knight
        puts "Welcome to Knight's Travails! Where would you like your knight to start his journey from? Insert the position in notation, e.g. A2"
        input_loop
    end

    def define_journey
        puts "Where would you like your knight to travel to?"
        input_loop
    end

    def input_loop
        answer = gets.chomp.upcase
        until check_coords_input(answer)
            puts "Invalid coordinates.\nPlease insert a valid starting spot."
            answer = gets.chomp.upcase
        end
        convert_front_to_back(answer)
    end

    def check_coords_input(input)
        if input.length == 2 && LETTERS.include?(input[0]) && NUMBERS.include?(input[1].to_i)
            return true
        else
            return false
        end
    end

end

class Piece

end

class Knight < Piece
    attr_accessor :position
    attr_reader :symbol
    include Moves, Navigation, Calculate_Path
    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(board, position, player = 1)
        @player = player
        @symbol = "N"
        @position = position
        board.board[@position] = self
    end

end

Board.new.start