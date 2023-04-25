local component = require("component")
local event = require("event")

local modem = component.modem

local port = 512

modem.open(port)

print("Waiting for message...")

local function onModemMessage(_, localAddress, remoteAddress, port, distance, message)
  print("Message received: " .. message)
end

event.listen("modem_message", onModemMessage)

print("Press any key to stop listening")
event.pull("key")

event.ignore("modem_message", onModemMessage)
modem.close(port)