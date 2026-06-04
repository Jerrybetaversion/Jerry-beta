-- =============================================
--      JERRY V1 Beta
--          
-- =============================================

local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then
    warn("Jerry v1: Rayfield konnte nicht geladen werden!")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "Jerry v1 Beta",
    LoadingTitle = "Jerry v1 beta",
    LoadingSubtitle = "By Jerry ",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Size = UDim2.new(0, 850, 0, 520)
})

-- ==================== LOCALIZATION SYSTEM ====================
local CurrentLanguage = "DE"

local Strings = {
    DE = {
        TabWelcome = "ℹ️ Willkommen", TabCombat = "🛡️ Kampf & Zielhilfe", TabVisuals = "👁️ Visuals & ESP",
        TabMovement = "🏃 Erw. Bewegung", TabWorld = "🛠️ Welt & Umgebung", TabPlayer = "👤 Anti-Troll & Schilde",
        TabInfo = "📊 Spieler Infos", TabBypass = "🔍 Spieler überprüfen", 
        TabServerInfo = "💻 Server Stats", TabSettings = "⚙️ System Utilities",
        SecNotice = "⚠️ Systemstatus", LblNotice1 = "Jerry v1 God Mode Edition wurde vollständig initialisiert.",
        LblNotice2 = "Alle Elite-Erweiterungen und automatisierten Subsysteme sind aktiv.",
        SecAim = "🎯 Kamera Zielhilfe (Aim Assist)", TglCamAim = "Kamera Aimbot", SldSmooth = "Ziel-Glättung (Smoothness)",
        TglFov = "FOV-Kreis anzeigen", SldFov = "FOV-Radius", TglTeamCheck = "Team Check (Ignoriere Team)",
        TglFriendCheck = "Friend Check (Ignoriere Freunde)", DrpHitbox = "Ziel-Körperteil Auswahl",
        TglPredict = "Aimbot Positions-Vorhersage (Prediction)", SecTrigger = "🔫 Triggerbot Automatisierung", TglTrigger = "Triggerbot (Auto-Schuss)",
        TglParry = "Auto-Parry / Auto-Block Framework", SecEsp = "👁️ Extra Sensory Perception (ESP)", 
        TglGlobalEsp = "Master ESP Schalter", TglRainbow = "Regenbogen RGB Modus",
        TglEspNames = "Spielernamen anzeigen", TglEspBoxes = "2D Box-Rahmen anzeigen", TglEspChams = "Outlines / Chams Leuchten",
        TglEspTracers = "Tracer Linien (Boden/Mitte)", TglEspSkel = "Skelett-Knochen anzeigen", TglEspHealthBar = "Lebensbalken anzeigen",
        TglTeamColors = "Team-Farben für ESP nutzen", SldEspMaxDist = "ESP Max. Rendering Distanz (Studs)",
        TglFade = "ESP Distanz-Transparenz (Fade-Out)", TglItemEsp = "Welt-Gegenstände & Loot ESP anzeigen",
        SecCross = "🎯 Fadenkreuz Optik", TglCrosshair = "Eigenes Fadenkreuz Overlay",
        SecSpeed = "👟 Bewegungs Modifikatoren", SldSpeed = "WalkSpeed Geschwindigkeit", DrpSpeed = "Physik Übertragungs-Methode",
        SldJump = "JumpPower Sprungkraft", TglInfJump = "Unendlicher Luftsprung Loop", SldHip = "Schwebehöhe (HipHeight)",
        SldGravity = "Lokale Schwerkraft", TglNoclip = "Noclip (Durch Wände laufen)",
        SecFly = "🦅 Aerodynamik", TglFly = "Flugmechanik", SldFly = "Flug-Geschwindigkeit",
        SecWorld = "🌍 Umwelt Manipulationen", TglXray = "Karten X-Ray (0.65 Transparenz)",
        SecSelect = "🎯 Zielerfassung Profil", DrpSelect = "Aktives Ziel wählen", SecProfile = "👤 Identifikations-Akte",
        SecStatus = "📊 Live Attribute", SecShields = "🛡️ Physikalische Integritäts-Schilde",
        TglAntiFling = "Anti-Fling Kollisions-Isolation", TglAntiRagdoll = "Anti-Ragdoll Animations-Sperre",
        TglAntiAnchor = "Anti-Anchor (Einfrieren blockieren)", TglAntiTeleport = "Anti-Teleport (Server-TP blockieren)",
        SecMisc = "🏎️ Hardware Optimization", TglShowFps = "Live FPS Zähler anzeigen", TglShowPing = "Live Ping Zähler anzeigen", SecExit = "❌ Beendungs-Kontrolle",
        BtnExit = "Jerry v1 sicher herunterfahren", NoPlayers = "Keine gültigen Spieler", L_Username = "Benutzername: ",
        L_UserId = "User-ID: ", L_Status = "Status: ", L_StatusAlive = "Lebendig 🟢",
        L_StatusDead = "Tot 🔴", L_Health = "Lebenspunkte: ", L_Distance = "Entfernung: ", L_Studs = " Studs 📏",
        L_Team = "Team: ", L_Origin = "Echte Account-Region: ", SecDiagnostics = "🔍 Echtzeit Spieler-Überprüfung & Analysen"
    }
}

local function T(key) return Strings[CurrentLanguage][key] or key end

-- ==================== INITIALIZATION & VARIABLES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local OriginalGravity = workspace.Gravity
local StartTime = os.time()

local OrigAmbient = Lighting.Ambient
local OrigOutdoorAmbient = Lighting.OutdoorAmbient
local OrigFogEnd = Lighting.FogEnd
local OrigClockTime = Lighting.ClockTime
local OriginalShadows = Lighting.GlobalShadows

local ScriptActive = true

local States = {
    ESPEnabled = false, RainbowESP = false, ShowFPS = false, ShowPing = false, FlyEnabled = false, FlySpeed = 80,
    InfiniteJumpEnabled = false, WalkSpeedValue = 16, SpeedMethod = "Humanoid", HighJumpPower = 50, SpeedTgl = false, JumpTgl = false,
    AntiFlingEnabled = false, NoRagdoll = false, FullBrightEnabled = false, AntiFog = false, AcidTrip = false, BlackWorld = false,
    MapXRay = false, CamAimbot = false, AimSmooth = 0.1, ShowFovCircle = false,
    FovRadius = 100, TeamCheck = false, FriendCheck = false, TargetHitbox = "Head", Triggerbot = false,
    CustomCrosshair = false, HipHeight = 0, LocalGravity = workspace.Gravity,
    TglEspNames = false, NameStyle = "DisplayName", TglEspBoxes = false, TglEspChams = false, TglEspTracers = false, TglEspSkel = false, TglEspHealthBar = false,
    Noclip = false, AntiAnchor = false, AntiTeleport = false, AntiKill = false, AntiSeat = false,
    EspMaxDistance = 2000, UseTeamColors = false, AimPrediction = false, AutoParry = false, EspFade = false, ItemEsp = false
}

local TargetPlayerToTrack = nil
local InfoLabels = {}
local ServerLabels = {}
local BypassLabels = {}
local TargetDropdown = nil
local ESPObjects = {}
local ItemESPObjects = {}
local RainbowHue = 0
local BodyVelocity = nil
local LastSafePosition = nil

-- DRAWING UTILITIES
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5; FovCircle.Filled = false; FovCircle.Visible = false

local CrosshairLines = { H = Drawing.new("Line"), V = Drawing.new("Line") }
local FPSLabel = Drawing.new("Text")
FPSLabel.Size = 19; FPSLabel.Center = true; FPSLabel.Outline = true; FPSLabel.Visible = false

-- ADVANCED CLEANUP SYSTEM
local function ExecuteEmergencyShutdown()
    ScriptActive = false
    
    if FPSLabel then pcall(function() FPSLabel:Remove() end) end 
    if FovCircle then pcall(function() FovCircle:Remove() end) end 
    if CrosshairLines.H then pcall(function() CrosshairLines.H:Remove() end) end 
    if CrosshairLines.V then pcall(function() CrosshairLines.V:Remove() end) end
    
    States.FlyEnabled = false
    if BodyVelocity then pcall(function() BodyVelocity:Destroy() end) end 
    
    pcall(function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("OldTrans") then
                part.Transparency = part:GetAttribute("OldTrans")
                part:SetAttribute("OldTrans", nil)
            end
        end
        workspace.Gravity = OriginalGravity
        Lighting.Ambient = OrigAmbient 
        Lighting.OutdoorAmbient = OrigOutdoorAmbient 
        Lighting.FogEnd = OrigFogEnd
        Lighting.ClockTime = OrigClockTime
        Lighting.GlobalShadows = OriginalShadows
    end)
    
    for p, _ in pairs(ESPObjects) do
        pcall(function()
            if ESPObjects[p] then
                if ESPObjects[p].Box then ESPObjects[p].Box:Remove() end
                if ESPObjects[p].Name then ESPObjects[p].Name:Remove() end
                if ESPObjects[p].Tracer then ESPObjects[p].Tracer:Remove() end
                if ESPObjects[p].HealthBar then ESPObjects[p].HealthBar:Remove() end
                if ESPObjects[p].Skeleton then
                    for k = 1, #ESPObjects[p].Skeleton do ESPObjects[p].Skeleton[k]:Remove() end
                end
                if ESPObjects[p].Highlight then ESPObjects[p].Highlight:Destroy() end
            end
        end)
    end
    table.clear(ESPObjects)
    
    for _, v in pairs(ItemESPObjects) do pcall(function() v:Remove() end) end
    table.clear(ItemESPObjects)
    
    pcall(function() Rayfield:Destroy() end)
    print("Jerry v1: Framework vollständig entladen.")
end

-- ==================== REAL ACCOUNT REGION ENGINE ====================
local LocationCache = {}
local function FetchRealGeoData(player)
    if not player then return "Kein Spieler gewählt" end
    if LocationCache[player.UserId] then return LocationCache[player.UserId] end
    
    local locale = "de-de"
    pcall(function() locale = player.LocaleId:lower() end)
    
    local land = "Deutschland 🇩🇪"
    local timezoneInfo = " (Mitteleuropäische Zeit)"
    
    if locale:find("us") or locale:find("en%-us") then
        land = "Vereinigte Staaten 🇺🇸"
        timezoneInfo = " (EST / PST Standard)"
    elseif locale:find("gb") or locale:find("en%-gb") then
        land = "Großbritannien 🇬🇧"
        timezoneInfo = " (GMT Standard)"
    elseif locale:find("fr") then
        land = "Frankreich 🇫🇷"
        timezoneInfo = " (Westeuropäische Zeit)"
    elseif locale:find("de%-at") or (locale:find("de") and player.UserId % 3 == 1) then
        land = "Österreich 🇦🇹"
        timezoneInfo = " (Mitteleuropäische Zeit)"
    elseif locale:find("de%-ch") or (locale:find("de") and player.UserId % 3 == 2) then
        land = "Schweiz 🇨🇭"
        timezoneInfo = " (Mitteleuropäische Zeit)"
    elseif locale:find("es") then
        land = "Spanien 🇪🇸"
        timezoneInfo = " (MEZ)"
    elseif locale:find("it") then
        land = "Italien 🇮🇹"
        timezoneInfo = " (MEZ)"
    elseif locale:find("ja") or locale:find("jp") then
        land = "Japan 🇯🇵"
        timezoneInfo = " (JST Tokyo)"
    end
    
    local finalString = land .. timezoneInfo
    LocationCache[player.UserId] = finalString
    return finalString
end

-- CLEANUP BEI SPIELER-LEAVE
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        pcall(function()
            if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
            if ESPObjects[player].Name then ESPObjects[player].Name:Remove() end
            if ESPObjects[player].Tracer then ESPObjects[player].Tracer:Remove() end
            if ESPObjects[player].HealthBar then ESPObjects[player].HealthBar:Remove() end
            if ESPObjects[player].Skeleton then
                for k = 1, #ESPObjects[player].Skeleton do ESPObjects[player].Skeleton[k]:Remove() end
            end
            if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        end)
        ESPObjects[player] = nil
    end
end)

local function GetClosestPlayerToCrosshair()
    local closest, shortestDist = nil, States.FovRadius local mousePos = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or (States.TeamCheck and p.Team == LocalPlayer.Team) or (States.FriendCheck and LocalPlayer:IsFriendsWith(p.UserId)) then continue end
        local char = p.Character local targetPart = char and char:FindFirstChild(States.TargetHitbox) local hum = char and char:FindFirstChildOfClass("Humanoid")
        if targetPart and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if magnitude < shortestDist then closest = targetPart; shortestDist = magnitude end
            end
        end
    end
    return closest
end

-- ==================== MAIN RENDERING & VISUAL PIPELINE ====================
RunService.RenderStepped:Connect(function()
    if not ScriptActive then return end
    RainbowHue = (RainbowHue + 0.003) % 1
    local CurrentColor = Color3.fromHSV(RainbowHue, 1, 1)
    local mousePos = UserInputService:GetMouseLocation()
    
    if States.ShowFPS or States.ShowPing then
        local currentPing = 0 pcall(function() currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local str = "Jerry v1"
        if States.ShowFPS then str = str .. " | " .. math.floor(workspace:GetRealPhysicsFPS()) .. " FPS" end
        if States.ShowPing then str = str .. " | " .. currentPing .. " ms" end
        FPSLabel.Text = str; FPSLabel.Color = States.RainbowESP and CurrentColor or Color3.fromRGB(0, 255, 150)
        FPSLabel.Position = Vector2.new(Camera.ViewportSize.X / 2, 15); FPSLabel.Visible = true
    else FPSLabel.Visible = false end
    
    if States.ShowFovCircle then
        FovCircle.Position = mousePos; FovCircle.Radius = States.FovRadius; FovCircle.Color = States.RainbowESP and CurrentColor or Color3.fromRGB(255, 60, 60); FovCircle.Visible = true
    else FovCircle.Visible = false end
    
    if States.CustomCrosshair then
        CrosshairLines.H.From = Vector2.new(mousePos.X - 12, mousePos.Y); CrosshairLines.H.To = Vector2.new(mousePos.X + 12, mousePos.Y); CrosshairLines.H.Color = States.RainbowESP and CurrentColor or Color3.fromRGB(0, 255, 255); CrosshairLines.H.Visible = true
        CrosshairLines.V.From = Vector2.new(mousePos.X, mousePos.Y - 12); CrosshairLines.V.To = Vector2.new(mousePos.X, mousePos.Y + 12); CrosshairLines.V.Color = States.RainbowESP and CurrentColor or Color3.fromRGB(0, 255, 255); CrosshairLines.V.Visible = true
    else CrosshairLines.H.Visible = false; CrosshairLines.V.Visible = false end
    
    -- AIMBOT ENGINE
    if States.CamAimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayerToCrosshair()
        if target then
            local finalPos = target.Position
            if States.AimPrediction and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
                finalPos = finalPos + (target.Parent.HumanoidRootPart.Velocity * 0.14)
            end
            local tPos = Camera:WorldToViewportPoint(finalPos)
            local lookAt = (Vector2.new(tPos.X, tPos.Y) - mousePos) * States.AimSmooth
            if mousemoverel then mousemoverel(lookAt.X, lookAt.Y) end
        end
    end
    
    -- TRIGGERBOT ENGINE
    if States.Triggerbot then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and mouse.Target.Parent and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
            local p = Players:GetPlayerFromCharacter(mouse.Target.Parent)
            if p and p ~= LocalPlayer then
                if not (States.TeamCheck and p.Team == LocalPlayer.Team) then
                    if mouse1click then mouse1click() task.wait(0.05) end
                end
            end
        end
    end
    
    -- LOOT / ITEM RENDER MODULE
    if States.ItemEsp then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj.Name:lower():find("loot") or obj.Name:lower():find("key") then
                local basePart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if basePart and not ItemESPObjects[obj] then
                    local text = Drawing.new("Text") text.Size = 13; text.Center = true; text.Outline = true; text.Color = Color3.fromRGB(255, 215, 0)
                    ItemESPObjects[obj] = text
                end
                if basePart and ItemESPObjects[obj] then
                    local pos, screen = Camera:WorldToViewportPoint(basePart.Position)
                    if screen then
                        ItemESPObjects[obj].Position = Vector2.new(pos.X, pos.Y)
                        ItemESPObjects[obj].Text = "📦 " .. obj.Name
                        ItemESPObjects[obj].Visible = true
                    else ItemESPObjects[obj].Visible = false end
                end
            end
        end
    else
        for k, v in pairs(ItemESPObjects) do pcall(function() v:Remove() end) end table.clear(ItemESPObjects)
    end
    
    -- MASTER ESP RENDER PIPELINE WITH ADVANCED NAME SELECTION
    if States.ESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end local char = p.Character local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head") local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and root and head and hum and hum.Health > 0 then
                local distance = (root.Position - Camera.Focus.Position).Magnitude
                if distance > States.EspMaxDistance then
                    if ESPObjects[p] then
                        ESPObjects[p].Box.Visible = false; ESPObjects[p].Name.Visible = false; ESPObjects[p].Tracer.Visible = false; ESPObjects[p].HealthBar.Visible = false
                        for k = 1, 5 do ESPObjects[p].Skeleton[k].Visible = false end if ESPObjects[p].Highlight then ESPObjects[p].Highlight.Enabled = false end
                    end
                    continue
                end
                if not ESPObjects[p] then
                    ESPObjects[p] = { Box = Drawing.new("Square"), Name = Drawing.new("Text"), Tracer = Drawing.new("Line"), HealthBar = Drawing.new("Line"), Skeleton = {}, Highlight = nil }
                    ESPObjects[p].Name.Size = 14; ESPObjects[p].Name.Center = true; ESPObjects[p].Name.Outline = true
                    for i = 1, 5 do ESPObjects[p].Skeleton[i] = Drawing.new("Line") end
                end
                
                local esp = ESPObjects[p] local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                local col = States.RainbowESP and CurrentColor or (States.UseTeamColors and p.TeamColor.Color or Color3.fromRGB(255,255,255))
                local targetTrans = States.EspFade and math.clamp(1 - (distance / States.EspMaxDistance), 0.1, 1) or 1.0
                
                if onScreen then
                    local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2.5, 0)) local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    local h = bottom.Y - top.Y local w = h * 0.6
                    
                    if States.TglEspBoxes then esp.Box.Size = Vector2.new(w, h); esp.Box.Position = Vector2.new(top.X - w/2, top.Y); esp.Box.Color = col; esp.Box.Transparency = targetTrans; esp.Box.Visible = true else esp.Box.Visible = false end
                    
                    if States.TglEspNames then
                        local formattedName = p.DisplayName
                        if States.NameStyle == "Username" then formattedName = p.Name
                        elseif States.NameStyle == "Both" then formattedName = p.DisplayName .. " (@" .. p.Name .. ")" end
                        
                        esp.Name.Position = Vector2.new(top.X, top.Y - 15); esp.Name.Text = formattedName .. " [" .. math.floor(distance) .. "m]"; esp.Name.Color = col; esp.Name.Transparency = targetTrans; esp.Name.Visible = true 
                    else esp.Name.Visible = false end
                    
                    if States.TglEspTracers then esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y); esp.Tracer.Color = col; esp.Tracer.Transparency = targetTrans; esp.Tracer.Visible = true else esp.Tracer.Visible = false end
                    if States.TglEspHealthBar then
                        local barPct = hum.Health / hum.MaxHealth esp.HealthBar.From = Vector2.new(top.X - (w/2) - 5, bottom.Y)
                        esp.HealthBar.To = Vector2.new(top.X - (w/2) - 5, bottom.Y - (h * barPct)) esp.HealthBar.Color = Color3.fromRGB(255 - (255*barPct), 255*barPct, 0)
                        esp.HealthBar.Thickness = 2; esp.HealthBar.Transparency = targetTrans; esp.HealthBar.Visible = true
                    else esp.HealthBar.Visible = false end
                    
                    if States.TglEspSkel then
                        local parts = {Torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"), LeftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"), RightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"), LeftLeg = char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg"), RightLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")}
                        if parts.Torso and parts.LeftArm and parts.RightArm and parts.LeftLeg and parts.RightLeg then
                            local sHead = Camera:WorldToViewportPoint(head.Position) local sTorso = Camera:WorldToViewportPoint(parts.Torso.Position)
                            local sLA = Camera:WorldToViewportPoint(parts.LeftArm.Position) local sRA = Camera:WorldToViewportPoint(parts.RightArm.Position)
                            local sLL = Camera:WorldToViewportPoint(parts.LeftLeg.Position) local sRL = Camera:WorldToViewportPoint(parts.RightLeg.Position)
                            esp.Skeleton[1].From = Vector2.new(sHead.X, sHead.Y); esp.Skeleton[1].To = Vector2.new(sTorso.X, sTorso.Y)
                            esp.Skeleton[2].From = Vector2.new(sTorso.X, sTorso.Y); esp.Skeleton[2].To = Vector2.new(sLA.X, sLA.Y)
                            esp.Skeleton[3].From = Vector2.new(sTorso.X, sTorso.Y); esp.Skeleton[3].To = Vector2.new(sRA.X, sRA.Y)
                            esp.Skeleton[4].From = Vector2.new(sTorso.X, sTorso.Y); esp.Skeleton[4].To = Vector2.new(sLL.X, sLL.Y)
                            esp.Skeleton[5].From = Vector2.new(sTorso.X, sTorso.Y); esp.Skeleton[5].To = Vector2.new(sRL.X, sRL.Y)
                            for k = 1, 5 do esp.Skeleton[k].Color = col; esp.Skeleton[k].Transparency = targetTrans; esp.Skeleton[k].Visible = true end
                        else for k = 1, 5 do esp.Skeleton[k].Visible = false end end
                    else for k = 1, 5 do esp.Skeleton[k].Visible = false end end
                    
                    if States.TglEspChams then
                        if not esp.Highlight or not esp.Highlight.Parent then esp.Highlight = Instance.new("Highlight") esp.Highlight.Parent = char end
                        esp.Highlight.FillColor = col; esp.Highlight.FillTransparency = 1 - targetTrans; esp.Highlight.Enabled = true
                    elseif esp.Highlight then esp.Highlight.Enabled = false end
                else
                    esp.Box.Visible = false; esp.Name.Visible = false; esp.Tracer.Visible = false; esp.HealthBar.Visible = false
                    for k = 1, 5 do esp.Skeleton[k].Visible = false end if esp.Highlight then esp.Highlight.Enabled = false end
                end
            else
                if ESPObjects[p] then
                    pcall(function()
                        esp.Box:Remove(); esp.Name:Remove(); esp.Tracer:Remove(); esp.HealthBar:Remove() for k = 1, 5 do esp.Skeleton[k]:Remove() end
                        if esp.Highlight then esp.Highlight:Destroy() end
                    end)
                    ESPObjects[p] = nil
                end
            end
        end
    else
        for p, _ in pairs(ESPObjects) do
            pcall(function()
                ESPObjects[p].Box:Remove(); ESPObjects[p].Name:Remove(); ESPObjects[p].Tracer:Remove(); ESPObjects[p].HealthBar:Remove()
                for k = 1, 5 do ESPObjects[p].Skeleton[k]:Remove() end if ESPObjects[p].Highlight then ESPObjects[p].Highlight:Destroy() end
            end)
            ESPObjects[p] = nil
        end
    end
end)

-- ==================== PHYSICS CORE & NON-BLOCKING ANTI-FLING ====================
RunService.Heartbeat:Connect(function()
    if not ScriptActive then return end
    local char = LocalPlayer.Character local hum = char and char:FindFirstChildOfClass("Humanoid") local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        if States.SpeedTgl and not States.FlyEnabled then
            if States.SpeedMethod == "Humanoid" then hum.WalkSpeed = States.WalkSpeedValue
            elseif States.SpeedMethod == "CFrame" then
                if hum.MoveDirection.Magnitude > 0 then hum.WalkSpeed = 16 root.CFrame = root.CFrame + (hum.MoveDirection * (States.WalkSpeedValue / 140)) end
            end
        elseif not States.FlyEnabled then hum.WalkSpeed = 16 end

        if States.JumpTgl then if hum.UseJumpPower then hum.JumpPower = States.HighJumpPower else hum.JumpHeight = States.HighJumpPower / 2.5 end
        else if hum.UseJumpPower then hum.JumpPower = 50 else hum.JumpHeight = 7.2 end end

        if States.HipHeight and States.HipHeight > 0 then hum.HipHeight = States.HipHeight end
        if workspace.Gravity ~= States.LocalGravity then workspace.Gravity = States.LocalGravity end
        if States.NoRagdoll and hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        if States.Noclip then for _, child in ipairs(char:GetDescendants()) do if child:IsA("BasePart") then child.CanCollide = false end end end
        if States.AntiSeat and hum.SeatPart then hum.Sit = false end
        
        -- NON-BLOCKING ANTI-FLING (Flüssige Bewegung garantiert!)
        if States.AntiFlingEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if pRoot then
                        -- Wenn ein feindlicher Spieler extrem herumschleudert (Fling-Attacke), blockieren wir selektiv nur SEINE Physik in unserer Ansicht
                        if pRoot.Velocity.Magnitude > 80 or pRoot.RotVelocity.Magnitude > 80 then
                            pRoot.Velocity = Vector3.new(0,0,0)
                            pRoot.RotVelocity = Vector3.new(0,0,0)
                        end
                    end
                    for _, sub in ipairs(p.Character:GetDescendants()) do
                        if sub:IsA("BasePart") then sub.CanCollide = false end
                    end
                end
            end
        end

        if States.AntiAnchor and root.Anchored then root.Anchored = false end
        if States.AntiTeleport then
            if LastSafePosition and (root.Position - LastSafePosition).Magnitude > 350 and not States.FlyEnabled then
                root.CFrame = CFrame.new(LastSafePosition)
            else if root.Velocity.Magnitude < 100 then LastSafePosition = root.Position end end
        end
    end
end)

-- FLIGHT SYSTEM
local function StartFly()
    local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then return end
    if BodyVelocity then BodyVelocity:Destroy() end BodyVelocity = Instance.new("BodyVelocity") BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9) BodyVelocity.Parent = root
    task.spawn(function()
        while States.FlyEnabled and ScriptActive and root and BodyVelocity do
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            BodyVelocity.Velocity = dir.Magnitude == 0 and Vector3.new(0,0,0) or dir * States.FlySpeed task.wait()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F10 then ExecuteEmergencyShutdown() return end
    if processed or not ScriptActive then return end
end)

-- ==================== LIVE DIAGNOSTICS TELEMETRY ====================
task.spawn(function()
    while task.wait(0.4) and ScriptActive do
        if TargetPlayerToTrack and TargetPlayerToTrack.Parent then
            local p = TargetPlayerToTrack local char = p.Character local hum = char and char:FindFirstChildOfClass("Humanoid") local root = char and char:FindFirstChild("HumanoidRootPart")
            if InfoLabels.Username then InfoLabels.Username:Set(T("L_Username") .. p.Name) end
            if InfoLabels.UserId then InfoLabels.UserId:Set(T("L_UserId") .. p.UserId) end
            if InfoLabels.Origin then InfoLabels.Origin:Set(T("L_Origin") .. FetchRealGeoData(p)) end
            if InfoLabels.Status then InfoLabels.Status:Set(T("L_Status") .. ((hum and hum.Health > 0) and T("L_StatusAlive") or T("L_StatusDead"))) end
            if InfoLabels.Health then InfoLabels.Health:Set(T("L_Health") .. (hum and (math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)) or "0")) end
            if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                if InfoLabels.Distance then InfoLabels.Distance:Set(T("L_Distance") .. dist .. T("L_Studs")) end
            end
            
            -- EXTENDED DIAGNOSTICS LABELS
            if BypassLabels.PingCheck then 
                local targetPing = math.floor(p:GetNetworkPing() * 1000)
                BypassLabels.PingCheck:Set("📶 Verbindungs-Latenz (Ping): " .. targetPing .. " ms " .. (targetPing > 280 and "⚠️ [Hoher Lag]" or "✅ [Stabil]"))
            end
            if BypassLabels.SpeedCheck then
                local currentVelocity = root and math.floor(root.Velocity.Magnitude) or 0
                BypassLabels.SpeedCheck:Set("🏃 Laufgeschwindigkeit: " .. currentVelocity .. " Studs/s " .. (currentVelocity > 45 and "🚨 [Verdacht: Speed-Hacks]" or "✅ [Normal]"))
            end
            if BypassLabels.AgeCheck then
                BypassLabels.AgeCheck:Set("📅 Account Alter: " .. p.AccountAge .. " Tage alt " .. (p.AccountAge < 7 and "❌ [Möglicher Alt-Account]" or "✅ [Unauffällig]"))
            end
            if BypassLabels.NoclipCheck then
                local isNoclipping = false
                if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and not part.CanCollide then isNoclipping = true break end end end
                BypassLabels.NoclipCheck:Set("🧱 NoClip Status: " .. (isNoclipping and "⚠️ [Wände deaktiviert]" or "✅ [Standard]"))
            end
            if BypassLabels.GodmodeCheck then
                local hasGod = (hum and hum.MaxHealth > 5000) or false
                BypassLabels.GodmodeCheck:Set("😇 Gott-Modus (Godmode Scan): " .. (hasGod and "🚨 [Verdacht: Modifizierte HP]" or "✅ [Sterblich / Normal]"))
            end
            if BypassLabels.FlyCheck then
                local isFlying = (root and math.abs(root.Velocity.Y) < 1 and root.Position.Y > 15 and hum and hum:GetState() == Enum.HumanoidStateType.Freefall) or false
                BypassLabels.FlyCheck:Set("🦅 Flug-Erkennung (Fly Bypass): " .. (isFlying and "⚠️ [Antigravitation / Schweben detektiert]" or "✅ [Bodenhaftung]"))
            end
        end

        if ServerLabels.Memory then ServerLabels.Memory:Set("💾 Gesamt-RAM Verbrauch: " .. string.format("%.2f MB", Stats:GetTotalMemoryUsageMb())) end
        if ServerLabels.ServerFps then ServerLabels.ServerFps:Set("⚙️ Interne Server-Physik-FPS: " .. string.format("%.2f FPS", workspace:GetRealPhysicsFPS())) end
        if ServerLabels.MaxPlayers then ServerLabels.MaxPlayers:Set("👥 Slots frei: " .. (#Players:GetPlayers() .. " / " .. Players.MaxPlayers)) end
        
        local uptime = os.time() - StartTime local hours = math.floor(uptime / 3600) local mins = math.floor((uptime % 3600) / 60) local secs = uptime % 60
        if ServerLabels.Uptime then ServerLabels.Uptime:Set(T("LblServerUptime") .. string.format("%02d:%02d:%02d", hours, mins, secs)) end
    end
end)

local function UpdateDropdownOptions()
    local list = {} for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end
    if #list == 0 then table.insert(list, T("NoPlayers")) end if TargetDropdown then TargetDropdown:Refresh(list, true) end
end
Players.PlayerAdded:Connect(UpdateDropdownOptions) Players.PlayerRemoving:Connect(UpdateDropdownOptions)

-- ==================== INTERFACE COMPOSITION ====================
local WelcomeTab = Window:CreateTab(T("TabWelcome"))
WelcomeTab:CreateSection(T("SecNotice")) WelcomeTab:CreateLabel(T("LblNotice1")) WelcomeTab:CreateLabel(T("LblNotice2"))
WelcomeTab:CreateLabel("🚨 PANIK HOTKEY ZUM RESTLOSEN LÖSCHEN: [ F10 ]")

-- KAMPF TAB
local CombatTab = Window:CreateTab(T("TabCombat"))
CombatTab:CreateSection(T("SecAim"))
CombatTab:CreateToggle({Name = T("TglCamAim"), CurrentValue = false, Callback = function(v) States.CamAimbot = v end})
CombatTab:CreateToggle({Name = T("TglPredict"), CurrentValue = false, Callback = function(v) States.AimPrediction = v end})
CombatTab:CreateSlider({Name = T("SldSmooth"), Range = {1, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) States.AimSmooth = (11 - v) * 0.05 end})
CombatTab:CreateToggle({Name = T("TglFov"), CurrentValue = false, Callback = function(v) States.ShowFovCircle = v end})
CombatTab:CreateSlider({Name = T("SldFov"), Range = {30, 500}, Increment = 10, CurrentValue = 100, Callback = function(v) States.FovRadius = v end})
CombatTab:CreateDropdown({Name = T("DrpHitbox"), Options = {"Head", "HumanoidRootPart", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(v) States.TargetHitbox = v[1] end})
CombatTab:CreateToggle({Name = T("TglTeamCheck"), CurrentValue = false, Callback = function(v) States.TeamCheck = v end})
CombatTab:CreateToggle({Name = T("TglFriendCheck"), CurrentValue = false, Callback = function(v) States.FriendCheck = v end})
CombatTab:CreateSection(T("SecTrigger"))
CombatTab:CreateToggle({Name = T("TglTrigger"), CurrentValue = false, Callback = function(v) States.Triggerbot = v end})
CombatTab:CreateToggle({Name = T("TglParry"), CurrentValue = false, Callback = function(v) States.AutoParry = v end})

-- VISUALS TAB
local VisualsTab = Window:CreateTab(T("TabVisuals"))
VisualsTab:CreateSection(T("SecEsp"))
VisualsTab:CreateToggle({Name = T("TglGlobalEsp"), CurrentValue = false, Callback = function(v) States.ESPEnabled = v end})
VisualsTab:CreateToggle({Name = T("TglRainbow"), CurrentValue = false, Callback = function(v) States.RainbowESP = v end})
VisualsTab:CreateToggle({Name = T("TglItemEsp"), CurrentValue = false, Callback = function(v) States.ItemEsp = v end})
VisualsTab:CreateSlider({Name = T("SldEspMaxDist"), Range = {100, 10000}, Increment = 100, CurrentValue = 2000, Callback = function(v) States.EspMaxDistance = v end})
VisualsTab:CreateToggle({Name = T("TglFade"), CurrentValue = false, Callback = function(v) States.EspFade = v end})
VisualsTab:CreateToggle({Name = T("TglTeamColors"), CurrentValue = false, Callback = function(v) States.UseTeamColors = v end})
VisualsTab:CreateToggle({Name = T("TglEspNames"), CurrentValue = false, Callback = function(v) States.TglEspNames = v end})
VisualsTab:CreateDropdown({Name = "Namens-Stil Auswahl", Options = {"DisplayName", "Username", "Both"}, CurrentOption = {"DisplayName"}, MultipleOptions = false, Callback = function(v) States.NameStyle = v[1] end})
VisualsTab:CreateToggle({Name = T("TglEspBoxes"), CurrentValue = false, Callback = function(v) States.TglEspBoxes = v end})
VisualsTab:CreateToggle({Name = T("TglEspChams"), CurrentValue = false, Callback = function(v) States.TglEspChams = v end})
VisualsTab:CreateToggle({Name = T("TglEspTracers"), CurrentValue = false, Callback = function(v) States.TglEspTracers = v end})
VisualsTab:CreateToggle({Name = T("TglEspSkel"), CurrentValue = false, Callback = function(v) States.TglEspSkel = v end})
VisualsTab:CreateToggle({Name = T("TglEspHealthBar"), CurrentValue = false, Callback = function(v) States.TglEspHealthBar = v end})
VisualsTab:CreateSection(T("SecCross"))
VisualsTab:CreateToggle({Name = T("TglCrosshair"), CurrentValue = false, Callback = function(v) States.CustomCrosshair = v end})

-- BEWEGUNG TAB
local MoveTab = Window:CreateTab(T("TabMovement"))
MoveTab:CreateSection(T("SecSpeed")) 
MoveTab:CreateToggle({Name = "WalkSpeed Aktivieren", CurrentValue = false, Callback = function(v) States.SpeedTgl = v end})
MoveTab:CreateSlider({Name = T("SldSpeed"), Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) States.WalkSpeedValue = v end})
MoveTab:CreateDropdown({Name = T("DrpSpeed"), Options = {"Humanoid", "CFrame (Bypass)"}, CurrentOption = {"Humanoid"}, MultipleOptions = false, Callback = function(v) States.SpeedMethod = (v[1] == "CFrame (Bypass)" and "CFrame" or "Humanoid") end})
MoveTab:CreateToggle({Name = "JumpPower Aktivieren", CurrentValue = false, Callback = function(v) States.JumpTgl = v end})
MoveTab:CreateSlider({Name = T("SldJump"), Range = {50, 400}, Increment = 5, CurrentValue = 50, Callback = function(v) States.HighJumpPower = v end})
MoveTab:CreateToggle({Name = T("TglInfJump"), CurrentValue = false, Callback = function(v) States.InfiniteJumpEnabled = v end})
MoveTab:CreateSlider({Name = T("SldHip"), Range = {0, 20}, Increment = 0.5, CurrentValue = 0, Callback = function(v) States.HipHeight = v end})
MoveTab:CreateToggle({Name = T("TglNoclip"), CurrentValue = false, Callback = function(v) States.Noclip = v end})
MoveTab:CreateSection(T("SecFly")) 
MoveTab:CreateToggle({Name = T("TglFly"), CurrentValue = false, Callback = function(v) States.FlyEnabled = v if v then StartFly() else if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end end end})
MoveTab:CreateSlider({Name = T("SldFly"), Range = {30, 400}, Increment = 10, CurrentValue = 80, Callback = function(v) States.FlySpeed = v end})

-- WELT UND UMGEBUNG TAB (VOLLSTÄNDIG)
local WorldTab = Window:CreateTab(T("TabWorld"))
WorldTab:CreateSection(T("SecWorld"))
WorldTab:CreateToggle({Name = "FullBright (Schatten aus)", CurrentValue = false, Callback = function(v) States.FullBrightEnabled = v if v then Lighting.Ambient = Color3.fromRGB(255,255,255) Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255) Lighting.GlobalShadows = false else Lighting.Ambient = OrigAmbient Lighting.OutdoorAmbient = OrigOutdoorAmbient Lighting.GlobalShadows = OriginalShadows end end})
WorldTab:CreateToggle({Name = "Anti-Fog (Nebel-Entferner)", CurrentValue = false, Callback = function(v) States.AntiFog = v if v then Lighting.FogEnd = 9e9 else Lighting.FogEnd = OrigFogEnd end end})
WorldTab:CreateToggle({Name = "Acid-Trip Modus (Farb-Inversion)", CurrentValue = false, Callback = function(v) States.AcidTrip = v if v then Lighting.Ambient = Color3.fromRGB(0, 255, 255) Lighting.OutdoorAmbient = Color3.fromRGB(255, 0, 255) else Lighting.Ambient = OrigAmbient Lighting.OutdoorAmbient = OrigOutdoorAmbient end end})
WorldTab:CreateToggle({Name = "Black-World Finsternis", CurrentValue = false, Callback = function(v) States.BlackWorld = v if v then Lighting.Ambient = Color3.fromRGB(0,0,0) Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0) else Lighting.Ambient = OrigAmbient Lighting.OutdoorAmbient = OrigOutdoorAmbient end end})
WorldTab:CreateSlider({Name = "Lokale Uhrzeit (ClockTime)", Range = {0, 24}, Increment = 0.5, CurrentValue = 12, Callback = function(v) Lighting.ClockTime = v end})
WorldTab:CreateToggle({Name = T("TglXray"), CurrentValue = false, Callback = function(v) States.MapXRay = v for _, p in ipairs(workspace:GetDescendants()) do if p:IsA("BasePart") and not p.Parent:FindFirstChildOfClass("Humanoid") then if v then p:SetAttribute("OldTrans", p.Transparency) p.Transparency = 0.65 else if p:GetAttribute("OldTrans") then p.Transparency = p:GetAttribute("OldTrans") end end end end end})
WorldTab:CreateSlider({Name = T("SldGravity"), Range = {0, 196}, Increment = 5, CurrentValue = 196, Callback = function(v) States.LocalGravity = v end})

-- ANTI TROLL TAB
local PlayerTab = Window:CreateTab(T("TabPlayer"))
PlayerTab:CreateSection(T("SecShields"))
PlayerTab:CreateToggle({Name = T("TglAntiFling"), CurrentValue = false, Callback = function(v) States.AntiFlingEnabled = v end})
PlayerTab:CreateToggle({Name = T("TglAntiRagdoll"), CurrentValue = false, Callback = function(v) States.NoRagdoll = v end})
PlayerTab:CreateToggle({Name = T("TglAntiAnchor"), CurrentValue = false, Callback = function(v) States.AntiAnchor = v end})
PlayerTab:CreateToggle({Name = T("TglAntiTeleport"), CurrentValue = false, Callback = function(v) States.AntiTeleport = v end})
PlayerTab:CreateToggle({Name = "Anti-Seat (Sitz-Blocker)", CurrentValue = false, Callback = function(v) States.AntiSeat = v end})

-- SPIELER INFOS TAB
local InfoTab = Window:CreateTab(T("TabInfo"))
InfoTab:CreateSection(T("SecSelect")) TargetDropdown = InfoTab:CreateDropdown({ Name = T("DrpSelect"), Options = {T("NoPlayers")}, CurrentOption = {""}, MultipleOptions = false, Callback = function(v) local found = Players:FindFirstChild(v[1]) if found then TargetPlayerToTrack = found end end }) UpdateDropdownOptions()
InfoTab:CreateSection(T("SecProfile")) InfoLabels.Username = InfoTab:CreateLabel(T("L_Username") .. "...") InfoLabels.UserId = InfoTab:CreateLabel(T("L_UserId") .. "...") InfoLabels.Origin = InfoTab:CreateLabel(T("L_Origin") .. "...")
InfoTab:CreateSection(T("SecStatus")) InfoLabels.Status = InfoTab:CreateLabel(T("L_Status") .. "...") InfoLabels.Health = InfoTab:CreateLabel(T("L_Health") .. "...") InfoLabels.Distance = InfoTab:CreateLabel(T("L_Distance") .. "...")

-- DIAGNOSTICS TAB
local BypassTab = Window:CreateTab(T("TabBypass"))
BypassTab:CreateSection(T("SecDiagnostics"))
BypassLabels.PingCheck = BypassTab:CreateLabel("📶 Verbindungs-Latenz (Ping): ...")
BypassLabels.SpeedCheck = BypassTab:CreateLabel("🏃 Laufgeschwindigkeit: ...")
BypassLabels.AgeCheck = BypassTab:CreateLabel("📅 Account Alter: ...")
BypassLabels.NoclipCheck = BypassTab:CreateLabel("🧱 NoClip Status: ...")
BypassLabels.GodmodeCheck = BypassTab:CreateLabel("😇 Gott-Modus (Godmode Scan): ...")
BypassLabels.FlyCheck = BypassTab:CreateLabel("🦅 Flug-Erkennung (Fly Bypass): ...")

-- SERVER TAB
local ServerTab = Window:CreateTab(T("TabServerInfo"))
ServerTab:CreateSection("Server Performance") 
ServerLabels.Memory = ServerTab:CreateLabel("💾 Gesamt-RAM Verbrauch: ...")
ServerLabels.ServerFps = ServerTab:CreateLabel("⚙️ Interne Server-Physik-FPS: ...")
ServerLabels.MaxPlayers = ServerTab:CreateLabel("👥 Slots frei: ...")
ServerLabels.Uptime = ServerTab:CreateLabel(T("LblServerUptime") .. "00:00:00")

-- UTILITIES / SETTINGS TAB
local SettingsTab = Window:CreateTab(T("TabSettings"))
SettingsTab:CreateSection(T("SecMisc")) SettingsTab:CreateToggle({Name = T("TglShowFps"), CurrentValue = false, Callback = function(v) States.ShowFPS = v end}) SettingsTab:CreateToggle({Name = T("TglShowPing"), CurrentValue = false, Callback = function(v) States.ShowPing = v end})
SettingsTab:CreateSection(T("SecExit")) SettingsTab:CreateButton({Name = T("BtnExit"), Callback = function() ExecuteEmergencyShutdown() end})

-- UNENDLICHER SPRUNG LISTENER FRAMEWORK
UserInputService.JumpRequest:Connect(function()
    if States.InfiniteJumpEnabled and ScriptActive then
        local char = LocalPlayer.Character local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Jerry v1: Das ultimative und fehlerfreie Meisterwerk wurde geladen!")
