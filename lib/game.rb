require_relative "board"
require_relative "tile"

class Game

    def initialize(board)
        @board
    end

    def won?
        mineless_tiles = board.tile_list.select { |tile| tile.mine == "false" }
        mineless_tiles.all? { |tile| tile.status == "revealed" }
    end

    def turn
        x, y = get_coordinates
        if board[x, y].mine == false
            reveal_tile
        else
            puts "BOOM!"
            game_over
        end
    end

end