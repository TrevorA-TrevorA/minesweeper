require "securerandom"
require "colorize"
require_relative "tile"
require_relative "game"

class Board

    attr_accessor :grid
    attr_reader :tiles, :mines, :size, :game

    def initialize(game, size = 9, mines = 18)
        @grid = Array.new(size){Array.new(size){Tile.new(self)}}
        @game = game
        @size = size
        @mines = mines
        @tiles = tile_list
    end

    def set
        position
        plant_mines(mines)
        set_mine_count
    end

    def set_mine_count
        tiles.each { |tile| tile.mine_count }
    end

    def plant_mines(mines)
        mined = tiles.sample(mines, random: SecureRandom)
        mined.map!{ |tile| tile.mine = true }
    end

    def tile_appearance(tile)
        if tile.status == "hidden"
            tile.flagged == false ? (tile == game.selected_tile ? "?" : "_") : "F"
        else
            tile.mine == false ? tile.adjacent_mines : "*"
        end
    end

    def selector_appearance(tile)
        tile == game.selected_tile ? "?" : "+"
    end

    def display_selector
        rend = grid.map do |row| 
            row.map do |tile| 
                tile == game.selector ? selector_appearance(tile) : tile_appearance(tile)
            end
        end

        remaining = tiles.count { |tile| tile.mine == false && tile.status == "hidden" }
        mines = tiles.count { |tile| tile.mine == true }
        flagged = tiles.count { |tile| tile.flagged == true }

        if size <= 10
            puts "  #{(0..size - 1).to_a.join(" ")}".colorize(:red) 
            rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
            puts "\n"
            puts "remaining cells: " + "#{remaining}"
            puts "remaining mines?: " + "#{mines - flagged}"
        else
            rend.each { |row| puts row.join(" ") }
            puts "\n"
            puts "remaining cells: " + "#{remaining}"
            puts "remaining mines?: " + "#{mines - flagged}"
        end
    end
    
    def render
        rend = grid.map { |row| row.map { |tile| tile_appearance(tile) } }

        remaining = tiles.count { |tile| tile.mine == false && tile.status == "hidden" }
        mines = tiles.count { |tile| tile.mine == true }
        flagged = tiles.count { |tile| tile.flagged == true }

        if size <= 10
            puts "  #{(0..size - 1).to_a.join(" ")}".colorize(:red) 
            rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
            puts "\n"
            puts "remaining cells: " + "#{remaining}"
            puts "remaining mines?: " + "#{mines - flagged}"
        else
            rend.each { |row| puts row.join(" ") }
            puts "\n"
            puts "remaining cells: " + "#{remaining}"
            puts "remaining mines?: " + "#{mines - flagged}"
        end
    end

    def display_mines
        rend = grid.map do |row| 
            row.map { |tile| tile.mine == true ? "*" : tile.adjacent_mines }
        end

        if size <= 10
            puts "  #{(0..size - 1).to_a.join(" ")}".colorize(:red)
            rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
        else
            rend.each_with_index { |row, i| puts row.join(" ") }
        end
    end

    def mine?(pos)
        x, y = pos
        grid[x][y].mine == true
    end

    def [](x, y)
        grid[x][y]
    end

    def position
        (0..size - 1).each do |row|
            (0..size - 1).each { |col| grid[row][col].position = [row, col] }
        end
    end

    def tile_list
        list = []
        (0..size - 1).each do |row|
            (0..size - 1).each { |col| list << self[row, col] }
        end
        list
    end

end
    
        
    

