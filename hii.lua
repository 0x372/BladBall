-- PC Clash
local activated = false

local function toggle()
    activated = not activated
    while activated do
        local args = {
            [1] = 0.05,
            [2] = CFrame.new(-178.78347778320312, 119.66948699951172, -78.61863708496094) * CFrame.Angles(-2.014946460723877, 1.0034445524215698, 2.0845260620117188),
            [3] = {
                ["807338584"] = Vector3.new(446.77667236328125, 41.46874237060547, 65.78856658935547),
                ["4041067520"] = Vector3.new(-17.618267059326172, -7.117021560668945, 116.56157684326172),
                ["3889353590"] = Vector3.new(395.99981689453125, 171.1363983154297, 15.266807556152344)
            },
            [4] = {
                [1] = 588,
                [2] = 233
            }
        }
        game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(unpack(args))
        game:GetService("RunService").Heartbeat:Wait()
        wait(0.0001)
    end
end

local UserInputService = game:GetService("UserInputService")
local eKeyPressed = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == _G.ClashingKey and not gameProcessedEvent then
        eKeyPressed = true
        toggle()
    end
end)

-- Auto Parry
local Debug = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = workspace:WaitForChild("Balls", 9e9)

local function printIfDebug(...)
    if Debug then
        warn(...)
    end
end

local function isBallValid(ball)
    return typeof(ball) == "Instance"
        and ball:IsA("BasePart")
        and ball:IsDescendantOf(Balls)
        and ball:GetAttribute("realBall") == true
end

local function isPlayerTargeted()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function triggerParry()
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end

Balls.ChildAdded:Connect(function(ball)
    if not isBallValid(ball) then
        return
    end
    
    printIfDebug('Ball Spawned: ' .. tostring(ball))
    
    local oldPosition = ball.Position
    local lastParryTime = 0
    local threshold = 0.2
    local updateInterval = 1/60
    local lastUpdate = tick()
    
    ball:GetPropertyChangedSignal("Position"):Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate < updateInterval then
            return
        end
        
        lastUpdate = currentTime
        
        if isPlayerTargeted() then
            local currentPosition = ball.Position
            local velocity = (currentPosition - oldPosition).Magnitude
            local newPosition = ball.Position + (currentPosition - oldPosition)
            local distance = (newPosition - workspace.CurrentCamera.Focus.Position).Magnitude
            local timeToReach = distance / math.max(velocity, 0.001) -- Minimum velocity to avoid division by zero
            
            printIfDebug('Distance: ' .. distance .. '\nVelocity: ' .. velocity .. '\nTime: ' .. timeToReach)
            
            if timeToReach <= 10 and currentTime - lastParryTime >= threshold then
                triggerParry()
                lastParryTime = currentTime
            end
        end
        
        oldPosition = ball.Position
    end)
end)

-- Mobile Clash System
-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local button = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.723938942, 0, 0.644769311, 0)
Frame.Size = UDim2.new(0, 62, 0, 38)

button.Name = "button"
button.Parent = Frame
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.Position = UDim2.new(0.306451857, 0, -0.0243530273, 0)
button.Size = UDim2.new(0, 50, 0, 52)
button.Image = "rbxassetid://15605454734"

UICorner.CornerRadius = UDim.new(1, 8)
UICorner.Parent = button

UICorner_2.Parent = Frame

-- Scripts:

local function TFCTL_fake_script() -- button.Script 
	local script = Instance.new('Script', button)

	local activated = false
	
	local function toggle()
		activated = not activated
		while activated do
			local args = {
				[1] = 0.05,
				[2] = CFrame.new(-178.78347778320312, 119.66948699951172, -78.61863708496094) * CFrame.Angles(-2.014946460723877, 1.0034445524215698, 2.0845260620117188),
				[3] = {
					["807338584"] = Vector3.new(446.77667236328125, 41.46874237060547, 65.78856658935547),
					["4041067520"] = Vector3.new(-17.618267059326172, -7.117021560668945, 116.56157684326172),
					["3889353590"] = Vector3.new(395.99981689453125, 171.1363983154297, 15.266807556152344)
				},
				[4] = {
					[1] = 588,
					[2] = 233
				}
			}
			game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(unpack(args))
			game:GetService("RunService").Heartbeat:Wait()
		end
	end
	
	button.MouseButton1Click:Connect(toggle)
	
	
	local UserInputService = game:GetService("UserInputService")
	local eKeyPressed = false
	
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == _G.ClashingKey and not gameProcessedEvent then
			eKeyPressed = true
			toggle()
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == _G.ClashingKey then
			eKeyPressed = false
		end
	end)
end
coroutine.wrap(TFCTL_fake_script)()

