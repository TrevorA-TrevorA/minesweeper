require "colorize"
require_relative "tile"

class Board

    attr_accessor :grid
    attr_reader :tiles

    def initialize
        @grid = Array.new(9){Array.new(9){Tile.new(self)}}
        @tiles = tile_list
        @game = Game.new(self)
    end

    def set
        position
        set_mines
        set_mine_count
    end

    def set_mine_count
        (0..8).each do |row|
            (0..8).each { |col| self[row, col].mine_count }
        end
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
                    tile.flagged == false ? "_" : :F
                else
                    tile.adjacent_mines
                end
            end
        end

        puts "  #{(0..8).to_a.join(" ")}".colorize(:red)
        rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
    end

    def display_mines
        rend = grid.map do |row| 
            row.map { |tile| tile.mine == true ? "*" : tile.adjacent_mines }
        end

        puts "  #{(0..8).to_a.join(" ")}".colorize(:red)
        rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
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

    def tile_list
        list = []
        (0..8).each do |row|
            (0..8).each { |col| list << self[row, col] }
        end
        list
    end

end
    
        
    

