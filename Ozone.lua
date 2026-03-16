local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [1] สร้างหน้าต่างเมนู
local Window = Rayfield:CreateWindow({
    Name = "Ozone",
    Icon = 0,
    LoadingTitle = "กำลังโหลดระบบ Ozone...",
    LoadingSubtitle = "by stratxgy",
    Theme = "AmberGlow",
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "OzoneAimlock",
       FileName = "Config"
    },
 
    KeySystem = true,
    KeySettings = {
       Title = "Skibidi Keys",
       Subtitle = "ระบบคีย์",
       Note = "ใส่คีย์เพื่อเข้าใช้งาน",
       FileName = "OzoneKey",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"087", "OzoneKey"}
    }
}) 

-- โหลด Services ที่จำเป็น
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- โหลดสคริปต์ Aimbot (Exunys V3)
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

-- ==========================================
-- ##### แถบ AIMLOCK #####
-- ==========================================
local aimbotTab = Window:CreateTab("Aimlock", "target")
aimbotTab:CreateSection("Aimbot Settings")

aimbotTab:CreateToggle({
    Name = "เปิดใช้งาน Aimlock",
    CurrentValue = false,
    Flag = "MainAimbot",
    Callback = function(Value)
        if Value then
            Aimbot.Load()
        end
    end,
})

-- ตัวเลือกล็อคชิ้นส่วนเป้าหมาย (Lock Part)
aimbotTab:CreateDropdown({
    Name = "ส่วนที่ต้องการล็อคเป้า",
    Options = {"หัว (Head)", "ตัว (Torso)", "แขนขวา (Right Arm)", "แขนซ้าย (Left Arm)", "ขาขวา (Right Leg)", "ขาซ้าย (Left Leg)"},
    CurrentOption = {"หัว (Head)"},
    MultipleOptions = false,
    Flag = "AimbotLockPart",
    Callback = function(Options)
        local selected = Options[1]
        local targetPart = "Head" -- ค่าเริ่มต้น

        -- แปลงชื่อภาษาไทยเป็น Part ของ Roblox
        if selected == "หัว (Head)" then targetPart = "Head"
        elseif selected == "ตัว (Torso)" then targetPart = "HumanoidRootPart" -- ล็อคช่วงกลางลำตัวแม่นยำที่สุด
        elseif selected == "แขนขวา (Right Arm)" then targetPart = "Right Arm"
        elseif selected == "แขนซ้าย (Left Arm)" then targetPart = "Left Arm"
        elseif selected == "ขาขวา (Right Leg)" then targetPart = "Right Leg"
        elseif selected == "ขาซ้าย (Left Leg)" then targetPart = "Left Leg"
        end

        -- อัปเดตค่าในระบบ Aimbot
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.Settings.LockPart = targetPart
        end
    end,
})

aimbotTab:CreateToggle({
    Name = "เช็คทีม (Team Check)",
    CurrentValue = false,
    Flag = "TeamCheckToggle",
    Callback = function(Value)
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.Settings.TeamCheck = Value
        end
    end,
})

aimbotTab:CreateToggle({
    Name = "แสดงวงกลม FOV",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(Value)
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.FOVSettings.Visible = Value
        end
    end,
})

aimbotTab:CreateSlider({
    Name = "ขนาดรัศมี FOV",
    Range = {0, 800},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 100,
    Flag = "FOVRadius",
    Callback = function(Value)
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.FOVSettings.Radius = Value
        end
    end,
})

aimbotTab:CreateColorPicker({
    Name = "สีของ FOV",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColor",
    Callback = function(Value)
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.FOVSettings.Color = Value
        end
    end
})

aimbotTab:CreateKeybind({
    Name = "ปุ่มสำหรับ Lock (Hold)",
    CurrentKeybind = "MB2", 
    HoldToInteract = false,
    Flag = "AimKeybind",
    Callback = function(Keybind)
        if getgenv().ExunysDeveloperAimbot then
            getgenv().ExunysDeveloperAimbot.Settings.TriggerKey = Keybind
        end
    end,
})

-- ==========================================
-- ##### แถบ ผู้เล่น (PLAYER) #####
-- ==========================================
local playerTab = Window:CreateTab("Player", "user")

playerTab:CreateSection("ตั้งค่าตัวละคร")

playerTab:CreateSlider({
    Name = "ความเร็วเดิน (Speed)",
    Range = {16, 1000},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

playerTab:CreateSlider({
    Name = "กระโดดสูง (Jump)",
    Range = {50, 100},
    Increment = 1,
    Suffix = " Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.UseJumpPower = true
            lp.Character.Humanoid.JumpPower = Value
        end
    end,
})

-- ตัวแปรเก็บสถานะ Noclip
local noclipConnection
playerTab:CreateToggle({
    Name = "เดินทะลุกำแพง (Noclip)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        if Value then
            noclipConnection = RunService.Stepped:Connect(function()
                if lp.Character then
                    for _, part in pairs(lp.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end,
})

playerTab:CreateSection("จัดการผู้เล่นอื่น (Target Player)")

-- ฟังก์ชันดึงชื่อผู้เล่นในเซิร์ฟเวอร์
local function GetPlayerNames()
    local names = {}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= lp then
            table.insert(names, v.Name)
        end
    end
    return names
end

local selectedPlayerTarget = ""

local TargetDropdown = playerTab:CreateDropdown({
    Name = "เลือกผู้เล่นเป้าหมาย",
    Options = GetPlayerNames(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "TargetDropdown",
    Callback = function(Options)
        selectedPlayerTarget = Options[1]
    end,
})

playerTab:CreateButton({
    Name = "🔄 รีเฟรชรายชื่อผู้เล่น",
    Callback = function()
        TargetDropdown:Refresh(GetPlayerNames(), true)
    end,
})

playerTab:CreateButton({
    Name = "⚡ วาร์ปไปหาผู้เล่น (Teleport)",
    Callback = function()
        if selectedPlayerTarget ~= "" then
            local targetPlayer = Players:FindFirstChild(selectedPlayerTarget)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end,
})

playerTab:CreateToggle({
    Name = "ส่องผู้เล่น (Spectate)",
    CurrentValue = false,
    Flag = "SpectateToggle",
    Callback = function(Value)
        if Value and selectedPlayerTarget ~= "" then
            local targetPlayer = Players:FindFirstChild(selectedPlayerTarget)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                camera.CameraSubject = targetPlayer.Character.Humanoid
            end
        else
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                camera.CameraSubject = lp.Character.Humanoid
            end
        end
    end,
})

-- ==========================================
-- ##### แถบ ESP (มองทะลุกำแพง) #####
-- ==========================================
local espTab = Window:CreateTab("ESP", "eye")
espTab:CreateSection("ตั้งค่า ESP ผู้เล่น")

local ESP_Settings = {
    Enabled = false,
    Names = false,
    Tracers = false
}

espTab:CreateToggle({
    Name = "เปิดใช้งาน ESP รวม",
    CurrentValue = false,
    Flag = "ESPMainToggle",
    Callback = function(Value)
        ESP_Settings.Enabled = Value
    end,
})

espTab:CreateToggle({
    Name = "แสดงชื่อผู้เล่น (Name ESP)",
    CurrentValue = false,
    Flag = "ESPNameToggle",
    Callback = function(Value)
        ESP_Settings.Names = Value
    end,
})

espTab:CreateToggle({
    Name = "เส้นชี้เป้าหมาย (Tracer ESP)",
    CurrentValue = false,
    Flag = "ESPTracerToggle",
    Callback = function(Value)
        ESP_Settings.Tracers = Value
    end,
})

-- ระบบวาด ESP (Drawing API)
local espObjects = {}

local function createEsp(player)
    local esp = {
        name = Drawing.new("Text"),
        tracer = Drawing.new("Line")
    }
    esp.name.Visible = false
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = Color3.fromRGB(255, 255, 255)
    esp.name.Size = 16

    esp.tracer.Visible = false
    esp.tracer.Color = Color3.fromRGB(255, 0, 0)
    esp.tracer.Thickness = 1.5

    espObjects[player] = esp
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= lp then createEsp(v) end
end

Players.PlayerAdded:Connect(function(v)
    if v ~= lp then createEsp(v) end
end)
Players.PlayerRemoving:Connect(function(v)
    if espObjects[v] then
        espObjects[v].name:Remove()
        espObjects[v].tracer:Remove()
        espObjects[v] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(espObjects) do
        if ESP_Settings.Enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            local hrp = player.Character.HumanoidRootPart
            local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                if ESP_Settings.Names then
                    esp.name.Position = Vector2.new(vector.X, vector.Y - 40)
                    esp.name.Text = player.Name
                    esp.name.Visible = true
                else
                    esp.name.Visible = false
                end

                if ESP_Settings.Tracers then
                    esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    esp.tracer.To = Vector2.new(vector.X, vector.Y)
                    esp.tracer.Visible = true
                else
                    esp.tracer.Visible = false
                end
            else
                esp.name.Visible = false
                esp.tracer.Visible = false
            end
        else
            esp.name.Visible = false
            esp.tracer.Visible = false
        end
    end
end)

-- ==========================================
Rayfield:Notify({
    Title = "Ozone Ready",
    Content = "อัปเดตระบบเลือกล็อคเป้า (Hitbox) สำเร็จ!",
    Duration = 5,
    Image = 4483362458,
})
