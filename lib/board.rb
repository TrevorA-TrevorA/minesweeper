require_relative "tile"

class Board

    attr_accessor :grid

    def initialize
        @grid = Array.new(9){Array.new(9){Tile.new(self)}}
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
    
    def render
       rend = grid.map do |row| 
            row.map do |tile|
                if tile.status == "hidden"
                    tile.flagged == false ? "*" : :F
                else
                    tile.adjacent_mines
                end
            end
        end

        puts "  #{(0..8).to_a.join(" ")}"
        rend.each_with_index { |row, i| puts"#{i} " + row.join(" ") }
    end

    def mine?(pos)
        x, y = pos
        grid[x][y].mine == true
    end

    def [](x, y)
        grid[x][y]
    end

    def position
        (0..8).each do |row|
            (0..8).each { |col| grid[row][col].position = [row, col] }
        end
    end

end
    
        
    

