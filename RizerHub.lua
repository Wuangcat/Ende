
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    -- 📱 MOBILE
   
    BUTTON_POSITIONER = UDim2.fromOffset(500,350)
else
    -- 💻 PC
    
    BUTTON_POSITIONER = UDim2.fromOffset(583,390)
end



--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")


--==================================================
-- CONFIG
--==================================================

local IMAGE_ID = "rbxassetid://86319049302487"

local SIZE
local BUTTON_POSITION

-- 📱 MOBILE
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then

    SIZE = 48
    BUTTON_POSITION = UDim2.new(0, 20, 0.1, -6)

-- 💻 PC
else

    SIZE = 51
    BUTTON_POSITION = UDim2.new(0, 20, 0.1, 95)

end


--==================================================
-- REMOVE OLD GUI
--==================================================

local OldGui = PlayerGui:FindFirstChild("FloatingImageButton")

if OldGui then
    OldGui:Destroy()
end


--==================================================
-- CREATE GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FloatingImageButton"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui


--==================================================
-- MAIN BUTTON
--==================================================

local Button = Instance.new("ImageButton")

Button.Name = "FloatingButton"
Button.Size = UDim2.fromOffset(SIZE, SIZE)
Button.Position = BUTTON_POSITION

Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundTransparency = 0.32

Button.BorderSizePixel = 0

-- Không dùng Image trực tiếp trên Button
Button.Image = ""
Button.AutoButtonColor = false

Button.ZIndex = 10
Button.Parent = ScreenGui


--==================================================
-- ROUND BUTTON
--==================================================

local Corner = Instance.new("UICorner")

Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button


--==================================================
-- PREMIUM BORDER
--==================================================

local Stroke = Instance.new("UIStroke")

Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.25
Stroke.Thickness = 1.5

Stroke.Parent = Button


--==================================================
-- IMAGE
--==================================================

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "ButtonImage"

ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

ImageLabel.Size = UDim2.fromOffset(
    SIZE - 1,
    SIZE - 1
)

ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0

ImageLabel.Image = IMAGE_ID
ImageLabel.ScaleType = Enum.ScaleType.Fit

ImageLabel.ZIndex = 11
ImageLabel.Parent = Button


--==================================================
-- IMAGE SCALE
--==================================================

local ImageScale = Instance.new("UIScale")

ImageScale.Scale = 1
ImageScale.Parent = ImageLabel


--==================================================
-- CLICK EFFECT STATE
--==================================================

local Zoomed = false

local NORMAL_SCALE = 1.15
local ZOOM_SCALE = 1.3

local NORMAL_BACKGROUND = 0.32
local ZOOM_BACKGROUND = 0.05

local NORMAL_BORDER_TRANSPARENCY = 0.25
local ZOOM_BORDER_TRANSPARENCY = 0

local NORMAL_BORDER_THICKNESS = 1.5
local ZOOM_BORDER_THICKNESS = 2


--==================================================
-- CLICK EFFECT
--==================================================

local function ClickEffect()

    Zoomed = not Zoomed


    --==============================================
    -- ZOOM IN
    --==============================================

    if Zoomed then

        local ImageTween = TweenService:Create(
            ImageScale,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                Scale = ZOOM_SCALE
            }
        )


        local BackgroundTween = TweenService:Create(
            Button,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                BackgroundTransparency = ZOOM_BACKGROUND
            }
        )


        local BorderTween = TweenService:Create(
            Stroke,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                Transparency = ZOOM_BORDER_TRANSPARENCY,
                Thickness = ZOOM_BORDER_THICKNESS
            }
        )


        ImageTween:Play()
        BackgroundTween:Play()
        BorderTween:Play()


    --==============================================
    -- NORMAL
    --==============================================

    else

        local ImageTween = TweenService:Create(
            ImageScale,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                Scale = NORMAL_SCALE
            }
        )


        local BackgroundTween = TweenService:Create(
            Button,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                BackgroundTransparency = NORMAL_BACKGROUND
            }
        )


        local BorderTween = TweenService:Create(
            Stroke,

            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),

            {
                Transparency = NORMAL_BORDER_TRANSPARENCY,
                Thickness = NORMAL_BORDER_THICKNESS
            }
        )


        ImageTween:Play()
        BackgroundTween:Play()
        BorderTween:Play()

    end

end


--==================================================
-- CLICK
--==================================================

Button.MouseButton1Click:Connect(function()

    -- Zoom + background effect
    ClickEffect()


    --==============================================
    -- OPEN / CLOSE FLUENT UI
    --==============================================

    VirtualInputManager:SendKeyEvent(
        true,
        Enum.KeyCode.End,
        false,
        game
    )

    task.wait(0.05)

    VirtualInputManager:SendKeyEvent(
        false,
        Enum.KeyCode.End,
        false,
        game
    )

end)


--==================================================
-- DRAG SYSTEM
--==================================================

local Dragging = false
local DragStart
local StartPosition


--==================================================
-- UPDATE POSITION
--==================================================

local function UpdatePosition(Input)

    local Delta = Input.Position - DragStart

    Button.Position = UDim2.new(

        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,

        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y

    )

end


--==================================================
-- START DRAG
--==================================================

Button.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true

        DragStart = Input.Position
        StartPosition = Button.Position

    end

end)


--==================================================
-- MOVE
--==================================================

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then

        UpdatePosition(Input)

    end

end)


--==================================================
-- STOP DRAG
--==================================================

UserInputService.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false

    end

end)








local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Zenix Dino Hub-Blox Fruit",
    SubTitle = "by Wuangg",
    TabWidth = 160,
    Size =  BUTTON_POSITIONER,
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End -- Used when theres no MinimizeKeybind
})


    --Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
   
    
    Webhook = Window:AddTab({ Title = "Tab Webhook", Icon = "" }),
    Status = Window:AddTab({ Title = "Tab Status and Server", Icon = "" }),
    Player = Window:AddTab({ Title = "Tab Local Player", Icon = "" }),
    Setting = Window:AddTab({ Title = "Tab Setting Farm", Icon = "" }),
    Setskill = Window:AddTab({ Title = "Sub Setting\nand Select Skill ", Icon = "" }),
    Farming = Window:AddTab({ Title = "Tab Farming", Icon = "" }),
    Stack = Window:AddTab({ Title = "Tab Stack Farm", Icon = "" }),
    Other = Window:AddTab({ Title = "Tab Farming Other", Icon = "" }),
    Store = Window:AddTab({ Title = "Tab Shop", Icon = "" }),
    Vocano = Window:AddTab({ Title = "Tab Volcanic Event", Icon = "" }),
    Sea = Window:AddTab({ Title = "Tab Sea Event", Icon = "" }),
    Race = Window:AddTab({ Title = "Tab Upgrade Race", Icon = "" }),
    Raid = Window:AddTab({ Title = "Tab Fruit and Raid", Icon = "" }),
    Item = Window:AddTab({ Title = "Tab Get and Upgrade Items", Icon = "" }),
    PVP = Window:AddTab({ Title = "Tab PVP", Icon = "" })
    
    
   

}



 

local Options = Fluent.Options
do
end







   























-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:Load("ZenithConfig")
-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("Zenith HUB")
-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")


Window:SelectTab(1)



-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()


game.StarterGui:SetCore("SendNotification", {
    Title = "Yes Or No";
    Text = "Do u want reset Config?";
    Icon = "rbxassetid://86319049302487";
    Duration = 1e5;

    Button1 = "Yes";
    Button2 = "No";

    Callback = function(Button)
        if Button == "Yes" then
            pcall(function()
                SaveManager:Delete("ZenithConfiger")
            end)
        end
    end
})


