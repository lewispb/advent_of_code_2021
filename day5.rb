# rubocop:disable all

MATRIX_SIZE = 1000

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y
end

class Line
  def initialize(start:, finish:)
    @start = Point.new(*start)
    @finish = Point.new(*finish)
  end

  def self.from_string(str)
    start, finish = str.split(" -> ").map do |coord|
      coord.split(",").map(&:to_i)
    end

    new(start: start, finish: finish)
  end

  def horizontal?
    start.y == finish.y
  end

  def vertical?
    start.x == finish.x
  end

  def all_points
    if horizontal?
      Range.new(*[start.x, finish.x].sort).map do |x|
        Point.new(x, start.y)
      end
    elsif vertical?
      Range.new(*[start.y, finish.y].sort).map do |y|
        Point.new(start.x, y)
      end
    end
  end

  attr_reader :start, :finish
end

input = File.read("day5.txt")

matrix = Array.new(MATRIX_SIZE) do
  Array.new(MATRIX_SIZE) { 0 }
end

lines = input.each_line(chomp: true).map { |line| Line.from_string(line) }

lines.each do |line|
  line.all_points&.each do |point|
    matrix[point.y][point.x] += 1
  end
end

count = matrix.sum { |row| row.count { |value| value > 1 } }
puts "Answer: #{count}"
