local gui = loadstring(game.HttpGet(game, ('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local clr = Color3.fromRGB
_G.NOTIF = false
_G.MainColor = clr(48,48,48)
_G.SecondaryColor = clr(48,48,48)
_G.TertiaryColor = clr(32,32,32)
_G.ArrowColor = clr(255,255,255)
_G.MainTextColor = clr(255,255,255)
_G.PointerColor = clr(255,255,255)
_G.ButtonTextColor = clr(255,255,255)
_G.SliderColor = clr(128,0,0)
_G.ButtonColor = clr(48,48,48)
_G.ToggleColor = clr(48,48,48)
_G.DraggerCircleColor = clr(255,255,255)
_G.BindColor = clr(48,48,48)
local w = gui.CreateWindow(gui, "Rise of Nations")
local b = w.CreateFolder(w, "Trade Bot") 
local b3 = w.CreateFolder(w, "Misc")
local exps = require(workspace.FunctionDump.ValueCalc.CountryExpenses)
local rev = require(workspace.FunctionDump.ValueCalc.CountryRevenue)
local rs = game.GetService(game, "RunService")
local rs2 = game.GetService(game, "ReplicatedStorage")
local alrt = game.Players.LocalPlayer.PlayerGui.GameGui.MainFrame
local units = workspace.Units
local camval = Enum.RenderPriority.Camera.Value
local bp = workspace.Baseplate.Cities
local ctrs = workspace.Countries
local plctr = game.Players.LocalPlayer.leaderstats.Country.Value
local cdd2 = workspace.CountryData
local cdd = cdd2[plctr].Economy
local cd = cdd2[plctr].Resources
local get_c = game.GetChildren
local get_cu = get_c(units)
local gcbp = get_c(bp)
local gccd = get_c(cd)
local rsar = rs2.Assets.Resources
local rnd = math.round
local sr = "SendRequest"
local pr = "PuppetRequest"
local slctrsc
local slctctr
local ct2 = 0 
local ct6 = 1
local inf = {
    [1] = '', 
    [2] = '', 
    [3] = 0, 
    [4] = 1, 
    [5] = ''
}
local bye = {
    [1] = "Trade accepted",
    [2] = "Trade offer declined",
    [3] = "Trade Cancelled",
    [4] = "Alliance declined",
    [5] = "Modifier Lost!",
    [6] = "New Modifier!",
    [7] = "Trade Declined",
    [8] = "Trade declined"
}


local function rscs()
    local rsc = {}
    local rsrcs = {}
    local ct5 = 0

    for i,v in ipairs(get_c(cd)) do
        local n = v.Name
        ct5 = ct5 + 1
        table.insert(rsrcs, ct5, n)
        rsc[n] = {byp = 0, slp = 0}
    end

    for i,v in ipairs(get_c(rsar)) do
        local byp = rnd(v.Value)
        local p1 = byp * 0.8
        local slp = rnd(p1)

        rsc[v.Name].slp = rnd(slp)
        rsc[v.Name].byp = rnd(byp)
    end

    return rsc, rsrcs
end

local rsc, rsrcs = rscs()

b.Dropdown(b, "Resource",rsrcs,true,function(val)
    inf[1] = tostring(val)
    slctrsc = val
    return slctrsc
end)

b.Slider(b, "Reserve Flow",{
    min = 0.5; 
    max = 100; 
    precise = true; 
},function(val)
    ct6 = val
    return ct6
end)

local function sndt()
    local ai2 = {}
    local ct8 = 0

    local function get_ai()
        for i,v in ipairs(get_c(ctrs)) do
            local len = string.len(v.Name) - 2

            if string.find(v.Name, "AI", len) then
                ct8 = ct8 + 1
                ai2[ct8] = v
            end
        end
    end

    get_ai()
    local gay
    local st = workspace.GameManager.ManageAlliance
    local tr = "ResourceTrade"
    local rscsp = rsc[slctrsc].slp

    for i,v in ipairs(ai2) do
        local pb = tonumber(rev(plctr) - exps(plctr))
        local len3 = string.len(v.Name) - 2
        local n = string.sub(v.Name, 1, len3)
        local slctbal = tonumber(rev(n) - exps(n))
        local rscf = cd[slctrsc].Flow.Value
        local rsca = cd[slctrsc].Value

        if rscf <= ct6 or rsca <= 1 then print("done") break end

        if rscf > ct6 and rsca > 1 and slctbal > 1e6 then
            for i = 1,rscf do
                if rscsp * i <= slctbal * .8 then
                    gay = i
                end
            end
            inf[2] = [==[Sell]==]
            inf[3] = gay - ct6
            inf[4] = 1
            inf[5] = [==[Trade]==]
            st.FireServer(st, n, tr, inf)
            wait(6)
        end
        if rscf <= ct6 or rsca <= 1 then print("done3") break end
    end
end

b.Button(b, "Smart Sell Selected",function()
    sndt()
end)

b.Button(b, "Notifications",function(bool)
    for i,v in ipairs(game.GetChildren(alrt)) do
        if string.match(v.Name, "AlertSample") and game.FindFirstChild(v, "Title") and table.find(bye, v.Title.Text) then
            v.Destroy(v)
        end
    end
end)

b3.Toggle(b3, "Unit ESP",function(bool)
    shared.tog = bool
    local ct4 = 0
    local tags = {}
    local valid = false
    if shared.tog then
        for i,v in ipairs(get_cu) do
            for _,b in pairs(get_c(v)) do 
                if string.match(b.Name, "Tag") then
                    ct4 = ct4 + 1
                    tags[ct4] = {"Tag", b}
                    valid = true
                end
            end
        end
    end
    local unitadd
    unitadd = units.ChildAdded.Connect(units.ChildAdded, function(c)
        if shared.tog then
            for i,v in ipairs(get_c(c)) do
                if string.match(b.Name, "Tag") then
                    ct4 = ct4 + 1
                    tags[ct4] = {"Tag", b}
                    valid = true
                end
            end
        else
            unitadd.Disconnect(unitadd)
        end
    end)
    if shared.tog then
        rs.BindToRenderStep(rs, "esp", camval, function()
            for k,v in ipairs(tags) do
                if v[1] == "Tag" and valid then
                    v[2].Enabled = true
                end
            end
        end)
    else
        rs.UnbindFromRenderStep(rs, "esp")
    end
end)