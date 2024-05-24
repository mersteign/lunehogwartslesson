AddCSLuaFile()
resource.AddFile("materials/lune/book.png")
resource.AddFile("materials/lune/time.png")
resource.AddFile("sound/lune/newbell.wav")

local san = false
local sound = Sound("lune/newbell.wav")
local book = Material("lune/book.png")
local time = Material("lune/time.png")

local hudWidth = 400
local hudHeight = 110

net.Receive("beginlesson", function()
    local lessonYears = {}
    local lessonHouses = {}
    local lessonName = net.ReadString()
    local lessonClass = net.ReadString()
    local lessonSubject = net.ReadString()
    local lessonTime = net.ReadString()
    lessonYears = net.ReadTable()
    lessonHouses = net.ReadTable()
    
    print("Lesson Houses: " .. table.concat(lessonHouses, ", "))
    print("Lesson Years: " .. table.concat(lessonYears, ", "))
        
    timer.Simple(1, function()
        surface.PlaySound(sound)
    end)

    hook.Add("HUDPaint", "Lune", function() 
        if san == false then
            timer.Create("LessonTimer", lessonTime, 1, function() san = false end)
            san = true
        end
        local suree = string.ToMinutesSeconds(timer.TimeLeft("LessonTimer"))

        local screenW, screenH = ScrW(), ScrH()
        local hudX = (screenW - hudWidth) / 2
        local hudY = screenH - hudHeight - 55

        local bookX, bookY = hudX + 10, hudY + 5
        local time1X, time1Y = hudX + 300, hudY + 5
        local time2X, time2Y = hudX + 355, hudY + 5

        draw.RoundedBox(20, hudX, hudY, hudWidth, hudHeight, Color(0, 0, 0, 145))
        surface.SetMaterial(book)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(bookX, bookY, 24, 24)
        surface.SetMaterial(time)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(time1X, time1Y, 20, 20)
        surface.DrawTexturedRect(time2X, time2Y, 20, 20)

        draw.SimpleText(lessonName, "LuneLesson", hudX + 40, hudY + 4, Color(255, 255, 255, 255))
        draw.SimpleText("Subject: " .. lessonSubject, "LuneLessonHud", hudX + 15, hudY + 25, Color(255, 255, 255, 255))
        draw.SimpleText("Class: " .. lessonClass, "LuneLessonHud", hudX + 15, hudY + 45, Color(255, 255, 255, 255))
        draw.SimpleText(suree, "LuneLessonHud", hudX + 320, hudY + 5, Color(255, 255, 255, 255))

        -- Years
        local romanNumerals = { "I", "II", "III", "IV", "V", "VI", "VI" }
        local activeYears = {}
        
        for i, yearValue in ipairs(lessonYears) do
          if yearValue >= 1 and yearValue <= #romanNumerals then
            table.insert(activeYears, romanNumerals[yearValue])
          end
        end
        
        table.sort(activeYears)
        
        local yearSpacing = 10
        local totalYearWidth = 0
        
        surface.SetFont("LuneLessonYears")
        for _, yearText in ipairs(activeYears) do
          totalYearWidth = totalYearWidth + surface.GetTextSize(yearText)
        end
        
        local startY = hudX + (hudWidth - totalYearWidth - (#activeYears - 1) * yearSpacing) / 2
        
        for i, yearText in ipairs(activeYears) do
          draw.SimpleText(yearText, "LuneLessonYears", startY, hudY + 85, Color(0, 238, 118, 255))
          startY = startY + surface.GetTextSize(yearText) + yearSpacing
        end
        
        -- Houses
        local activeHouses = {}
        local houseTexts = {"Gryffindor", "Slytherin", "Hufflepuff", "Ravenclaw"}

        for i, isSelected in ipairs(lessonHouses) do
            if isSelected then
                table.insert(activeHouses, houseTexts[i])
            end
        end

        local houseSpacing = 10
        local totalHouseWidth = 0

        surface.SetFont("LuneLessonHouse")
        for _, houseText in ipairs(activeHouses) do
            totalHouseWidth = totalHouseWidth + surface.GetTextSize(houseText)
        end

        local startX = hudX + (hudWidth - totalHouseWidth - (#activeHouses - 1) * houseSpacing) / 2

        for i, houseText in ipairs(activeHouses) do
            draw.SimpleText(houseText, "LuneLessonHouse", startX, hudY + hudHeight - 43, Color(255, 255, 255, 255))
            startX = startX + surface.GetTextSize(houseText) + houseSpacing
        end
    end)
end)

net.Receive("lessoncanend", function()
    hook.Remove("HUDPaint", "Lune")
    san = false
end)
