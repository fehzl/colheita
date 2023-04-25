local component = require("component")
local event = require("event")
local term = require("term")
local computer = require("computer")

local modem = component.modem
local gpu = component.gpu

local port = 12345 -- Use a mesma porta que o robô está transmitindo

-- Ativar o modem na porta especificada
modem.open(port)

print("Listening for signals on port " .. port)

local function showNotification(message)
  local oldForeground = gpu.setForeground(0x00FF00)
  local w, h = gpu.getResolution()
  term.setCursor(w - #message - 1, 1)
  gpu.fill(w - #message, 1, #message + 2, 1, " ")
  gpu.set(w - #message, 1, message)
  gpu.setForeground(oldForeground)
end

local function onModemMessage(_, localAddress, remoteAddress, port, distance, message)
  print("Message received: " .. message)
  showNotification("Robot Alert!")
  computer.beep(1000, 0.5)
end

local function main()
  event.listen("modem_message", onModemMessage)
  
  print("Press any key to stop listening")
  while true do
    local e = {event.pull()}
    if e[1] == "key_down" then
      break
    end
  end

  event.ignore("modem_message", onModemMessage)
  modem.close(port)
end

local ok, err = pcall(main)

if not ok then
  print("An error occurred: " .. tostring(err))
  event.ignore("modem_message", onModemMessage)
  modem.close(port)
end