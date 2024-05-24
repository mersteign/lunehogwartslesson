local lessonData = {
  lessonn = "",
  newclas = "",
  newsubject = "",
  newtime = "0",
  newhouses = {},
  newyear = {},
  lessoncreator = "",
}

local lessonstarted = false

local function AddNetworkStrings()
  util.AddNetworkString("lessoncanend")
  util.AddNetworkString("SystemMenu")
  util.AddNetworkString("startlesson")
  util.AddNetworkString("stoplesson")
  util.AddNetworkString("beginlesson")
end

hook.Add( "PlayerSay", "profsay", function( ply, text, public )
  local prof = ply:getDarkRPVar("job")
  if ( string.lower( text ) == "!lesson" ) then
  if table.HasValue(CONFIG.JOBS,prof) then
    net.Start("SystemMenu")
    net.Send(ply)
  else
    DarkRP.notify(ply, 1, 4, "You don't have permission to use this command!")
    end
  end
  end )


local function BeginLesson(len, ply)
  if not lessonstarted then
      lessonstarted = true

      local lessonData = net.ReadTable()
    
      lessonName = lessonData.lessonn
      lessonClass = lessonData.newclas
      lessonSubject = lessonData.newsubject
      lessonTime = lessonData.newtime
      lessonYears = lessonData.newyear
      lessonHouses = lessonData.newhouses
      startingprof = lessonData.lessoncreator

      net.Start( "beginlesson" )
      net.WriteString(tostring(lessonName))
      net.WriteString(tostring(lessonClass)) 
      net.WriteString(tostring(lessonSubject)) 
      net.WriteString(tostring(lessonTime*60))
      net.WriteTable(lessonYears)
      net.WriteTable(lessonHouses)
      net.WriteString(tostring(startingprof))

      net.Broadcast()

      timer.Create("TimerS", lessonTime*60, 1, function()
          net.Start("lessoncanend")
          net.Broadcast()
          lessonstarted = false
      end)
  else
      ply:ChatPrint("There is already a lesson.")
  end
end

hook.Add("PlayerInitialSpawn", "Lessonss", function() 
  if lessonstarted == true then
    net.Start( "beginlesson" )
    net.WriteString(tostring(lessonName))
    net.WriteString(tostring(lessonClass)) 
    net.WriteString(tostring(lessonSubject)) 
    net.WriteString(tostring(lessonTime*60))
    net.WriteTable(lessonYears)
    net.WriteTable(lessonHouses)
    net.WriteString(tostring(startingprof))
  net.Broadcast()
  end
  end)

local function StopLesson(ply)
  if startingprof == ply then
     net.Start("lessoncanend")
       net.Broadcast()
       lessonstarted = false
  else
     ply:SendLua([[chat.AddText(Color(255, 0, 0), "You are not the professor of the current lesson.")]])
  end
 end

local function LuneStopLesson(player, command, arguments)
  if player:IsSuperAdmin() then
      net.Start("lessoncanend")
      net.Broadcast()
      lessonstarted = false
  else
      player:SendLua([[chat.AddText(Color(255, 0, 0), "You can't use this command.")]])
  end
end

concommand.Add("lune_stoplesson", LuneStopLesson)

net.Receive("startlesson", BeginLesson)
net.Receive("stoplesson", function(len, ply)
  local player = ply
  StopLesson(player)
 end)

AddNetworkStrings()