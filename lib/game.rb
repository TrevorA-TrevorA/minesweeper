require "io/console"
require_relative "board"
require_relative "tile"

class Game

    attr_accessor :selected_tile
    attr_reader :board, :size

    def initialize(size = 9, mines = 18)
        @board = Board.new(self, size, mines)
        @mines = mines
        @size = size
        @selected_tile
    end

    def won?
        mineless_tiles = board.tiles { |tile| tile.mine == "false" }
        mineless_tiles.all? { |tile| tile.status == "revealed" }
    end

    def turn
        @selected_tile = nil
        system("clear")
        board.render
        prompt
        x, y = get_coordinates
        @selected_tile = self.board[x, y]

        system("clear")
        board.render
        puts "\n"

        if selected_tile.flagged == true
            puts "Press U to unflag or ENTER to choose new coordinates"
            gets.chomp.match?(/U/i) ? unflag : turn
            turn
        else
            options
        end
    end

    def run
        self.board.set
        turn until won? || game_over?
        puts "YOU WIN" if won?
        game_over_display if game_over?
    end

    def options
        system("clear")
        board.render
        puts "press S to select" 
        puts "Press F to flag"
        puts "Press ENTER to choose new coordinates"

        input = gets
        case input
        when "s\n" || "S\n"
            select
        when "f\n" || "F\n"
            flag
        when "\n"
            turn
        else
            puts "Invalid Entry"
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
        return if game_over?
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
        self.board.tile_list.select do |tile| 
            selected_tile.adjacent?(tile.position) 
        end
    end

    def adjacent_mines?
        adjacent.any? { |tile| tile.mine == true }
    end

    def prompt
        puts "Enter coordinates:"
    end

    def get_coordinates
        coords = gets.chomp.split(",").map(&:to_i)
        if valid_coords?(coords)
            return coords
        else
            puts "invalid entry"
            get_coordinates
        end
    end

    def valid_coords?(coords)
        x, y = coords
        (0..size - 1).to_a.include?(x) && 
        (0..size - 1).to_a.include?(y) &&
        board[x, y].status = "hidden"
    end

end

if __FILE__ == $PROGRAM_NAME

    puts "Enter board size:"    
    size = gets.chomp.to_i
    system("clear")
    puts "Enter number of mines:"
    mines = gets.chomp.to_i

    game = Game.new(size, mines)
    game.run
end