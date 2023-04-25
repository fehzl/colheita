local robot = require("robot")
local os = require("os")
local component = require("component")

-- Constants
local rows = 13
local columns = 33
local waitTime = 300 -- 5 minutes in seconds
local modem = component.modem
local port = 512

-- Active the modem
modem.open(port)

-- Function to move forward
local function moveForward()
  local attempts = 0

  while not robot.forward() do
    if robot.detect() then
      robot.swing()
    end

    if not robot.forward() then
      robot.back()
    end

    attempts = attempts + 1

    if attempts >= 5 then
      modem.broadcast(port, "moveForward")
      attempts = 0
    end

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
  robot.swing()
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

-- Function to unload items into the chest below the robot
local function unloadItems()
  for i = 1, robot.inventorySize() do
    robot.select(i)
    robot.dropDown()
  end
  robot.select(1)
end

-- Main function
local function main()
  while true do
    harvestCycle()
    turnBack()
    harvestCycle()
    turnBack()
    unloadItems()
    os.sleep(waitTime)
  end
end

main()
