local robot = require("robot")
local os = require("os")
local sides = require("sides")

-- Constants
local rows = 9
local columns = 23
local waitTime = 600 -- 10 minutes in seconds

-- Function to move forward
local function moveForward()
  while not robot.forward() do
    os.sleep(0.5)
  end
end

-- Function to turn the robot to the right
local function turnRight()
  robot.turnRight()
end

-- Function to turn the robot to the left
local function turnLeft()
  robot.turnLeft()
end

local function turnBack()
  robot.turnAround()
end

-- Function to harvest the block in front of the robot
local function harvestBlock()
  robot.swing(sides.front)
end

-- Function to perform a single row of harvesting
local function harvestRow()
  for i = 1, columns - 1 do
    harvestBlock()
    moveForward()
  end
  harvestBlock()
end

-- Function to move the robot to the next row
local function moveToNextRow(isEvenRow)
  if isEvenRow then
    turnRight()
    moveForward()
    turnRight()
  else
    turnLeft()
    moveForward()
    turnLeft()
  end
end

-- Function to perform the entire harvest cycle
local function harvestCycle()
  local isEvenRow = false

  for i = 1, rows do
    harvestRow()

    if i < rows then
      moveToNextRow(isEvenRow)
      isEvenRow = not isEvenRow
    end
  end
end

-- Main function
local function main()
  while true do
    harvestCycle()
    turnBack()
    harvestCycle()
    os.sleep(waitTime)
  end
end

main()
