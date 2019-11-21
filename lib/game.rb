require "io/console"
require_relative "board"
require_relative "tile"

class Game

    attr_accessor :selected_tile, :selector
    attr_reader :board, :size

    def initialize(size = 9, mines = 18)
        @board = Board.new(self, size, mines)
        @mines = mines
        @size = size
        @selected_tile
        @selector
    end

    def won?
        mineless_tiles = board.tiles.select { |tile| tile.mine == false }
        mineless_tiles.all? { |tile| tile.status == "revealed" }
    end

    def turn
       
        system("clear")
        board.render
        prompt
        receive_input
        
        system("clear")
        board.render
        puts "\n"

        if selected_tile
            selected_tile.flagged == true ? flag_options : options
        end
         @selected_tile = nil
    end

    def run
        self.board.set
        turn until won? || game_over?
        puts "YOU WIN" if won?
        game_over_display if game_over?
    end

    def reset
        system("clear")
        system("ruby game.rb")
    end

    def self.title
        system("clear")
        puts "\t\t\tTrevor's Minesweeper Game"
        sleep(1)
        system("clear")
    end

    def flag_options
        puts "Press U to unflag or ENTER to choose new coordinates"
            case STDIN.raw { |i| i.read(1) }
            when "u" || "U"
                unflag
            when "\r"
                turn
            else
                puts "INVALID ENTRY"
                sleep(1)
                turn
            end
    end

    def options
        
        system("clear")
        board.render
        puts "press S to select" 
        puts "Press F to flag"
        puts "Press ENTER return to previous options"

        input = STDIN.raw { |i| i.read(1) }
        case input
        when "s" || "S"
            select
            return
        when "f" || "F"
            flag
        when "\r"
            @selected_tile = nil
            turn
        else
            puts "INVALID ENTRY"
            sleep(1)
            options
        end 
    end

    def game_over_display
        system("clear")
        puts "GAME OVER"
        puts "\n"
        board.display_mines
    end

    def select
        reveal
        clear_adjacent if !adjacent_mines?
    end

    def reveal
        selected_tile.status = "revealed"
    end

    def game_over?
        board.tiles.any? do |tile|
            tile.status == "revealed" && tile.mine == true
        end
    end

    def flag
        selected_tile.flagged = true
    end

    def unflag
        selected_tile.flagged = false
    end

    def clear_adjacent
        adjacent.each { |tile| tile.status = "revealed"}
    end

    def adjacent
        self.board.tiles.select do |tile| 
            selected_tile.adjacent?(tile.position) 
        end
    end

    def adjacent_mines?
        adjacent.any? { |tile| tile.mine == true }
    end

    def prompt
        puts "Press A to navigate with arrow keys"
        puts "Press C to enter coordinates:"
        puts "Press R to reset"
        puts "Press Q to quit"
    end

    def quit
        system("clear")
        exit
    end

    def receive_input
        input = STDIN.raw { |i| i.read(1) }
        case input
        when "a" || "A"
            arrows
        when "c" || "C"
            get_coordinates
        when "r" || "R"
            reset
        when "q" || "Q"
            quit
        else
            puts "INVALID ENTRY"
            turn 
        end
    end

    def arrows
        @selector ||= self.board[size/2, size/2]
        system("clear")
        board.display_selector
        STDIN.raw!
        input = STDIN.getc
        input << STDIN.read_nonblock(2) if input == "\e"
        STDIN.cooked!
        navigate(input)
    end

    def navigate(input)

        case input
        when "\e[A"
            move_up
            system("clear")
            board.display_selector
            arrows
        when "\e[B"
            move_down
            system("clear")
            board.display_selector
            arrows
        when "\e[D"
            move_left
            system("clear")
            board.display_selector
            arrows
        when "\e[C"
            move_right
            system("clear")
            board.display_selector
            arrows
        when "\r"
            select_tile
        else
            puts "INVALID ENTRY"
            arrows
        end
    end

    def select_tile
        x, y = @selector.position

        if valid_coords?([x, y])
            @selected_tile = self.board[x, y]
        else
            puts "INVALID ENTRY"
            sleep(1)
        end

        system("clear")
        board.render
    end

    def move_up
        x, y = @selector.position
        @selector = self.board[x - 1, y] if x > 0
    end

    def move_down
        x, y = @selector.position
        @selector = self.board[x + 1, y] if x < size - 1
    end

    def move_left
        x, y = @selector.position
         @selector = self.board[x, y - 1] if y > 0 
    end

    def move_right
        x, y = @selector.position
         @selector = self.board[x, y + 1] if y < size - 1
    end

    def get_coordinates
        system("clear")
        board.render
        puts "rows and columns are numbered 0 to #{size - 1}"
        puts "Enter coordinates (e.g. 5,10):"
        input = gets.chomp
        coords = input.split(",").map(&:to_i)
        if valid_coords?(coords)
            x, y = coords
            @selected_tile = self.board[x, y]
        else
            puts "INVALID ENTRY"
        end
    end

    def valid_coords?(coords)
        x, y = coords
        (0..size - 1).to_a.include?(x) && 
        (0..size - 1).to_a.include?(y) &&
        board[x, y].status == "hidden"
    end

end

if __FILE__ == $PROGRAM_NAME
    Game.title
    puts "Enter board size (e.g. enter 20 for a 20x20 board):"    
    size = gets.chomp.to_i
    system("clear")
    puts "Enter number of mines:"
    mines = gets.chomp.to_i

    game = Game.new(size, mines)
    game.run
end