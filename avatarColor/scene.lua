local stack
local avatarColorObject

local avatarColorStack

local scene = {}

function scene.load()
  stack = require("common.staticStack")
  avatarColorObject = require("avatarColor.avatarColorObject")
  
  avatarColorStack = stack:new("AvatarColorStack", "Avatar Color", avatarColorObject, "Avatar Color Stack Size : ")
end

function scene.update()
  avatarColorStack:update()
end

function scene.set(items)
  avatarColorStack:set(#items)
  
  for i,v in pairs (items) do
    print(v.timestampMs)
    
    avatarColorStack.items[i].timestampMs = v.timestampMs
  end
end

scene.load()

return scene