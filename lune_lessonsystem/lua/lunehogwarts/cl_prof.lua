AddCSLuaFile()

local lesons = "Nothing"
local subjectText = ""
local oldclass = "Nothinng"
local oldtime = "0"
local prof = LocalPlayer()

local selectedLesson = nil
local selectedSubject = nil
local selectedDuration = nil
local selectedYears = {}
local selectedHouses = {}

net.Receive("SystemMenu", function()
    local frameWidth = 400
    local frameHeight = 500

    local function ResetSelections()
        selectedLesson = nil
        selectedSubject = nil
        selectedDuration = nil
        selectedYears = {}
        selectedHouses = {}
    end

    ResetSelections()
    local slidePanels = {}

    local System = vgui.Create("DFrame")
    System:SetSize(frameWidth, frameHeight)
    System:SetTitle("")
    System:SetVisible(true)
    System:SetDraggable(false)
    System:ShowCloseButton(false)
    System:MakePopup()
    System:Center()
    System.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 0, w, 40, Color(40, 40, 40, 255))
        draw.SimpleText("Lesson System", "Trebuchet24", w / 2, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local DPanel = vgui.Create("DPanel", System)
    DPanel:SetPos(20, 50)
    DPanel:SetSize(frameWidth - 40, frameHeight - 70)
    DPanel.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(40, 40, 40, 255))
    end

    local yPos = 20
    local spacing = 40

    local function CreateLabel(text)
        local label = vgui.Create("DLabel", DPanel)
        label:SetPos(20, yPos)
        label:SetText(text)
        label:SetFont("DermaDefaultBold")
        label:SetTextColor(Color(255, 255, 255))
        label:SizeToContents()
        yPos = yPos + spacing
        return label
    end

    local LessonMenuOpen = false
    local SubjectMenuOpen = false
    local TimeMenuOpen = false
    local YearsMenuOpen = false
    local HousesMenuOpen = false

        local CloseButton = vgui.Create("DButton", System)
        CloseButton:SetText("")
        CloseButton:SetPos(frameWidth - 35, 5)
        CloseButton:SetSize(30, 30)
        CloseButton.DoClick = function()
            System:Close()
            for _, panel in ipairs(slidePanels) do
                if IsValid(panel) then
                    panel:Close()
                    ClassMenuOpen = false
                    SubjectMenuOpen = false
                    YearsMenuOpen = false
                    HousesMenuOpen = false
                    TimeMenuOpen = false
                end
            end
        end
        CloseButton.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(200, 50, 50))
            draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

    local LessonIcon = vgui.Create("DImageButton", DPanel)
    LessonIcon:SetPos(20, yPos)
    LessonIcon:SetSize(32, 32)
    LessonIcon:SetImage("lune/lesson.png")
    LessonIcon.DoClick = function()
        if not LessonMenuOpen then
            LessonMenuOpen = true
            local SlidePanel = vgui.Create("DFrame")
            SlidePanel:SetSize(400, frameHeight)
            SlidePanel:SetTitle("")
            SlidePanel:SetVisible(true)
            SlidePanel:SetDraggable(false)
            SlidePanel:ShowCloseButton(false)
            SlidePanel:SetPos(frameWidth*1.8, frameHeight - 210)
            SlidePanel:MoveTo(frameWidth - 40, frameHeight - 210, 0.1, 0, 1)
    
            SlidePanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
                draw.SimpleText("Select Lesson", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            local LessonList = vgui.Create("DListView", SlidePanel)
            LessonList:Dock(FILL)
            LessonList:AddColumn("Lessons"):SetFixedWidth(0)
            LessonList:SetHeaderHeight(1)
            LessonList:SetDataHeight(30)
            for i = 1, 8 do
                local lessonName = CONFIG["Lesson" .. i]
                if lessonName then
                    local line = LessonList:AddLine(lessonName)
                    line.Paint = function(self, w, h)
                        local bgColor = Color(60, 60, 60, 255)
                        if self:IsHovered() then
                            bgColor = Color(100, 100, 100, 255)
                        end
                        if self:IsSelected() then
                            bgColor = Color(50, 150, 255, 255)
                            selectedLesson = self:GetColumnText(1)
                            UpdateLessonName()
                        end
                        draw.RoundedBox(0, 0, 0, w, h, bgColor)
                        draw.SimpleText(" " .. self:GetColumnText(1), "DermaDefault", 5, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                end
            end
            
            LessonList.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, Color(60, 60, 60, 255))
            end
            
            LessonList.OnRowSelected = function(lst, index, pnl)
                lesons = pnl:GetColumnText(1)
                SlidePanel:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                    SlidePanel:Close()
                    LessonMenuOpen = false
                end)
            end

            table.insert(slidePanels, SlidePanel)
        end
    end
    
    local LessonNameLabel = vgui.Create("DLabel", DPanel)
    LessonNameLabel:SetPos(65, yPos + 8)
    LessonNameLabel:SetFont("DermaDefaultBold")
    LessonNameLabel:SetText("Select a lesson")
    LessonNameLabel:SetTextColor(Color(255, 255, 255))
    LessonNameLabel:SizeToContents()
    
     function UpdateLessonName()
        if selectedLesson then
            LessonNameLabel:SetText(selectedLesson)
        else
            LessonNameLabel:SetText("Select a lesson")
        end
        LessonNameLabel:SizeToContents()
    end
    

    yPos = yPos + spacing

local ClassIcon = vgui.Create("DImageButton", DPanel)
ClassIcon:SetPos(20, yPos)
ClassIcon:SetSize(32, 32)
ClassIcon:SetImage("lune/class.png")
ClassIcon.DoClick = function()
    if not ClassMenuOpen then
        ClassMenuOpen = true
        local ClassPanel = vgui.Create("DFrame")
        ClassPanel:SetSize(400, frameHeight)
        ClassPanel:SetTitle("")
        ClassPanel:SetVisible(true)
        ClassPanel:SetDraggable(false)
        ClassPanel:ShowCloseButton(false)
        ClassPanel:SetPos(frameWidth*1.8, frameHeight - 210)
        ClassPanel:MoveTo(frameWidth - 40, frameHeight - 210, 0.3, 0, 1)

        ClassPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
            draw.SimpleText("Select Class", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local Class = vgui.Create("DComboBox", ClassPanel)
        Class:SetPos(100, 50)
        Class:SetSize(200, 30)
        Class:SetValue("")

        for i = 1, 8 do
            Class:AddChoice(CONFIG["Class" .. i])
        end

        Class.OnSelect = function(_, index, value)
            oldclass = value
            UpdateSelectedClass(value)
            Class:SetValue("")
        end

        Class.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(36, 36, 36)) 
            local text = oldclass
            local bgColor = Color(255, 255, 255)
            draw.SimpleText(text, "lunebutton", w / 3 +5, h / 2 - 1, bgColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local SelectClassButton = vgui.Create("DButton", ClassPanel)
        SelectClassButton:SetPos(150, 90)
        SelectClassButton:SetSize(100, 30)
        SelectClassButton:SetText("")
        SelectClassButton.DoClick = function()
            ClassPanel:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                ClassPanel:Close()
                ClassMenuOpen = false
            end)
        end
        SelectClassButton.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(48, 48, 48))
            local bgColor = Color(255, 255, 255)
                if self:IsHovered() then
                    bgColor = Color(100, 100, 100, 255)
                end
            draw.SimpleText("Select Class", "lunebutton", w/5.5, h / 2-1, bgColor, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        table.insert(slidePanels, ClassPanel)
    end
end

local ClassLabel = vgui.Create("DLabel", DPanel)
ClassLabel:SetPos(65, yPos + 8)
ClassLabel:SetFont("DermaDefaultBold")
ClassLabel:SetText("Select class")
ClassLabel:SetTextColor(Color(255, 255, 255))
ClassLabel:SizeToContents()

function UpdateSelectedClass(selectedClass)
    ClassLabel:SetText(selectedClass)
    ClassLabel:SizeToContents()
end

    local SubjectIcon = vgui.Create("DImageButton", DPanel)
    SubjectIcon:SetPos(20, yPos+ 40)
    SubjectIcon:SetSize(32, 32)
    SubjectIcon:SetImage("lune/subject.png")
    SubjectIcon.DoClick = function()
        if not SubjectMenuOpen then
            SubjectMenuOpen = true
            local SlidePanels = vgui.Create("DFrame")
            SlidePanels:SetSize(400, 150)
            SlidePanels:SetPos(frameWidth*1.8, frameHeight - 210) 
            SlidePanels:SetTitle("")
            SlidePanels:SetVisible(true)
            SlidePanels:SetDraggable(false)
            SlidePanels:ShowCloseButton(false)
            SlidePanels:MakePopup()
            SlidePanels:MoveTo(frameWidth - 40, frameHeight - 210, 0.3, 0, 1)

            SlidePanels.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
                draw.SimpleText("Enter Subject", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            local maxLength = 50
            local subject = vgui.Create("DTextEntry", SlidePanels)
            subject:SetSize(380, 30)
            subject:SetPos(10, 40)
            subject:SetText("Enter Subject")
            subject:SetFont("lunebutton")
            subject:SetDrawBorder(false)
            subject:SetCursorColor(Color(255, 255, 255))
            subject:SetTextColor(Color(255, 255, 255))
            subject:SetDrawBackground(false)
            subject.OnChange = function(self)
                subjectText = self:GetValue()
                local text = self:GetValue()
                if #text > maxLength then
                    self:SetText(text:sub(1, maxLength))
                    self:SetCaretPos(maxLength)
                end
            end
            subject.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, Color(37, 37, 37))
                self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255), 100)
            end

            local confirmButton = vgui.Create("DButton", SlidePanels)
            confirmButton:SetText("")
            confirmButton:SetPos(150, 90)
            confirmButton:SetSize(100, 30)
            confirmButton.DoClick = function()
                if subjectText ~= "" then
                    selectedSubject = subjectText
                    UpdateSubjectName()
                    SlidePanels:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                        SlidePanels:Close()
                        SubjectMenuOpen = false
                    end)
                end
            end
            confirmButton.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, Color(48, 48, 48))
                local bgColor = Color(255, 255, 255)
                    if self:IsHovered() then
                        bgColor = Color(100, 100, 100, 255)
                    end
                draw.SimpleText("Confirm", "lunebutton", w/3.5, h / 2-1, bgColor, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            table.insert(slidePanels, SlidePanels)
        end
    end

    local SubjectNameLabel = vgui.Create("DLabel", DPanel)
    SubjectNameLabel:SetPos(65, yPos + 50)
    SubjectNameLabel:SetFont("DermaDefaultBold")
    SubjectNameLabel:SetText("Select a subject")
    SubjectNameLabel:SetTextColor(Color(255, 255, 255))
    SubjectNameLabel:SizeToContents()

    function UpdateSubjectName()
        if selectedSubject then
            SubjectNameLabel:SetText(selectedSubject)
        else
            SubjectNameLabel:SetText("Select a subject")
        end
        SubjectNameLabel:SizeToContents()
    end

local HouseIcon = vgui.Create("DImageButton", DPanel)
HouseIcon:SetPos(20, yPos+ 120)
HouseIcon:SetSize(32, 32)
HouseIcon:SetImage("lune/houses.png")
HouseIcon.DoClick = function()
    if not HousesMenuOpen then
        HousesMenuOpen = true
        local SlidePanel = vgui.Create("DFrame")
        SlidePanel:SetSize(250, frameHeight)
        SlidePanel:SetTitle("")
        SlidePanel:SetVisible(true)
        SlidePanel:SetDraggable(false)
        SlidePanel:ShowCloseButton(false)
        SlidePanel:SetPos(frameWidth*1.8,frameHeight - 210)
        SlidePanel:MoveTo(frameWidth*1.3, frameHeight - 210, 0.3, 0, 1)

        SlidePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
            draw.SimpleText("Select House", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local houseNames = {"Gryffindor", "Slytherin", "Hufflepuff", "Ravenclaw"}
        local houseCheckboxes = {}
        for i, house in ipairs(houseNames) do
            local checkbox = vgui.Create("DCheckBoxLabel", SlidePanel)
            checkbox:SetPos(SlidePanel:GetWide()/3, 50 + (i - 1) * 30)
            checkbox:SetText(house)
            checkbox:SetValue(selectedHouses[house] and 1 or 0)
            checkbox:SizeToContents()
            checkbox.OnChange = function(self, value)
                selectedHouses[house] = value
                UpdateSelectedHouses()
            end
            table.insert(houseCheckboxes, checkbox)
        end

        local SelectButton = vgui.Create("DButton", SlidePanel)
        SelectButton:SetPos(75, 200)
        SelectButton:SetSize(125, 30)
        SelectButton:SetText("")
        SelectButton.DoClick = function()
            SlidePanel:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                SlidePanel:Close()
                HousesMenuOpen = false
                UpdateSelectedHouses()
            end)
        end

        SelectButton.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(48, 48, 48))
            local bgColor = Color(255, 255, 255)
                if self:IsHovered() then
                    bgColor = Color(100, 100, 100, 255)
                end
            draw.SimpleText("Select Houses", "lunebutton", w/5.5, h / 2-1, bgColor, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        table.insert(slidePanels, SlidePanel)
    end
end

    local HousesLabel = vgui.Create("DLabel", DPanel)
    HousesLabel:SetPos(65, yPos + 130)
    HousesLabel:SetFont("DermaDefaultBold")
    HousesLabel:SetText("Select houses")
    HousesLabel:SetTextColor(Color(255, 255, 255))
    HousesLabel:SizeToContents()
    
    function UpdateSelectedHouses()
        local selected = {}
        for house, selectedValue in pairs(selectedHouses) do
            if selectedValue then
                table.insert(selected, house)
            end
        end
        if #selected > 0 then
            HousesLabel:SetText(table.concat(selected, ", "))
            print(table.concat(selected, ", "))
        else
            HousesLabel:SetText("Select houses")
        end
        HousesLabel:SizeToContents()
    end

local YearIcon = vgui.Create("DImageButton", DPanel)
YearIcon:SetPos(20, yPos + 80)
YearIcon:SetSize(32, 32)
YearIcon:SetImage("lune/year.png")
YearIcon.DoClick = function()
    if not YearsMenuOpen then
        YearsMenuOpen = true
        local SlidePanel = vgui.Create("DFrame")
        SlidePanel:SetSize(250, frameHeight)
        SlidePanel:SetTitle("")
        SlidePanel:SetVisible(true)
        SlidePanel:SetDraggable(false)
        SlidePanel:ShowCloseButton(false)
        SlidePanel:SetPos(frameWidth*1.8, frameHeight - 210)
        SlidePanel:MoveTo(frameWidth*1.3, frameHeight - 210, 0.3, 0, 1)

        SlidePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
            draw.SimpleText("Select Year", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local yearCheckboxes = {}
        for i = 1, 7 do
            local checkbox = vgui.Create("DCheckBoxLabel", SlidePanel)
            checkbox:SetPos(SlidePanel:GetWide()/2.5, 50 + (i - 1) * 30)
            checkbox:SetText("Year " .. i)
            checkbox:SetValue(selectedYears[i] and 1 or 0)
            checkbox:SizeToContents()
            checkbox.OnChange = function(self, value)
                selectedYears[i] = value
                UpdateSelectedYears()
            end
            table.insert(yearCheckboxes, checkbox)
        end

        local SelectButton = vgui.Create("DButton", SlidePanel)
        SelectButton:SetPos(75, 270)
        SelectButton:SetSize(110, 30)
        SelectButton:SetText("")
        SelectButton.DoClick = function()
            SlidePanel:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                SlidePanel:Close()
                YearsMenuOpen = false
                UpdateSelectedYears()
            end)
        end
        SelectButton.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(48, 48, 48))
            local bgColor = Color(255, 255, 255)
                if self:IsHovered() then
                    bgColor = Color(100, 100, 100, 255)
                end
            draw.SimpleText("Select Years", "lunebutton", w/5.5, h / 2-1, bgColor, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        table.insert(slidePanels, SlidePanel)
    end
end

local YearsLabel = vgui.Create("DLabel", DPanel)
YearsLabel:SetPos(65, yPos + 90)
YearsLabel:SetFont("DermaDefaultBold")
YearsLabel:SetText("Select years")
YearsLabel:SetTextColor(Color(255, 255, 255))
YearsLabel:SizeToContents()

function UpdateSelectedYears()
    local selected = {}
    for year, selectedValue in pairs(selectedYears) do
        if selectedValue then
            table.insert(selected, "Year " .. year)
        end
    end
    if #selected > 0 then
        YearsLabel:SetText(table.concat(selected, ", "))
    else
        YearsLabel:SetText("Select years")
    end
    YearsLabel:SizeToContents()
end

    local TimeIcon = vgui.Create("DImageButton", DPanel)
    TimeIcon:SetPos(20, yPos+ 160)
    TimeIcon:SetSize(32, 32)
    TimeIcon:SetImage("lune/timer.png")
    TimeIcon.DoClick = function()
        if not TimeMenuOpen then
            TimeMenuOpen = true
            local SlidePanel = vgui.Create("DFrame")
            SlidePanel:SetSize(400, frameHeight)
            SlidePanel:SetTitle("")
            SlidePanel:SetVisible(true)
            SlidePanel:SetDraggable(false)
            SlidePanel:ShowCloseButton(false)
            SlidePanel:SetPos(frameWidth*1.8, frameHeight - 210)
            SlidePanel:MoveTo(frameWidth - 40, frameHeight - 210, 0.3, 0, 1)
    
            SlidePanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
                draw.SimpleText("Select Time", "Trebuchet24", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local DNumSlider = vgui.Create("DNumSlider", SlidePanel)
            DNumSlider:SetPos(10, 50)
            DNumSlider:SetSize(380, 50)
            DNumSlider:SetText("Duration")
            DNumSlider:SetMin(1)
            DNumSlider:SetMax(20)
            DNumSlider:SetDecimals(0)
            DNumSlider.OnValueChanged = function(self, value)
                selectedDuration = math.Round(value)
                UpdateDuration()
            end

            local SelectButton = vgui.Create("DButton", SlidePanel)
            SelectButton:SetPos(150, 110)
            SelectButton:SetSize(140, 30)
            SelectButton:SetText("")
            SelectButton.DoClick = function()
                oldtime = tostring(DNumSlider:GetValue())
                SlidePanel:MoveTo(frameWidth*1.8, frameHeight/2 + 40, 0.3, 0, 1, function()
                    SlidePanel:Close()
                    TimeMenuOpen = false
                    UpdateDuration()
                end)
            end
            SelectButton.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, Color(48, 48, 48))
                local bgColor = Color(255, 255, 255)
                    if self:IsHovered() then
                        bgColor = Color(100, 100, 100, 255)
                    end
                draw.SimpleText("Select Duration", "lunebutton", w/5.5, h / 2-1, bgColor, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            table.insert(slidePanels, SlidePanel)
        end
    end

    local DurationLabel = vgui.Create("DLabel", DPanel)
    DurationLabel:SetPos(65, yPos + 170)
    DurationLabel:SetFont("DermaDefaultBold")
    DurationLabel:SetText("Select duration")
    DurationLabel:SetTextColor(Color(255, 255, 255))
    DurationLabel:SizeToContents()

    function UpdateDuration()
        if selectedDuration then
            DurationLabel:SetText(tostring(selectedDuration) .. " mins")
        else
            DurationLabel:SetText("Select duration")
        end
        DurationLabel:SizeToContents()
    end

    local HelpLabel = vgui.Create("DLabel", DPanel)
    HelpLabel:SetPos(20, yPos + 200)
    HelpLabel:SetText("It is currently a Beta Version. Notify if you find a bug.")
    HelpLabel:SetFont("DermaDefaultBold")
    HelpLabel:SetTextColor(Color(255, 255, 255))
    HelpLabel:SizeToContents()

    local function ShowErrorMessage(message)
        local errorFrame = vgui.Create("DFrame")
        errorFrame:SetSize(300, 100)
        errorFrame:SetTitle("Error")
        errorFrame:ShowCloseButton(false)
        errorFrame:Center()
        errorFrame:MakePopup()

        local DPanel = vgui.Create("DPanel", errorFrame)
        DPanel:SetPos(0, 0)
        DPanel:SetSize(errorFrame:GetWide(), errorFrame:GetTall())
        DPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 255))
        end

        local CloseButton = vgui.Create("DButton", DPanel)
        CloseButton:SetText("")
        CloseButton:SetPos(errorFrame:GetWide() - 35, 5)
        CloseButton:SetSize(30, 30)
        CloseButton.DoClick = function()
            errorFrame:Close()
        end
        CloseButton.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(200, 50, 50))
            draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    
        local errorMessage = vgui.Create("DLabel", DPanel)
        errorMessage:SetText(message)
        errorMessage:SetFont("luneerrorfont")
        errorMessage:SetContentAlignment(5)
        errorMessage:Dock(FILL)
        table.insert(slidePanels, errorFrame)
    end
    
    local function CheckSelections()
        if not selectedLesson or not selectedSubject or not selectedDuration or table.IsEmpty(selectedYears) or table.IsEmpty(selectedHouses) then
            ShowErrorMessage("You haven't selected all options. Please check again.")
            return false
        end
        return true
    end

    local StartButton = vgui.Create("DButton", DPanel)
    StartButton:SetText("")
    StartButton:SetPos(20, yPos + 220)
    StartButton:SetSize(DPanel:GetWide() - 40, 40)
    StartButton.DoClick = function()
        if not CheckSelections() then
            return
        end

        local selectedHouseList = {}
        for house, isSelected in pairs(selectedHouses) do
            if isSelected then
                table.insert(selectedHouseList, house)
            end
        end

        local selectedYearsList = {}
        for year, isSelected in pairs(selectedYears) do
            if isSelected then
                table.insert(selectedYearsList, year)
            end
        end

        local lessonData = {
            lessonn =selectedLesson,
            newclas = oldclass,
            newsubject = selectedSubject,
            newtime = selectedDuration,
            newyear = selectedYearsList,
            newhouses = selectedHouseList,
            lessoncreator = LocalPlayer()
          }
          net.Start("startlesson")
          net.WriteTable(lessonData)
          net.SendToServer()
    end
    StartButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 200, 50, 255))
        draw.SimpleText("Start Lesson", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)
