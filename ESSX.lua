local P,U,RS,TS=game:GetService("Players"),game:GetService("UserInputService"),game:GetService("RunService"),game:GetService("TweenService")
local MS,HS,Lt,TP,SS,St=game:GetService("MarketplaceService"),game:GetService("HttpService"),game:GetService("Lighting"),game:GetService("TeleportService"),game:GetService("SoundService"),game:GetService("Stats")
local lp=P.LocalPlayer local HUB,PASS,KING_PASS="FarmHub","888","*2555" local CHAT_MODEL="gemini-1.5-flash" local PID=tostring(game.PlaceId) local SF,KF="farmhub_save.json","farmhub_key.txt" local T0=tick() local SV={}
pcall(function() if isfile and isfile(SF) then SV=HS:JSONDecode(readfile(SF)) end end) if type(SV)~="table" then SV={} end
local sd=false local function save() if sd then return end sd=true task.delay(1,function() sd=false pcall(function() if writefile then writefile(SF,HS:JSONEncode(SV)) end end) end) end
if SV.place~=PID then SV.ai=nil SV.place=PID save() end
local alive,conns=true,{} local function bind(sig,f) local c=sig:Connect(f) conns[#conns+1]=c return c end
local C={bg=Color3.fromRGB(24,25,29),side=Color3.fromRGB(30,31,37),card=Color3.fromRGB(38,40,47),card2=Color3.fromRGB(48,50,58),line=Color3.fromRGB(56,58,68),ac=Color3.fromRGB(112,116,196),off=Color3.fromRGB(68,70,82),text=Color3.fromRGB(222,223,228),sub=Color3.fromRGB(135,138,150),red=Color3.fromRGB(190,86,86),green=Color3.fromRGB(100,168,122),yellow=Color3.fromRGB(200,170,92),gold=Color3.fromRGB(240,190,60)}
local function N(c,p,par) local o=Instance.new(c) for k,v in pairs(p) do o[k]=v end o.Parent=par return o end
local function rd(o,r) N("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function circ(o) N("UICorner",{CornerRadius=UDim.new(.5,0)},o) end
local function L(p,t,pos,sz,ts,col,b,al) return N("TextLabel",{BackgroundTransparency=1,Text=t,Position=pos,Size=sz,TextSize=ts,TextColor3=col or C.text,Font=b and Enum.Font.GothamBold or Enum.Font.GothamMedium,TextXAlignment=al or Enum.TextXAlignment.Left},p) end
local function B(p,t,pos,sz,bg,ts,col,r) local b=N("TextButton",{Text=t,Position=pos,Size=sz,BackgroundColor3=bg,TextSize=ts or 13,TextColor3=col or C.text,Font=Enum.Font.GothamBold,AutoButtonColor=false,BorderSizePixel=0},p) rd(b,r or 2) return b end
local function ptr(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
local function mv(i) return i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch end
local function drag(h,t,click) local d,m,si,sp h.InputBegan:Connect(function(i) if ptr(i) then d,m,si,sp=true,false,i.Position,t.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false if not m and click then click() end end end) end end) bind(U.InputChanged,function(i) if d and mv(i) then local v=i.Position-si if v.Magnitude>6 then m=true end if m then t.Position=UDim2.new(sp.X.Scale,sp.X.Offset+v.X,sp.Y.Scale,sp.Y.Offset+v.Y) end end end) end
local function hum() local c=lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function hrp() local c=lp.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function hrpOf(p) local c=p.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getKey() local k="" pcall(function() if isfile and isfile(KF) then k=readfile(KF):gsub("%s","") end end) return k end
local function fmt(s) s=math.floor(s) local h,m,x=s//3600,(s%3600)//60,s%60 return h>0 and string.format("%d:%02d:%02d",h,m,x) or string.format("%02d:%02d",m,x) end

local SND_ON,sounds=true,{}
do
	local SR=16000 local function le(n,b) local t={} for i=1,b do t[i]=string.char(n%256) n=n//256 end return table.concat(t) end
	local function wavData(notes,total) local out={} for i=0,math.floor(SR*total)-1 do local t,v=i/SR,0 for _,nt in ipairs(notes) do local tt=t-nt[2] if tt>=0 and tt<nt[3] then local f=nt[1] v=v+math.min(1,tt/.004)*nt[4]*(math.sin(6.2832*f*tt)*math.exp(-7*tt)+.45*math.sin(6.2832*f*2.76*tt)*math.exp(-11*tt)+.22*math.sin(6.2832*f*5.4*tt)*math.exp(-16*tt)) end end v=math.clamp(math.floor(v*14000),-32768,32767) if v<0 then v=v+65536 end out[#out+1]=string.char(v%256,(v//256)%256) end return "RIFF"..le(36+#out*2,4).."WAVEfmt "..le(16,4)..le(1,2)..le(1,2)..le(SR,4)..le(SR*2,4)..le(2,2)..le(16,2).."data"..le(#out*2,4)..table.concat(out) end
	local defs={tick={{1568,0,.5,.6}},on={{1318,0,.5,.55},{1760,.09,.5,.6}},off={{1175,0,.4,.5},{880,.08,.45,.5}},open={{1046,0,.5,.5},{1568,.1,.6,.55}},hi={{1046,0,.6,.5},{1318,.2,.6,.5},{1568,.4,.7,.55},{2093,.62,1,.6}},done={{1318,0,.6,.5},{1568,.12,.6,.5},{2093,.24,1,.55}}}
	pcall(function() if makefolder and isfolder and not isfolder("farmhub") then makefolder("farmhub") end end)
	for k,nt in pairs(defs) do local id if writefile and getcustomasset then pcall(function() local fn="farmhub/"..k..".wav" writefile(fn,wavData(nt,.8)) id=getcustomasset(fn) end) end sounds[k]=N("Sound",{SoundId=id or "rbxasset://sounds/electronicpingshort.wav",Volume=.7},SS) end
end
local function sfx(k) if SND_ON and sounds[k] then pcall(function() sounds[k].TimePosition=0 sounds[k]:Play() end) end end

local gp=(function() local ok,r=pcall(function() return gethui and gethui() or game:GetService("CoreGui") end) return ok and r or lp:WaitForChild("PlayerGui") end)()
local old=gp:FindFirstChild("FarmHubGui") if old then old:Destroy() end
local gui=N("ScreenGui",{Name="FarmHubGui",ResetOnSpawn=false,IgnoreGuiInset=true},gp)
local function kill() alive=false for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end for _,s in pairs(sounds) do pcall(function() s:Destroy() end) end local h=hum() if h then h.WalkSpeed=16 h.UseJumpPower=true end pcall(function() gui:Destroy() end) end

local ld=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(0,340,0,132),BackgroundColor3=C.bg,ZIndex=50},gui) rd(ld,3) N("UIStroke",{Color=C.line},ld)
L(ld,"Hi, "..lp.DisplayName.."!",UDim2.new(0,18,0,12),UDim2.new(1,-120,0,26),18,C.text,true) L(ld,"🌀 "..HUB.." กำลังเตรียมสคริป...",UDim2.new(0,18,0,40),UDim2.new(1,-36,0,16),11,C.sub)
local lt=L(ld,"",UDim2.new(0,18,0,66),UDim2.new(1,-100,0,16),11,C.sub) local pl=L(ld,"0%",UDim2.new(1,-80,0,66),UDim2.new(0,62,0,16),11,C.text,true,Enum.TextXAlignment.Right)
local bb=N("Frame",{Position=UDim2.new(0,18,0,92),Size=UDim2.new(1,-36,0,8),BackgroundColor3=C.off},ld) rd(bb,1) local bf=N("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.ac},bb) rd(bf,1)
local skipAI=false B(ld,"ข้าม AI",UDim2.new(1,-86,0,12),UDim2.new(0,68,0,24),C.card2,11,C.text,2).Activated:Connect(function() skipAI=true sfx("tick") end)
local function prog(p,t) ld.Visible=p<100 lt.Text=t pl.Text=p.."%" TS:Create(bf,TweenInfo.new(.2),{Size=UDim2.new(p/100,0,1,0)}):Play() task.wait(.15) end sfx("hi")
local win=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(0,620,0,350),BackgroundColor3=C.bg,ClipsDescendants=true,Visible=false,ZIndex=5},gui) rd(win,3) N("UIStroke",{Color=C.line},win)
local sc=N("UIScale",{},win) local base=1 local function fit() local v=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,400) base=math.clamp(math.min(v.X/680,v.Y/400),.5,1) end fit() sc.Scale=base
local function open(o) if o then fit() win.Visible=true sc.Scale=base*.9 TS:Create(sc,TweenInfo.new(.2),{Scale=base}):Play() else local t=TS:Create(sc,TweenInfo.new(.12),{Scale=base*.9}) t.Completed:Connect(function() win.Visible=false end) t:Play() end end
local tl=N("TextLabel",{AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-10),Size=UDim2.new(0,300,0,26),BackgroundColor3=C.card2,TextSize=12,Font=Enum.Font.GothamMedium,TextColor3=C.text,Visible=false,ZIndex=9},win) rd(tl,2)
local tid=0 local function toast(t) tid+=1 local id=tid tl.Text=t tl.Visible=true task.delay(2.5,function() if tid==id then tl.Visible=false end end) end

local top=N("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=C.side},win) N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.line},top)
local av=N("ImageLabel",{Size=UDim2.new(0,34,0,34),Position=UDim2.new(0,12,0,7),BackgroundColor3=C.card2},top) rd(av,2)
task.spawn(function() local ok,u=pcall(P.GetUserThumbnailAsync,P,lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) if ok and av.Parent then av.Image=u end end)
L(top,lp.DisplayName,UDim2.new(0,54,0,6),UDim2.new(0,160,0,18),13,C.text,true) L(top,"@"..lp.Name,UDim2.new(0,54,0,25),UDim2.new(0,160,0,16),11,C.sub)
local pills=N("Frame",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-12,.5,0),Size=UDim2.new(0,340,0,28),BackgroundTransparency=1},top) N("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6)},pills)
local function pill(w,o) local f=N("Frame",{Size=UDim2.new(0,w,0,26),BackgroundColor3=C.card2,LayoutOrder=o},pills) rd(f,2) return L(f,"",UDim2.new(),UDim2.new(1,0,1,0),11,C.text,true,Enum.TextXAlignment.Center) end
local tL,pL,fL=pill(78,1),pill(122,2),pill(64,3) local xb=B(pills,"×",UDim2.new(),UDim2.new(0,28,0,26),C.red,16,C.text,2) xb.LayoutOrder=4 xb.Activated:Connect(function() sfx("off") task.delay(.15,kill) end) drag(top,win)
do local fr,last=0,tick() bind(RS.RenderStepped,function() fr+=1 if tick()-last>=1 then fL.Text="FPS "..fr fL.TextColor3=fr>=50 and C.green or (fr>=30 and C.yellow or C.red) fr,last=0,tick() end end) task.spawn(function() while alive do tL.Text="⏱ "..fmt(tick()-T0) local ok,pv=pcall(function() return St.Network.ServerStatsItem["Data Ping"]:GetValue() end) if ok then pv=math.floor(pv) pL.Text="📶 "..pv.."ms" else pL.Text="📶 -" end task.wait(.5) end end) end

local side=N("ScrollingFrame",{Position=UDim2.new(0,0,0,48),Size=UDim2.new(0,156,1,-48),BackgroundColor3=C.side,BorderSizePixel=0,ScrollBarThickness=0,AutomaticCanvasSize=Enum.AutomaticSize.Y},win) N("UIListLayout",{Padding=UDim.new(0,2)},side) N("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,9),PaddingBottom=UDim.new(0,8)},side)
local body=N("Frame",{Position=UDim2.new(0,168,0,60),Size=UDim2.new(1,-180,1,-72),BackgroundTransparency=1},win)
local ord=0 local function nx() ord+=1 return ord end local tabs={}
local function selTab(t) for _,x in ipairs(tabs) do local a=x==t x.pg.Visible=a x.bar.Visible=a x.btn.BackgroundTransparency=a and 0 or 1 x.lb.TextColor3=a and C.text or C.sub end end
local function addGroup(t) L(side,t,UDim2.new(),UDim2.new(1,0,0,22),10,C.sub,true).LayoutOrder=nx() end
local function addTab(t,plain)
	local btn=N("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.card,BackgroundTransparency=1,LayoutOrder=nx()},side) rd(btn,2)
	local bar=N("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=C.ac,Visible=false},btn) local lb=L(btn,t,UDim2.new(0,12,0,0),UDim2.new(1,-14,1,0),12,C.sub,true)
	local hit=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},btn)
	local pg=plain and N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},body) or N("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},body)
	if not plain then N("UIListLayout",{Padding=UDim.new(0,6)},pg) end local e={btn=btn,bar=bar,lb=lb,pg=pg} tabs[#tabs+1]=e hit.Activated:Connect(function() sfx("tick") selTab(e) end) return pg,e
end

local function row(pg,h) local f=N("Frame",{Size=UDim2.new(1,-8,0,h),BackgroundColor3=C.card,LayoutOrder=nx()},pg) rd(f,2) return f end
local function sec(pg,t) local f=N("Frame",{Size=UDim2.new(1,-8,0,24),BackgroundTransparency=1,LayoutOrder=nx()},pg) L(f,t,UDim2.new(0,2,0,0),UDim2.new(1,0,0,20),11,C.sub,true) return f end
local function note(pg,t) local l=N("TextLabel",{Size=UDim2.new(1,-8,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=C.card,Text=t,TextSize=12,Font=Enum.Font.GothamMedium,TextColor3=C.text,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,LayoutOrder=nx()},pg) rd(l,2) N("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},l) return l end
local function brow(pg,t,cb) local b=B(pg,t,UDim2.new(),UDim2.new(1,-8,0,38),C.card,12,C.text,2) b.LayoutOrder=nx() b.Activated:Connect(function() sfx("tick") cb() end) return b end
local function tog(p,pos,on,cb) local s=B(p,"",pos,UDim2.new(0,40,0,20),on and C.ac or C.off,13,C.text,2) local k=N("Frame",{Size=UDim2.new(0,16,0,16),Position=on and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2),BackgroundColor3=C.text},s) rd(k,1) s.Activated:Connect(function() on=not on sfx(on and "on" or "off") TS:Create(s,TweenInfo.new(.15),{BackgroundColor3=on and C.ac or C.off}):Play() TS:Create(k,TweenInfo.new(.15),{Position=on and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)}):Play() cb(on) end) end
local function trow(pg,t,d,cb) local f=row(pg,d and 46 or 40) L(f,t,UDim2.new(0,12,0,d and 5 or 0),UDim2.new(1,-84,0,d and 20 or 40),13,C.text,true) if d then L(f,d,UDim2.new(0,12,0,25),UDim2.new(1,-84,0,16),11,C.sub) end tog(f,UDim2.new(1,-54,.5,-10),false,cb) end
local function srow(pg,t,mn,mx,df,cv,onT,onV) local c=row(pg,72) L(c,t,UDim2.new(0,12,0,8),UDim2.new(1,-150,0,20),13,C.text,true) local bx=N("TextBox",{Size=UDim2.new(0,62,0,24),Position=UDim2.new(1,-128,0,8),BackgroundColor3=C.card2,Text=tostring(df),TextSize=12,Font=Enum.Font.GothamMedium,TextColor3=C.text},c) rd(bx,2) tog(c,UDim2.new(1,-54,0,10),false,onT) local hit=N("Frame",{Size=UDim2.new(1,-24,0,24),Position=UDim2.new(0,12,0,40),BackgroundTransparency=1},c) local tr=N("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,.5,-2),BackgroundColor3=C.off},hit) local fl=N("Frame",{BackgroundColor3=C.ac},tr) local kn=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.new(0,10,0,16),BackgroundColor3=C.text},tr) rd(kn,1) local val=df local function set(v) v=math.clamp(math.floor(v+.5),mn,mx) val=v bx.Text=tostring(v) local r=math.clamp((v-mn)/(mx-mn),0,1)^(1/cv) fl.Size=UDim2.new(r,0,1,0) kn.Position=UDim2.new(r,0,.5,0) onV(v) end set(df) local dg=false hit.InputBegan:Connect(function(i) if ptr(i) then dg=true set(mn+(mx-mn)*(math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)^cv)) end end) bind(U.InputChanged,function(i) if dg and mv(i) then set(mn+(mx-mn)*(math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)^cv)) end end) bind(U.InputEnded,function(i) if dg and ptr(i) then dg=false end end) end

local orb=N("Frame",{Size=UDim2.new(0,58,0,58),Position=UDim2.new(0,18,.5,-29),BackgroundTransparency=1,ZIndex=20,Visible=false},gui) local halo=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(1.5,0,1.5,0),BackgroundColor3=C.ac,BackgroundTransparency=.8,ZIndex=18},orb) circ(halo)
local core=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(26,27,33),ZIndex=21},orb) circ(core) local glyph=L(core,"✦",UDim2.new(),UDim2.new(1,0,1,0),26,C.text,true,Enum.TextXAlignment.Center) glyph.ZIndex=22
local ob=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=25},orb) drag(ob,orb,function() sfx("open") open(not win.Visible) end)

local SIG={npcs={},prompts={},clicks={},colls={},cps={},remotes={},leader={},tools={},teams=0,name=game.Name,desc=""} local INFO={name=game.Name,genre="gen",th="เกมทั่วไป",how="",src="กฎในเครื่อง",rec={}}
local function scanWorld()
	local npcs,prs,cds,cls,cps={},{},{},{},{} for _,d in ipairs(workspace:GetDescendants()) do
		if d:IsA("Humanoid") and d.Parent and d.Parent:IsA("Model") and not P:GetPlayerFromCharacter(d.Parent) and d.Parent:FindFirstChild("HumanoidRootPart") then npcs[#npcs+1]=d.Parent
		elseif d:IsA("ProximityPrompt") then prs[#prs+1]=d elseif d:IsA("ClickDetector") then cds[#cds+1]=d
		elseif d:IsA("BasePart") then local nm=d.Name:lower() if nm:find("checkpoint",1,true) or nm:match("^stage%s*%d+") then cps[#cps+1]=d elseif d:FindFirstChild("TouchInterest") then cls[#cls+1]=d end end
	end SIG.npcs,SIG.prompts,SIG.clicks,SIG.colls,SIG.cps=npcs,prs,cds,cls,cps
end
local function scanMeta()
	local ls=lp:FindFirstChild("leaderstats") SIG.leader={} if ls then for _,v in ipairs(ls:GetChildren()) do SIG.leader[#SIG.leader+1]=v.Name end end
	SIG.remotes={} for _,d in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and #SIG.remotes<50 then SIG.remotes[#SIG.remotes+1]=d end end
	SIG.tools={} local b=lp:FindFirstChildOfClass("Backpack") if b then for _,t in ipairs(b:GetChildren()) do if t:IsA("Tool") then SIG.tools[#SIG.tools+1]=t.Name end end end
	local ok,pi=pcall(function() return MS:GetProductInfo(game.PlaceId) end) SIG.name=ok and pi.Name or game.Name
end
addGroup("หลัก") local pgInfo=addTab("ℹ️  ข้อมูลแมพ") local pgAuto=addTab("⚔️  ออโต้ (AI)")
addGroup("เครื่องมือ") local pgCom=addTab("🧰  ทั่วไป") local pgPl=addTab("📍  ผู้เล่น")
addGroup("ระบบ") local pgSet=addTab("⚙️  ตั้งค่า")
addGroup("เมนูลัด") local pgChat,chatE=addTab("🔒  เมนู แชทคนโสด",true) local pgKing,kingE=addTab("💰  เมนูราชา",true) selTab(tabs[1])

local iName,iHow,iSig=note(pgInfo,"กำลังวิเคราะห์..."),note(pgInfo,""),note(pgInfo,"")
local function refreshInfo() iName.Text="🎮 "..INFO.name.."\nประเภท: "..INFO.th iHow.Text="📖 วิธีเล่น\n"..INFO.how iSig.Text="🔎 เจอ NPC: "..#SIG.npcs.." | ของเก็บ: "..#SIG.colls.." | เช็กพอยต์: "..#SIG.cps end

-- 🧰 เมนูทั่วไป (ระบบบิน Fly)
do
	local flying, flySpeed = false, 50
	local bv, bg
	sec(pgCom,"การเคลื่อนไหว & บิน")
	srow(pgCom,"✈️ บิน (Fly)",1,500,50,2,function(o)
		flying=o local r=hrp()
		if o and r then
			bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(1,1,1)*1e9 bv.Velocity=Vector3.new() bv.Parent=r
			bg=Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(1,1,1)*1e9 bg.CFrame=r.CFrame bg.Parent=r
		else
			if bv then bv:Destroy() end if bg then bg:Destroy() end
			local h=hum() if h then h.PlatformStand=false end
		end
	end, function(v) flySpeed=v end)

	bind(RS.RenderStepped, function()
		if flying and hrp() then
			local cam=workspace.CurrentCamera local moveVec=Vector3.new()
			if U:IsKeyDown(Enum.KeyCode.W) then moveVec=moveVec+cam.CFrame.LookVector end
			if U:IsKeyDown(Enum.KeyCode.S) then moveVec=moveVec-cam.CFrame.LookVector end
			if U:IsKeyDown(Enum.KeyCode.A) then moveVec=moveVec-cam.CFrame.RightVector end
			if U:IsKeyDown(Enum.KeyCode.D) then moveVec=moveVec+cam.CFrame.RightVector end
			if U:IsKeyDown(Enum.KeyCode.Space) then moveVec=moveVec+Vector3.new(0,1,0) end
			if U:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec=moveVec-Vector3.new(0,1,0) end
			if bv then bv.Velocity=moveVec*flySpeed end
			if bg then bg.CFrame=cam.CFrame end
			local h=hum() if h then h.PlatformStand=true end
		end
	end)

	local so,sv,jo,jv,nc=false,24,false,50,false
	srow(pgCom,"🏃 วิ่งเร็ว",1,1000,24,2,function(o) so=o if not o and hum() then hum().WalkSpeed=16 end end,function(v) sv=v end)
	srow(pgCom,"🦘 กระโดดสูง",1,1000,50,2,function(o) jo=o if not o and hum() then hum().UseJumpPower=true hum().JumpPower=50 end end,function(v) jv=v end)
	bind(RS.Heartbeat,function() local h=hum() if h then if so then h.WalkSpeed=sv end if jo then h.UseJumpPower=true h.JumpPower=jv end end end)
	trow(pgCom,"🧱 ทะลุกำแพง (Noclip)","เดินทะลุกำแพง",function(o) nc=o end)
	bind(RS.Stepped,function() if nc and lp.Character then for _,p in ipairs(lp.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
	brow(pgCom,"🔄  เข้าเซิร์ฟใหม่ (Rejoin)",function() pcall(function() TP:Teleport(game.PlaceId,lp) end) end)
end

-- 📍 ผู้เล่น
do
	local lf=N("Frame",{Size=UDim2.new(1,-8,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=nx()},pgPl) N("UIListLayout",{Padding=UDim.new(0,6)},lf)
	local function refresh()
		for _,c in ipairs(lf:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
		for _,p in ipairs(P:GetPlayers()) do if p~=lp then
			local r=N("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=C.card},lf) rd(r,2)
			L(r,p.DisplayName,UDim2.new(0,12,0,0),UDim2.new(1,-100,1,0),12,C.text,true)
			B(r,"วาร์ป",UDim2.new(1,-78,.5,-12),UDim2.new(0,68,0,24),C.ac,12,C.text,2).Activated:Connect(function() local m,t=hrp(),hrpOf(p) if m and t then m.CFrame=t.CFrame*CFrame.new(0,0,3) toast("วาร์ปไปหา "..p.DisplayName) end end)
		end end
	end bind(P.PlayerAdded,refresh) bind(P.PlayerRemoving,refresh) refresh()
end

-- 💬 เมนูแชทคนโสด & 💰 เมนูราชา
do
	local lockF=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1},pgChat) local chatF=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},pgChat)
	local lc=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(0,280,0,150),BackgroundColor3=C.card},lockF) rd(lc,2)
	L(lc,"🔒 ล็อกรหัสผ่าน",UDim2.new(0,0,0,16),UDim2.new(1,0,0,24),15,C.text,true,Enum.TextXAlignment.Center)
	local pw=N("TextBox",{Size=UDim2.new(1,-40,0,32),Position=UDim2.new(0,20,0,50),BackgroundColor3=C.card2,Text="",PlaceholderText="รหัสแชท (888)",TextSize=13,TextColor3=C.text},lc) rd(pw,2)
	B(lc,"ปลดล็อก",UDim2.new(0,20,0,95),UDim2.new(1,-40,0,32),C.ac,13,C.text,2).Activated:Connect(function() if pw.Text==PASS then lockF.Visible=false chatF.Visible=true toast("ปลดล็อกแชทแล้ว") end end)

	-- เมนูราชา
	local kLockF=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1},pgKing) local kingF=N("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},pgKing) N("UIListLayout",{Padding=UDim.new(0,6)},kingF)
	local kLc=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(0,280,0,150),BackgroundColor3=C.card},kLockF) rd(kLc,2)
	L(kLc,"👑 เมนูราชาถูกล็อก",UDim2.new(0,0,0,16),UDim2.new(1,0,0,24),15,C.gold,true,Enum.TextXAlignment.Center)
	local kPw=N("TextBox",{Size=UDim2.new(1,-40,0,32),Position=UDim2.new(0,20,0,50),BackgroundColor3=C.card2,Text="",PlaceholderText="รหัสราชา (*2555)",TextSize=13,TextColor3=C.gold},kLc) rd(kPw,2)
	B(kLc,"ปลดล็อกพลังราชา",UDim2.new(0,20,0,95),UDim2.new(1,-40,0,32),C.gold,13,Color3.fromRGB(20,20,20),2).Activated:Connect(function()
		if kPw.Text==KING_PASS then kLockF.Visible=false kingF.Visible=true toast("ปลดล็อกพลังราชาแล้ว!") end
	end)

	local god, antiK, knockO, aimOn = false, false, false, false
	sec(kingF,"🛡️ พลังราชา") trow(kingF,"🔱 อมตะ (Godmode)","",function(o) god=o end) trow(kingF,"🪨 ตีไม่กระเด็น","",function(o) antiK=o end) trow(kingF,"💥 ตีคนอื่นกระเด็น","",function(o) knockO=o end)
	bind(RS.RenderStepped,function()
		if god and hum() then hum().Health=hum().MaxHealth end
		if antiK and hrp() then hrp().AssemblyLinearVelocity=Vector3.new(0,hrp().AssemblyLinearVelocity.Y,0) end
		if knockO and hrp() then
			for _,p in ipairs(P:GetPlayers()) do if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local tr=p.Character.HumanoidRootPart if (tr.Position-hrp().Position).Magnitude<8 then tr.AssemblyLinearVelocity=(tr.Position-hrp().Position).Unit*200+Vector3.new(0,80,0) end
			end end
		end
	end)
end

scanMeta() scanWorld() refreshInfo()
sfx("done") orb.Visible=true
