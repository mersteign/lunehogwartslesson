LUNE = LUNE or {}

function LUNE:Log(message, color)
    MsgC(color or Color(255, 255, 255), message .. "\n")
end

function LUNE:ProcessFile(filePath, fileName)
    local prefix = string.sub(fileName, 1, 3)

    if SERVER then
        if prefix == "cl_" then
            AddCSLuaFile(filePath)
            self:Log("Added client-side file: " .. filePath, Color(0, 150, 255))
        elseif prefix == "sv_" then
            include(filePath)
            self:Log("Included server-side file: " .. filePath, Color(255, 150, 0))
        elseif prefix == "sh_" then
            AddCSLuaFile(filePath)
            include(filePath)
            self:Log("Included shared file: " .. filePath, Color(150, 255, 0))
        else
            self:Log("Unknown prefix in file: " .. filePath, Color(255, 0, 0))
        end
    elseif CLIENT then
        if prefix == "cl_" or prefix == "sh_" then
            include(filePath)
            self:Log("Included client/shared file: " .. filePath, Color(0, 150, 255))
        end
    end
end

function LUNE:InitializeFiles(directory, systemname)
    local files, directories = file.Find(directory .. "/*", "LUA")

    for _, fileName in ipairs(files) do
        local filePath = directory .. "/" .. fileName
        self:ProcessFile(filePath, fileName)
    end

    for _, subdirectory in ipairs(directories) do
        self:InitializeFiles(directory .. "/" .. subdirectory, systemname)
    end

    self:Log(systemname .. " successfully loaded. (" .. #files .. " files.)", Color(0, 255, 0))
end

LUNE:InitializeFiles("lunehogwarts", "LessonSystem")