require_relative "tile"

class Board

    attr_accessor :grid

    def initialize
        @grid = Array.new(9){Array.new(9){Tile.new}}
    end

    def set_mines
        until grid.flatten.count { |tile| tile.mine == true } == 27 do
            plant_mine([rand(8), rand(8)])
        end
    end

    def plant_mine(pos)
        x, y = pos
        grid[x][y].mine = true
    end
    
end
    
        
    

