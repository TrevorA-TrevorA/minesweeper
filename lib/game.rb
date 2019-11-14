require_relative "board"
require_relative "tile"

class Game

    attr_accessor :selected_tile
    attr_reader :board

    def initialize
        @board = Board.new(self)
        @selected_tile
    end

    def won?
        mineless_tiles = board.tile_list.select { |tile| tile.mine == "false" }
        mineless_tiles.all? { |tile| tile.status == "revealed" }
    end

    def turn
        system("clear")
        board.render
        x, y = get_coordinates
        @selected_tile = self.board[x, y]

        puts "press S to select or F to flag"
        gets.chomp.match?(/F/i) ? flag : select
    end

    def select
        if selected_tile.mine == false
            reveal
            clear_adjacent if !adjacent_mines?
            turn
        else
            puts "BOOM!"
            game_over
        end
    end

    def reveal
        selected_tile.status = "revealed"
    end

    def flag
        selected_tile.flagged = true
        turn
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

    def get_coordinates
        puts "Enter coordinates:"
        coords = gets.chomp.split(",").map(&:to_i)
        if valid_coords?(coords)
            return coords
        else
            puts "invalid entry"
            get_coordinates
        end
    end

    def game_over
        puts "Game Over"
        board.display_mines
    end

    def valid_coords?(coords)
        x, y = coords
        (0..8).to_a.include?(x) && 
        (0..8).to_a.include?(y) &&
        board[x, y].status = "hidden"
    end

end