class Robot
  attr_reader :coordinates, :bearing
  DIRECTIONS = [:north, :east, :south, :west]

  def orient(direction)
    raise ArgumentError unless DIRECTIONS.include? direction
    @bearing = direction
  end

  def turn_right
    change_bearing(90)
  end

  def turn_left
    change_bearing(-90)
  end

  def at(x, y)
    @coordinates = [x, y]
  end

  def advance
    case @bearing
    when :north then change_x_y( 0, 1 )
    when :south then change_x_y( 0,-1 )
    when :east  then change_x_y( 1, 0 )
    when :west  then change_x_y(-1, 0 )
    end
  end

  private

  def change_x_y(diff_x, diff_y)
    @coordinates[0] += diff_x
    @coordinates[1] += diff_y
  end

  def change_bearing(diff) # in degrees
    idx = (DIRECTIONS.index(@bearing) + diff / 90).to_i % DIRECTIONS.size
    @bearing = DIRECTIONS[idx]
  end
end


class Simulator
  MOVES = { 'L' => :turn_left, 'R' => :turn_right, 'A' => :advance }

  def instructions(command_str)
    command_str.chars.map {|letter| MOVES[letter]}
  end

  def place(robot, **args)
    robot.at(args[:x], args[:y])
    robot.orient(args[:direction])
  end

  def evaluate(robot, command_str)
    instructions(command_str).each {|cmd| robot.send(cmd)}
  end
end
