--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.6.64  |  2026-09-28  |  Roblox UI Library for scripts
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Footagesus (Footages, .ftgs, oftgs)
    Github: https://github.com/Footagesus/WindUI
    Discord: https://discord.gg/ftgs-development-hub-1300692552005189632
    License: MIT
]]


local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"ReplicatedStorage":WaitForChild("GetIcons",99999):InvokeServer())

local function parseIconString(e)
if type(e)=="string"then
local f=e:find":"
if f then
local g=e:sub(1,f-1)
local h=e:sub(f+1)
return g,h
end
end
return nil,e
end

function d.AddIcons(e,f)
if type(e)~="string"or type(f)~="table"then
error"AddIcons: packName must be string, iconsData must be table"
return
end

if not d.Icons[e]then
d.Icons[e]={
Icons={},
Spritesheets={}
}
end

for g,h in pairs(f)do
if type(h)=="number"or(type(h)=="string"and h:match"^rbxassetid://")then
local i=h
if type(h)=="number"then
i="rbxassetid://"..tostring(h)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0),
Parts=nil
}
d.Icons[e].Spritesheets[i]=i

elseif type(h)=="table"then
if h.Image and h.ImageRectSize and h.ImageRectPosition then
local i=h.Image
if type(i)=="number"then
i="rbxassetid://"..tostring(i)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=h.ImageRectSize,
ImageRectPosition=h.ImageRectPosition,
Parts=h.Parts
}

if not d.Icons[e].Spritesheets[i]then
d.Icons[e].Spritesheets[i]=i
end
else
warn("AddIcons: Invalid spritesheet data format for icon '"..g.."'")
end
else
warn("AddIcons: Unsupported data type for icon '"..g.."': "..type(h))
end
end
end

function d.SetIconsType(e)
d.IconsType=e
end

local e
function d.Init(f,g)
d.New=f
d.IconThemeTag=g

e=f
return d
end

function d.Icon(f,g,h)
h=h~=false
local i,j=parseIconString(f)

local l=i or g or d.IconsType
local m=j

local p=d.Icons[l]

if p and p.Icons and p.Icons[m]then
return{
p.Spritesheets[tostring(p.Icons[m].Image)],
p.Icons[m],
}
elseif p and p[m]and string.find(p[m],"rbxassetid://")then
return h and{
p[m],
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}or p[m]
end
return nil
end

function d.GetIcon(f,g)
return d.Icon(f,g,false)
end


function d.Icon2(f,g,h)
return d.Icon(f,g,true)
end

function d.Image(f)
local g={
Icon=f.Icon or nil,
Type=f.Type,
Colors=f.Colors or{(d.IconThemeTag or Color3.new(1,1,1)),Color3.new(1,1,1)},
Transparency=f.Transparency or{0,0},
Size=f.Size or UDim2.new(0,24,0,24),

IconFrame=nil,
}

local h={}
local i={}

for j,l in next,g.Colors do
h[j]={
ThemeTag=typeof(l)=="string"and l,
Color=typeof(l)=="Color3"and l,
}
end

for j,l in next,g.Transparency do
i[j]={
ThemeTag=typeof(l)=="string"and l,
Value=typeof(l)=="number"and l,
}
end


local j=d.Icon2(g.Icon,g.Type)
local l=typeof(j)=="string"and string.find(j,'rbxassetid://')

if d.New then
local m=e or d.New



local p=m("ImageLabel",{
Size=g.Size,
BackgroundTransparency=1,
ImageColor3=h[1].Color or nil,
ImageTransparency=i[1].Value or nil,
ThemeTag=h[1].ThemeTag and{
ImageColor3=h[1].ThemeTag,
ImageTransparency=i[1].ThemeTag,
},
Image=l and j or j[1],
ImageRectSize=l and nil or j[2].ImageRectSize,
ImageRectOffset=l and nil or j[2].ImageRectPosition,
})


if not l and j[2].Parts then
for r,u in next,j[2].Parts do
local v=d.Icon(u,g.Type)

m("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=h[1+r].Color or nil,
ImageTransparency=i[1+r].Value or nil,
ThemeTag=h[1+r].ThemeTag and{
ImageColor3=h[1+r].ThemeTag,
ImageTransparency=i[1+r].ThemeTag,
},
Image=v[1],
ImageRectSize=v[2].ImageRectSize,
ImageRectOffset=v[2].ImageRectPosition,
Parent=p,
})
end
end

g.IconFrame=p
else
local m=Instance.new"ImageLabel"
m.Size=g.Size
m.BackgroundTransparency=1
m.ImageColor3=h[1].Color
m.ImageTransparency=i[1].Value or nil
m.Image=l and j or j[1]
m.ImageRectSize=l and nil or j[2].ImageRectSize
m.ImageRectOffset=l and nil or j[2].ImageRectPosition


if not l and j[2].Parts then
for p,r in next,j[2].Parts do
local u=d.Icon(r,g.Type)

local v=Instance.New"ImageLabel"
v.Size=UDim2.new(1,0,1,0)
v.BackgroundTransparency=1
v.ImageColor3=h[1+p].Color
v.ImageTransparency=i[1+p].Value or nil
v.Image=u[1]
v.ImageRectSize=u[2].ImageRectSize
v.ImageRectOffset=u[2].ImageRectPosition
v.Parent=m
end
end

g.IconFrame=m
end


return g
end

return d end function a.b()
return function(b)
return{


Primary="Icon",

White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

PanelBackground="White",
PanelBackgroundTransparency=.95,

WindowBackground="Background",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",

WindowSearchBarBackground="Background",

TabBackground="Hover",
TabBackgroundHover="Hover",
TabBackgroundHoverTransparency=.97,
TabBackgroundActive="Hover",
TabBackgroundActiveTransparency=0.93,
TabText="Text",
TabTextTransparency=0.3,
TabTextTransparencyActive=0,
TabTitle="Text",
TabIcon="Icon",
TabIconTransparency=0.4,
TabIconTransparencyActive=0.1,
TabBorderTransparency=1,
TabBorderTransparencyActive=0.75,
TabBorder="White",


ElementBackground="Text",
ElementBackgroundTransparency=.93,
ElementBackgroundHover=b:AddColor("ElementBackground","#ffffff",0.1),
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Background",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Primary",
CheckboxIcon="White",
CheckboxBorder="White",
CheckboxBorderTransparency=.75,

SliderIcon="Icon",

Slider="Primary",
SliderThumb="White",
SliderIconFrom="SliderIcon",
SliderIconTo="SliderIcon",

Tooltip=Color3.fromHex"4C4C4C",
TooltipText="White",
TooltipSecondary="Primary",
TooltipSecondaryText="White",

TabSectionIcon="Icon",

SectionIcon="Icon",

SectionExpandIcon="White",
SectionExpandIconTransparency=.4,
SectionBox="White",
SectionBoxTransparency=.95,
SectionBoxBorder="White",
SectionBoxBorderTransparency=.75,
SectionBoxBackground="White",
SectionBoxBackgroundTransparency=.95,

SearchBarBorder="White",
SearchBarBorderTransparency=.75,

Notification="Background",
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=.4,
NotificationDuration="White",
NotificationDurationTransparency=.95,
NotificationBorder="White",
NotificationBorderTransparency=.75,

DropdownTabBorder="White",

LabelBackground="White",
LabelBackgroundTransparency=.95,
}

end end function a.c()
local b=(cloneref or clonereference or function(b)
return b
end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")
local i=b(game:GetService"ReplicatedStorage")local j=

d.Heartbeat

local l="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local function CreateFallbackIcons()
local m={}
local p="rbxasset://textures/ui/GuiImagePlaceholder.png"

function m.SetIconsType()end
function m.AddIcons()end
function m.Init(r)
m.New=r
return m
end
function m.Icon2(r)
if type(r)=="string"and(r:match"^https?://"or r:match"^rbxasset")then
return nil
end
return{
p,
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)},
}
end
m.Icon=m.Icon2
function m.Image(r)
local u=Instance.new"ImageLabel"
u.BackgroundTransparency=1
u.Size=r.Size or UDim2.new(0,24,0,24)
u.Image=p
return{IconFrame=u}
end

return m
end

local m
local p=i:WaitForChild("GetIcons",2)
if p then
m=a.load'a'
elseif d:IsStudio()or not writefile then
m=CreateFallbackIcons()
else
local r,u=pcall(function()
return loadstring(
game.HttpGetAsync and game:HttpGetAsync(l)or h:GetAsync(l)
)()
end)
m=r and u or CreateFallbackIcons()
end

m.SetIconsType"lucide"

local r

local u
u={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=m,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
},
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=nil,
Shapes={Square=
"rbxassetid://82909646051652",
["Square-Outline"]="rbxassetid://72946211851948",Squircle=

"rbxassetid://80999662900595",SquircleOutline=
"rbxassetid://117788349049947",
["Squircle-Outline"]="rbxassetid://117817408534198",SquircleOutline2=

"rbxassetid://117817408534198",

["Shadow-sm"]="rbxassetid://84825982946844",

["Squircle-TL-TR"]="rbxassetid://73569156276236",
["Squircle-BL-BR"]="rbxassetid://93853842912264",
["Squircle-TL-TR-Outline"]="rbxassetid://136702870075563",
["Squircle-BL-BR-Outline"]="rbxassetid://75035847706564",

["Glass-0.7"]="rbxassetid://79047752995006",
["Glass-1"]="rbxassetid://97324581055162",
["Glass-1.4"]="rbxassetid://95071123641270",
},
ThemeChangeCallbacks={},
}

function u.Init(v)
r=v

u.ThemeFallbacks=a.load'b'(u)
end

function u.AddSignal(v,x)
local z=v:Connect(x)
table.insert(u.Signals,z)
return z
end

function u.DisconnectAll()
for v,x in next,u.Signals do
local z=table.remove(u.Signals,v)
z:Disconnect()
end
end

function u.SafeCallback(v,...)
if not v then
return
end

local x,z=pcall(v,...)
if not x then
if r and r.Window and r.Window.Debug then local
A, B=z:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..z)

return r:Notify{
Title="DEBUG Mode: Error",
Content=not B and z or z:sub(B+1),
Duration=8,
}
end
end
end

function u.Gradient(v,x)
if r and r.Gradient then
return r:Gradient(v,x)
end

local z={}
local A={}

for B,C in next,v do
local F=tonumber(B)
if F then
F=math.clamp(F/100,0,1)
table.insert(z,ColorSequenceKeypoint.new(F,C.Color))
table.insert(A,NumberSequenceKeypoint.new(F,C.Transparency or 0))
end
end

table.sort(z,function(B,C)
return B.Time<C.Time
end)
table.sort(A,function(B,C)
return B.Time<C.Time
end)

if#z<2 then
error"ColorSequence requires at least 2 keypoints"
end

local B={
Color=ColorSequence.new(z),
Transparency=NumberSequence.new(A),
}

if x then
for C,F in pairs(x)do
B[C]=F
end
end

return B
end

function u.SetTheme(v)
local x=u.Theme
u.Theme=v
u.UpdateTheme(nil,false)

for z,A in next,u.ThemeChangeCallbacks do
u.SafeCallback(A,v,x)
end
end

function u.AddFontObject(v)
table.insert(u.FontObjects,v)
u.UpdateFont(u.Font)
end

function u.UpdateFont(v)
u.Font=v
for x,z in next,u.FontObjects do
z.FontFace=Font.new(v,z.FontFace.Weight,z.FontFace.Style)
end
end

function u.GetThemeProperty(v,x)
local function getValue(z,A)
local B=A[z]

if B==nil then
return nil
end

if typeof(B)=="string"and string.sub(B,1,1)=="#"then
return Color3.fromHex(B)
end

if typeof(B)=="Color3"then
return B
end

if typeof(B)=="number"then
return B
end

if typeof(B)=="table"and B.Color and B.Transparency then
return B
end

if typeof(B)=="function"then
return B(A)
end

return B
end

local z=getValue(v,x)
if z~=nil then
if typeof(z)=="string"and string.sub(z,1,1)~="#"then
local A=u.GetThemeProperty(z,x)
if A~=nil then
return A
end
else
return z
end
end

local A=u.ThemeFallbacks[v]
if A~=nil then
if typeof(A)=="string"and string.sub(A,1,1)~="#"then
return u.GetThemeProperty(A,x)
else
return getValue(v,{[v]=A})
end
end

z=getValue(v,u.Themes.Dark)
if z~=nil then
if typeof(z)=="string"and string.sub(z,1,1)~="#"then
local B=u.GetThemeProperty(z,u.Themes.Dark)
if B~=nil then
return B
end
else
return z
end
end

if A~=nil then
if typeof(A)=="string"and string.sub(A,1,1)~="#"then
return u.GetThemeProperty(A,u.Themes.Dark)
else
return getValue(v,{[v]=A})
end
end

return nil
end

function u.AddThemeObject(v,x,z)
if u.Objects[v]then
for A,B in pairs(x)do
u.Objects[v].Properties[A]=B
end
else
u.Objects[v]={Object=v,Properties=x}
end

if not z then
u.UpdateTheme(v,false)
end
return v
end

function u.AddLangObject(v)
local x=u.LocalizationObjects[v]
if not x then
return
end

local z=x.Object

u.SetLangForObject(v)

return z
end

function u.UpdateTheme(v,x,z,A,B,C)
local function ApplyTheme(F)
for G,H in pairs(F.Properties or{})do
local J=u.GetThemeProperty(H,u.Theme)
if J~=nil then
if typeof(J)=="Color3"then
local L=F.Object:FindFirstChild"LibraryGradient"
if L then
L:Destroy()
end

if z then
u.Tween(
F.Object,
A or 0.2,
{[G]=J},
B or Enum.EasingStyle.Quint,
C or Enum.EasingDirection.Out
):Play()
elseif x then
u.Tween(F.Object,0.08,{[G]=J}):Play()
else
F.Object[G]=J
end
elseif typeof(J)=="table"and J.Color and J.Transparency then
F.Object[G]=Color3.new(1,1,1)

local L=F.Object:FindFirstChild"LibraryGradient"
if not L then
L=Instance.new"UIGradient"
L.Name="LibraryGradient"
L.Parent=F.Object
end

L.Color=J.Color
L.Transparency=J.Transparency

for M,N in pairs(J)do
if M~="Color"and M~="Transparency"and L[M]~=nil then
L[M]=N
end
end
elseif typeof(J)=="number"then
if z then
u.Tween(
F.Object,
A or 0.2,
{[G]=J},
B or Enum.EasingStyle.Quint,
C or Enum.EasingDirection.Out
):Play()
elseif x then
u.Tween(F.Object,0.08,{[G]=J}):Play()
else
F.Object[G]=J
end
end
else
local L=F.Object:FindFirstChild"LibraryGradient"
if L then
L:Destroy()
end
end
end
end

if v then
local F=u.Objects[v]
if F then
ApplyTheme(F)
end
else
for F,G in pairs(u.Objects)do
ApplyTheme(G)
end
end
end

function u.SetThemeTag(v,x,z,A,B)
u.AddThemeObject(v,x)
u.UpdateTheme(v,false,true,z,A,B)
end

function u.SetLangForObject(v)
if u.Localization and u.Localization.Enabled then
local x=u.LocalizationObjects[v]
if not x then
return
end

local z=x.Object
local A=x.TranslationId

local B=u.Localization.Translations[u.Language]
if B and B[A]then
z.Text=B[A]
else
local C=u.Localization
and u.Localization.Translations
and u.Localization.Translations.en
or nil
if C and C[A]then
z.Text=C[A]
else
z.Text="["..A.."]"
end
end
end
end

function u.ChangeTranslationKey(v,x,z)
if u.Localization and u.Localization.Enabled then
local A=string.match(z,"^"..u.Localization.Prefix.."(.+)")
if A then
for B,C in ipairs(u.LocalizationObjects)do
if C.Object==x then
C.TranslationId=A
u.SetLangForObject(B)
return
end
end

table.insert(u.LocalizationObjects,{
TranslationId=A,
Object=x,
})
u.SetLangForObject(#u.LocalizationObjects)
end
end
end

function u.UpdateLang(v)
if v then
u.Language=v
end

for x=1,#u.LocalizationObjects do
local z=u.LocalizationObjects[x]
if z.Object and z.Object.Parent~=nil then
u.SetLangForObject(x)
else
u.LocalizationObjects[x]=nil
end
end
end

function u.SetLanguage(v)
u.Language=v
u.UpdateLang()
end

function u.Icon(v,x)
return m.Icon2(v,nil,x~=false)
end

function u.AddIcons(v,x)
return m.AddIcons(v,x)
end

function u.New(v,x,z)
local A=Instance.new(v)

for B,C in next,u.DefaultProperties[v]or{}do
A[B]=C
end

for B,C in next,x or{}do
if B~="ThemeTag"then
A[B]=C
end
if u.Localization and u.Localization.Enabled and B=="Text"then
local F=string.match(C,"^"..u.Localization.Prefix.."(.+)")
if F then
local G=#u.LocalizationObjects+1
u.LocalizationObjects[G]={TranslationId=F,Object=A}

u.SetLangForObject(G)
end
end
end

for B,C in next,z or{}do
if C then
C.Parent=A
end
end

if x and x.ThemeTag then
u.AddThemeObject(A,x.ThemeTag)
end
if x and x.FontFace then
u.AddFontObject(A)
end
return A
end

function u.Tween(v,x,z,...)
return f:Create(v,TweenInfo.new(x,...),z)
end

function u.NewRoundFrame(v,x,z,A,B,C)
local function getImageForType(F)
return u.Shapes[F]
end

local function getSliceCenterForType(F)
return not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},F)
and Rect.new(256,256,256,256)
or Rect.new(512,512,512,512)
end

local F=u.New(B and"ImageButton"or"ImageLabel",{
Image=getImageForType(x),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(x),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=z.ThemeTag and z.ThemeTag,
},A)

for G,H in pairs(z or{})do
if G~="ThemeTag"then
F[G]=H
end
end

local function UpdateSliceScale(G)
local H=not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},x)
and(G/(256))
or(G/512)
F.SliceScale=math.max(H,0.0001)
end

local G={}

function G.SetRadius(H,J)
UpdateSliceScale(J)
end

function G.SetType(H,J)
x=J
F.Image=getImageForType(J)
F.SliceCenter=getSliceCenterForType(J)
UpdateSliceScale(v)
end

function G.UpdateShape(H,J,L)
if L then
x=L
F.Image=getImageForType(L)
F.SliceCenter=getSliceCenterForType(L)
end
if J then
v=J
end
UpdateSliceScale(v)
end

function G.GetRadius(H)
return v
end

function G.GetType(H)
return x
end

UpdateSliceScale(v)

return F,C and G or nil
end

local v=u.New local x=
u.Tween

function u.SetDraggable(z)
u.CanDraggable=z
end

function u.Drag(z,A,B)
local C
local F,G,H
local J={
CanDraggable=true,
}

if not A or typeof(A)~="table"then
A={z}
end

local function update(L)
if not F or not J.CanDraggable then
return
end

local M=L.Position-G
u.Tween(z,0.02,{
Position=UDim2.new(
H.X.Scale,
H.X.Offset+M.X,
H.Y.Scale,
H.Y.Offset+M.Y
),
}):Play()
end

for L,M in pairs(A)do
M.InputBegan:Connect(function(N)
if
(
N.UserInputType==Enum.UserInputType.MouseButton1
or N.UserInputType==Enum.UserInputType.Touch
)and J.CanDraggable
then
if C==nil then
C=M
F=true
G=N.Position
H=z.Position

if B and typeof(B)=="function"then
B(true,C)
end

N.Changed:Connect(function()
if N.UserInputState==Enum.UserInputState.End then
F=false
C=nil

if B and typeof(B)=="function"then
B(false,nil)
end
end
end)
end
end
end)

M.InputChanged:Connect(function(N)
if F and C==M then
if
N.UserInputType==Enum.UserInputType.MouseMovement
or N.UserInputType==Enum.UserInputType.Touch
then
update(N)
end
end
end)
end

e.InputChanged:Connect(function(L)
if F and C~=nil then
if
L.UserInputType==Enum.UserInputType.MouseMovement
or L.UserInputType==Enum.UserInputType.Touch
then
update(L)
end
end
end)

function J.Set(L,M)
J.CanDraggable=M
end

return J
end

m.Init(v,"Icon")

function u.SanitizeFilename(z)
local A=z:match"([^/]+)$"or z

A=A:gsub("%.[^%.]+$","")

A=A:gsub("[^%w%-_]","_")

if#A>50 then
A=A:sub(1,50)
end

return A
end

function u.Image(z,A,B,C,F,G,H,J)
C=C or"Temp"
A=u.SanitizeFilename(A)
local L

local M=v("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
v("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(u.Icon(z)or H)and{
ImageColor3=G and(J or"Icon")or nil,
}or nil,
},{
v("UICorner",{
CornerRadius=UDim.new(0,B),
}),
}),
})
L=M:FindFirstChildWhichIsA"ImageLabel"
if u.Icon(z)then
L:Destroy()

local N=m.Image{
Icon=z,
Size=UDim2.new(1,0,1,0),
Colors={
(G and(J or"Icon")or false),
"Button",
},
}.IconFrame
N.Name="ImageLabel"
N.Parent=M
L=N
elseif string.find(z,"http")and not string.find(z,"roblox.com")then
local N="WindUI/"..C.."/assets/."..F.."-"..A..".png"
local O,P=pcall(function()
task.spawn(function()
local O=u.Request
and u.Request{
Url=z,
Method="GET",
}.Body
or{}

if not d:IsStudio()and writefile then
writefile(N,O)
end


local P,Q=pcall(getcustomasset,N)
if P then
L.Image=Q
else
warn(
string.format(
"[ WindUI.Creator ] Failed to load custom asset '%s': %s",
N,
tostring(Q)
)
)
M:Destroy()

return
end
end)
end)
if not O then
warn(
"[ WindUI.Creator ]  '"..identifyexecutor()
or"Studio".."' doesnt support the URL Images. Error: "..P
)

M:Destroy()
end
elseif z==""then
M.Visible=false
else
L.Image=z
end

return M
end

function u.Color3ToHSB(z)
local A,B,C=z.R,z.G,z.B
local F=math.max(A,B,C)
local G=math.min(A,B,C)
local H=F-G

local J=0
if H~=0 then
if F==A then
J=(B-C)/H%6
elseif F==B then
J=(C-A)/H+2
else
J=(A-B)/H+4
end
J=J*60
else
J=0
end

local L=(F==0)and 0 or(H/F)
local M=F

return{
h=math.floor(J+0.5),
s=L,
b=M,
}
end

function u.GetPerceivedBrightness(z)
local A=z.R
local B=z.G
local C=z.B
return 0.299*A+0.587*B+0.114*C
end

function u.GetTextColorForHSB(z,A)
local B=u.Color3ToHSB(z)local
C, F, G=B.h, B.s, B.b
if u.GetPerceivedBrightness(z)>(A or 0.5)then
return Color3.fromHSV(C/360,0,0.05)
else
return Color3.fromHSV(C/360,0,0.98)
end
end

function u.GetAverageColor(z)
local A,B,C=0,0,0
local F=z.Color.Keypoints
for G,H in ipairs(F)do

A=A+H.Value.R
B=B+H.Value.G
C=C+H.Value.B
end
local G=#F
return Color3.new(A/G,B/G,C/G)
end

function u.GenerateUniqueID(z)
return h:GenerateGUID(false)
end

function u.OnThemeChange(z,A)
if typeof(A)~="function"then
return
end

local B=h:GenerateGUID(false)
u.ThemeChangeCallbacks[B]=A

return{
Disconnect=function()
u.ThemeChangeCallbacks[B]=nil
end,
}
end

function u.AddColor(z,A,B,C)
C=math.clamp(C or 1,0,1)
if typeof(B)=="string"then B=Color3.fromHex(B)end

return function(F)
local G
if typeof(A)=="string"and string.sub(A,1,1)~="#"then
G=u.GetThemeProperty(A,F)
elseif typeof(A)=="string"then
G=Color3.fromHex(A)
else
G=A
end

if not G or typeof(G)~="Color3"then
return nil
end

return Color3.new(
math.clamp(G.R+B.R*C,0,1),
math.clamp(G.G+B.G*C,0,1),
math.clamp(G.B+B.B*C,0,1)
)
end
end

return u end function a.d()

local b={}







function b.New(d,e,f)
local g={
Enabled=e.Enabled or false,
Translations=e.Translations or{},
Prefix=e.Prefix or"loc:",
DefaultLanguage=e.DefaultLanguage or"en"
}

f.Localization=g

return g
end



return b end function a.e()
local b=a.load'c'
local d=b.New
local e=b.Tween

local f={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=18,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={}
}

function f.Init(g)
local h={
Lower=false
}

function h.SetLower(i)
h.Lower=i
h.Frame.Size=i and f.SizeLower or f.Size
end

h.Frame=d("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=f.Size,
Parent=g,
BackgroundTransparency=1,




},{
d("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
d("UIPadding",{
PaddingBottom=UDim.new(0,29)
})
})
return h
end

function f.New(g)
local h={
Title=g.Title or"Notification",
Content=g.Content or nil,
Icon=g.Icon or nil,
IconThemed=g.IconThemed,
Background=g.Background,
BackgroundImageTransparency=g.BackgroundImageTransparency,
Duration=g.Duration or 5,
Buttons=g.Buttons or{},
CanClose=g.CanClose~=false,
UIElements={},
Closed=false,
}



f.NotificationIndex=f.NotificationIndex+1
f.Notifications[f.NotificationIndex]=h









local i

if h.Icon then





















i=b.Image(
h.Icon,
h.Title..":"..h.Icon,
0,
g.Window,
"Notification",
h.IconThemed
)
i.Size=UDim2.new(0,26,0,26)
i.Position=UDim2.new(0,f.UIPadding,0,f.UIPadding)

end

local l
if h.CanClose then
l=d("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-f.UIPadding,0,f.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.4,
},{
d("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local m=b.NewRoundFrame(f.UICorner,"Squircle",{
Size=UDim2.new(0,0,1,0),
ThemeTag={
ImageTransparency="NotificationDurationTransparency",
ImageColor3="NotificationDuration",
},

})

local p=d("Frame",{
Size=UDim2.new(1,
h.Icon and-28-f.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
d("UIPadding",{
PaddingTop=UDim.new(0,f.UIPadding),
PaddingLeft=UDim.new(0,f.UIPadding),
PaddingRight=UDim.new(0,f.UIPadding),
PaddingBottom=UDim.new(0,f.UIPadding),
}),
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-f.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=18,
ThemeTag={
TextColor3="NotificationTitle",
TextTransparency="NotificationTitleTransparency",
},
Text=h.Title,
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold)
}),
d("UIListLayout",{
Padding=UDim.new(0,f.UIPadding/3)
})
})

if h.Content then
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,

TextSize=15,
ThemeTag={
TextColor3="NotificationContent",
TextTransparency="NotificationContentTransparency",
},
Text=h.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
Parent=p
})
end


local r=b.NewRoundFrame(f.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
ImageTransparency=.05,
ThemeTag={
ImageColor3="Notification"
},

},{
b.NewRoundFrame(f.UICorner,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="NotificationBorder",
ImageTransparency="NotificationBorderTransparency",
},
}),
d("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="DurationFrame",
},{
d("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ClipsDescendants=true,
},{
m,
}),





}),
d("ImageLabel",{
Name="Background",
Image=h.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=h.BackgroundImageTransparency

},{
d("UICorner",{
CornerRadius=UDim.new(0,f.UICorner),
})
}),

p,
i,l,
})

local u=d("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=g.Holder
},{
r
})

function h.Close(v)
if not h.Closed then
h.Closed=true
e(u,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(r,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
u:Destroy()
end
end

task.spawn(function()
task.wait()
e(u,0.45,{Size=UDim2.new(
1,
0,
0,
r.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(r,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if h.Duration then
m.Size=UDim2.new(0,r.DurationFrame.AbsoluteSize.X,1,0)
e(r.DurationFrame.Frame,h.Duration,{Size=UDim2.new(0,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(h.Duration)
h:Close()
end
end)

if l then
b.AddSignal(l.TextButton.MouseButton1Click,function()
h:Close()
end)
end


return h
end

return f end function a.f()












local b=4294967296;local d=b-1;local function c(e,f)local g,h=0,1;while e~=0 or f~=0 do local i,l=e%2,f%2;local m=(i+l)%2;g=g+m*h;e=math.floor(e/2)f=math.floor(f/2)h=h*2 end;return g%b end;local function k(e,f,g,...)local h;if f then e=e%b;f=f%b;h=c(e,f)if g then h=k(h,g,...)end;return h elseif e then return e%b else return 0 end end;local function n(e,f,g,...)local h;if f then e=e%b;f=f%b;h=(e+f-c(e,f))/2;if g then h=n(h,g,...)end;return h elseif e then return e%b else return d end end;local function o(e)return d-e end;local function q(e,f)if f<0 then return lshift(e,-f)end;return math.floor(e%4294967296/2^f)end;local function s(e,f)if f>31 or f<-31 then return 0 end;return q(e%b,f)end;local function lshift(e,f)if f<0 then return s(e,-f)end;return e*2^f%4294967296 end;local function t(e,f)e=e%b;f=f%32;local g=n(e,2^f-1)return s(e,f)+lshift(g,32-f)end;local e={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(f)return string.gsub(f,".",function(g)return string.format("%02x",string.byte(g))end)end;local function y(f,g)local h=""for i=1,g do local l=f%256;h=string.char(l)..h;f=(f-l)/256 end;return h end;local function D(f,g)local h=0;for i=g,g+3 do h=h*256+string.byte(f,i)end;return h end;local function E(f,g)local h=64-(g+9)%64;g=y(8*g,8)f=f.."\128"..string.rep("\0",h)..g;assert(#f%64==0)return f end;local function I(f)f[1]=0x6a09e667;f[2]=0xbb67ae85;f[3]=0x3c6ef372;f[4]=0xa54ff53a;f[5]=0x510e527f;f[6]=0x9b05688c;f[7]=0x1f83d9ab;f[8]=0x5be0cd19;return f end;local function K(f,g,h)local i={}for l=1,16 do i[l]=D(f,g+(l-1)*4)end;for l=17,64 do local m=i[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=i[l-2]i[l]=(i[l-16]+p+i[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+e[A]+i[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;h[1]=(h[1]+l)%b;h[2]=(h[2]+m)%b;h[3]=(h[3]+p)%b;h[4]=(h[4]+r)%b;h[5]=(h[5]+u)%b;h[6]=(h[6]+v)%b;h[7]=(h[7]+x)%b;h[8]=(h[8]+z)%b end;local function Z(f)f=E(f,#f)local g=I{}for h=1,#f,64 do K(f,h,g)end;return w(y(g[1],4)..y(g[2],4)..y(g[3],4)..y(g[4],4)..y(g[5],4)..y(g[6],4)..y(g[7],4)..y(g[8],4))end;local f;local g={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local h={["/"]="/"}for i,l in pairs(g)do h[l]=i end;local i=function(i)return"\\"..(g[i]or string.format("u%04x",i:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,f(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,f(u,p)..":"..f(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',i)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}f=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return f(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..h[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}

local Y=(cloneref or clonereference or function(Y)return Y end)


function X.New(_,aa)

local ab=_;
local ac=aa;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return Y(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=U{
service=ab,
identifier=W(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=V(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(ab);

local ay={
identifier=W(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=U(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(ab).."?identifier="..W(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(ab).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=V(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==W(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return X end function a.g()






local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ab=aa(game:GetService"HttpService")
local ac={}

function ac.New(ad)
local ae=gethwid or function()
return aa(game:GetService"Players").LocalPlayer.UserId
end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://new.pandadevelopment.net/api/v1/keys/validate"

local aj={
ServiceID=ad,
HWID=tostring(ae()),
Key=tostring(ah),
}

local ak=ab:JSONEncode(aj)
local al,am=pcall(function()
return af{
Url=ai,
Method="POST",
Headers={
["User-Agent"]="Roblox/Exploit",
["Content-Type"]="application/json",
},
Body=ak,
}
end)

if al and am then
if am.Success then
local an,ao=pcall(function()
return ab:JSONDecode(am.Body)
end)

if an and ao then
if ao.Authenticated_Status and ao.Authenticated_Status=="Success"then
return true,"Authenticated"
else
local ap=ao.Note or"Unknown reason"
return false,"Authentication failed: "..ap
end
else
return false,"JSON decode error"
end
else
warn(
" HTTP request was not successful. Code: "
..tostring(am.StatusCode)
.." Message: "
..am.StatusMessage
)
return false,"HTTP request failed: "..am.StatusMessage
end
else
return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://new.pandadevelopment.net/getkey/"..tostring(ad).."?hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return ac end function a.h()









local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.i()








local aa={}

function aa.New(ab,ac,ad)
JunkieProtected.API_KEY=ac
JunkieProtected.PROVIDER=ad
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(ae)
if not ae or ae==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local af=JunkieProtected.IsKeylessMode()
if af and af.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ag=JunkieProtected.ValidateKey{Key=ae}
if ag=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ah=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ah
end
end

local function copyLink()
local ae=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(ae)
end
end
return{
Verify=ValidateKey,
Copy=copyLink
}
end

return aa end function a.j()



return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},

New=a.load'f'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},

New=a.load'g'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},

New=a.load'h'.New
},
junkiedevelopment={
Name="Junkie Development",
Icon="rbxassetid://106310347705078",
Args={"ServiceId","ApiKey","Provider"},

New=a.load'i'.New
},


}end function a.k()



return[[
{
    "name": "windui",
    "version": "1.6.64",
    "main": "./dist/main.lua",
    "repository": "https://github.com/Footagesus/WindUI",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python3 -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]end function a.l()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag,ah,ai,aj,ak,al,am)
ah=ah or"Primary"
local an=al or(not ak and 10 or 99)
local ao=am or(ae=="Confirm"and Color3.fromRGB(255,60,60))
local ap
if af and af~=""then
ap=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
},
})
end

local aq=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(an,"Squircle",{
ThemeTag={
ImageColor3=not ao and ah~="White"and"Button"or nil,
},
ImageColor3=ao or(ah=="White"and Color3.new(1,1,1))or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 0.9,
}),

ab.NewRoundFrame(an,"Squircle",{
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(an,"Shadow-sm",{
ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",
ImageTransparency=1,
Visible=not ak,
}),




ab.NewRoundFrame(an,not ak and"Glass-1"or"Glass-0.7",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.6,
Name="Outline",
}),

ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil,
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ap,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(not ao and ah~="Primary"and ah~="White")and"Text",
},
TextColor3=(ao and Color3.new(1,1,1))or ah=="Primary"and Color3.new(1,1,1)
or ah=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})
local ar=ac("UIScale",{
Scale=1,
Parent=aq,
})

ab.AddSignal(aq.MouseEnter,function()
ad(ar,0.14,{Scale=1.025},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame,0.12,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(aq.MouseLeave,function()
ad(ar,0.18,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame,0.16,{ImageTransparency=1}):Play()
end)
ab.AddSignal(aq.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return aq
end

return aa end function a.m()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"Glass-1",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.75,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.n()
local aa=a.load'c'
local ab=aa.New
local ac=aa.Tween

local ad={
Holder=nil,
Parent=nil,
}

function ad.Create(ae,af,ag,ah,ai)
local aj={
UICorner=28,
UIPadding=12,
Window=ag,
WindUI=ah,
UIElements={},
}

if ae then
aj.UIPadding=0
end
if ae then
aj.UICorner=26
end

af=af or"Dialog"

if not ae then
aj.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ad.Parent
or(ag and ag.UIElements and ag.UIElements.Main and ag.UIElements.Main.Main),
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ag.UICorner),
}),
})
end

ab("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",
},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

aj.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=af.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,aj.UIPadding),
PaddingLeft=UDim.new(0,aj.UIPadding),
PaddingRight=UDim.new(0,aj.UIPadding),
PaddingBottom=UDim.new(0,aj.UIPadding),
}),
})

aj.UIElements.MainContainer=aa.NewRoundFrame(aj.UICorner,"Squircle",{
Visible=false,
ImageTransparency=ae and 0.15 or 0,
Parent=ai or aj.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=af.."Background",
ImageTransparency=af.."BackgroundTransparency",
},
ZIndex=9999,
},{
aa.NewRoundFrame(aj.UICorner,"Glass-1",{
ImageTransparency=0.89,
Size=UDim2.new(1,0,1,0)
}),
aj.UIElements.Main,
})

function aj.Open(ak)
if not ae then
aj.UIElements.FullScreen.Visible=true
aj.UIElements.FullScreen.Active=true
end

task.spawn(function()
aj.UIElements.MainContainer.Visible=true

if not ae then
ac(aj.UIElements.FullScreen,0.1,{BackgroundTransparency=0.3}):Play()
end
ac(aj.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()

task.spawn(function()
task.wait(0.05)
aj.UIElements.Main.Visible=true
end)
end)
end

function aj.Close(ak)
if not ae then
ac(aj.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
aj.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(0.1)
aj.UIElements.FullScreen.Visible=false
end)
end
aj.UIElements.Main.Visible=false

ac(aj.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()

task.spawn(function()
task.wait(0.1)
if not ae then
aj.UIElements.FullScreen:Destroy()
else
aj.UIElements.MainContainer:Destroy()
end
end)

return function()end
end

return aj
end

return ad end function a.o()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=a.load'l'.New
local af=a.load'm'.New

function aa.new(ag,ah,ai,aj)
local ak=a.load'n'
local al=ak.Create(true,"Popup",ag.Window,ag.WindUI,ag.WindUI.ScreenGui.KeySystem)

local am={}

local an

local ao=(ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width)or 200

local ap=430
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
ap=430+(ao/2)
end

al.UIElements.Main.AutomaticSize="Y"
al.UIElements.Main.Size=UDim2.new(0,ap,0,0)

local aq

if ag.Icon then
aq=
ab.Image(ag.Icon,ag.Title..":"..ag.Icon,0,"Temp","KeySystem",ag.IconThemed)
aq.Size=UDim2.new(0,24,0,24)
aq.LayoutOrder=-1
end

local ar=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ag.KeySystem.Title or ag.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
})

local as=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16,
})

local at=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aq,
ar,
})

local au=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Active=true,
},{





at,
as,
})

local av=af("Enter Key","key",nil,"Input",function(av)
an=av
end)

local aw
if ag.KeySystem.Note and ag.KeySystem.Note~=""then
aw=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.KeySystem.Note,
TextSize=18,
TextTransparency=0.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ax=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
}),
}),
})

local ay
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
local az
if ag.KeySystem.Thumbnail.Title then
az=ac("TextLabel",{
Text=ag.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ay=ac("ImageLabel",{
Image=ag.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ao,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=al.UIElements.Main,
ScaleType="Crop",
},{
az,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
}),
})
end

ac("Frame",{

Size=UDim2.new(1,ay and-ao or 0,1,0),
Position=UDim2.new(0,ay and ao or 0,0,0),
BackgroundTransparency=1,
Parent=al.UIElements.Main,
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
au,
aw,
av,
ax,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
}),
})

local az=ac("UIScale",{
Scale=1,
Parent=al.UIElements.MainContainer,
})

local aA=ab.Drag(al.UIElements.MainContainer,{au})
local aB=false

local function CloseKeyDialog()
if aB then
return
end
aB=true
aA:Set(false)
ad(az,0.24,{Scale=0.94},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()
ad(al.UIElements.MainContainer,0.24,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()
task.delay(0.24,function()
if al.UIElements.MainContainer then
al:Close()()
end
end)
end





local b=ae("Exit","log-out",function()
CloseKeyDialog()
end,"Primary",ax.Frame,nil,nil,nil,Color3.fromRGB(220,78,78))

if ay then
b.Parent=ay
b.Size=UDim2.new(0,0,0,42)
b.Position=UDim2.new(0,10,1,-10)
b.AnchorPoint=Vector2.new(0,1)
end

if ag.KeySystem.URL then
ae("Get key","key",function()
setclipboard(ag.KeySystem.URL)
end,"Secondary",ax.Frame)
end

if ag.KeySystem.API then








local d=240
local f=false
local g=ae("Get key","key",nil,"Secondary",ax.Frame)

local h=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=g.Frame,
},{
h,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
}),
})

local i=ab.Image("chevron-down","chevron-down",0,"Temp","KeySystem",true)

i.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=g.Frame,
BackgroundTransparency=1,
},{
i,
})

local l=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
}),
})

local m=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,d,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=g,
Position=UDim2.new(1,0,1,15),
},{
l,
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=l,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
})

for p,r in next,ag.KeySystem.API do
local u=ag.WindUI.Services[r.Type]
if u then
local v={}
for x,z in next,u.Args do
table.insert(v,r[z])
end

local x=u.New(table.unpack(v))
x.Type=r.Type
table.insert(am,x)

local z=ab.Image(
r.Icon or u.Icon or Icons[r.Type]or"user",
r.Icon or u.Icon or Icons[r.Type]or"user",
0,
"Temp",
"KeySystem",
true
)
z.Size=UDim2.new(0,24,0,24)

local A=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=l,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
z,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=r.Title or u.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=r.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=r.Desc and true or false,
TextXAlignment="Left",
}),
}),
},true)

ab.AddSignal(A.MouseEnter,function()
ad(A,0.08,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(A.InputEnded,function()
ad(A,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(A.MouseButton1Click,function()
x.Copy()
ag.WindUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(g.MouseButton1Click,function()
if not f then
ad(
m,
0.3,
{Size=UDim2.new(0,d,0,l.AbsoluteSize.Y+1)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(i,0.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(
m,
0.25,
{Size=UDim2.new(0,d,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(i,0.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
f=not f
end)
end

local function handleSuccess(d)
CloseKeyDialog()
writefile("WindUI/"..(ag.Folder or"Temp").."/"..ah..".key",tostring(d))
task.wait(0.4)
ai(true)
end

local d=ae("Submit","arrow-right",function()
local d=tostring(an or"empty")local f=
ag.Folder or ag.Title

if ag.KeySystem.KeyValidator then
local g=ag.KeySystem.KeyValidator(d)

if g then
if ag.KeySystem.SaveKey then
handleSuccess(d)
else
CloseKeyDialog()
task.wait(0.4)
ai(true)
end
else
ag.WindUI:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ag.KeySystem.API then
local g=type(ag.KeySystem.Key)=="table"and table.find(ag.KeySystem.Key,d)
or ag.KeySystem.Key==d

if g then
if ag.KeySystem.SaveKey then
handleSuccess(d)
else
CloseKeyDialog()
task.wait(0.4)
ai(true)
end
end
else
local g,h
for i,l in next,am do
local m,p=l.Verify(d)
if m then
g,h=true,p
break
end
h=p
end

if g then
handleSuccess(d)
else
ag.WindUI:Notify{
Title="Key System. Error",
Content=h,
Icon="triangle-alert",
}
end
end
end,"Primary",ax,nil,nil,nil,Color3.fromRGB(70,190,105))

d.AnchorPoint=Vector2.new(1,0.5)
d.Position=UDim2.new(1,0,0.5,0)










al:Open()
end

return aa end function a.p()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.q()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'c'
local ac=ab.New


local ad,ae=unpack(a.load'p')
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()

end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.r()


local aa=a.load'c'
local ab=a.load'q'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.s()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load'q',

AcrylicPaint=a.load'r',
}

function ab.init()
local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end
ac.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.t()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae,af)
local ag={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ah=a.load'n'
local ai=ah.Create(true,"Popup",ae.WindUI.Window,ae.WindUI,af)

local aj=200

local ak=430
if ag.Thumbnail and ag.Thumbnail.Image then
ak=430+(aj/2)
end

ai.UIElements.Main.AutomaticSize="Y"
ai.UIElements.Main.Size=UDim2.new(0,ak,0,0)



local al

if ag.Icon then
al=ab.Image(
ag.Icon,
ag.Title..":"..ag.Icon,
0,
ae.WindUI.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
al.Size=UDim2.new(0,ag.IconSize,0,ag.IconSize)
al.LayoutOrder=-1
end


local am=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ag.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,al and-ag.IconSize-14 or 0,0,0)
})

local an=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
al,am
})

local ao=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





an,
})

local ap
if ag.Content and ag.Content~=""then
ap=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local ar
if ag.Thumbnail and ag.Thumbnail.Image then
local as
if ag.Thumbnail.Title then
as=ac("TextLabel",{
Text=ag.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ar=ac("ImageLabel",{
Image=ag.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,aj,1,0),
Parent=ai.UIElements.Main,
ScaleType="Crop"
},{
as,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,ar and-aj or 0,1,0),
Position=UDim2.new(0,ar and aj or 0,0,0),
BackgroundTransparency=1,
Parent=ai.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
ao,
ap,
aq,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})



local as=a.load'l'.New

for at,au in next,ag.Buttons do
as(au.Title,au.Icon,au.Callback,au.Variant,aq,ai,nil,nil,au.Color)
end

ai:Open()

return ag
end

return aa end function a.u()
return function(aa,ab)
return{
Dark={
Name="Dark",
Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#000000",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#000000",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#f9f9fa",
Toggle=Color3.fromHex"#2a9d5e",
Slider=Color3.fromHex"#07a4f3",
Checkbox=Color3.fromHex"#23bb42",
PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,
SliderIcon=Color3.fromHex"#908F95",
Primary=Color3.fromHex"#0091FF",
LabelBackground=Color3.fromHex"#000000",
LabelBackgroundTransparency=0.83,
ElementBackground=Color3.fromHex"#000000",
ElementBackgroundTransparency=0,
ElementBorder=Color3.fromHex"#000000",
ElementBorderTransparency=0.5,
},



}
end end function a.v()
local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween

function aa.New(ae,af,ag,ah,ai)
local aj=ai or 10
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local al=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ak and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local am=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(aj,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.97,
}),
ab.NewRoundFrame(aj,"Glass-1.4",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.48,
},{













}),
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak,
al,
}),
}),
})

return am
end

return aa end function a.w()

local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ac=ab(game:GetService"UserInputService")

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween


function aa.New(ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=false
local ao=0

local function updateSliderSize()
local ap=ag
local aq=ap.AbsoluteCanvasSize.Y
local ar=ap.AbsoluteWindowSize.Y

if aq<=ar then
al.Visible=false
return
end

local as=math.clamp(ar/aq,0.1,1)
al.Size=UDim2.new(1,0,as,0)
al.Visible=true
end

local function updateScrollingFramePosition()
local ap=al.Position.Y.Scale
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then return end

local at=math.max(1-al.Size.Y.Scale,0)
if at<=0 then return end

local au=ap/at

ag.CanvasPosition=Vector2.new(
ag.CanvasPosition.X,
au*as
)
end

local function updateThumbPosition()
if an then return end

local ap=ag.CanvasPosition.Y
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then
al.Position=UDim2.new(0,0,0,0)
return
end

local at=ap/as
local au=math.max(1-al.Size.Y.Scale,0)
local av=math.clamp(at*au,0,au)

al.Position=UDim2.new(0,0,av,0)
end

ad.AddSignal(ak.InputBegan,function(ap)
if(ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch)then
local aq=al.AbsolutePosition.Y
local ar=aq+al.AbsoluteSize.Y

if not(ap.Position.Y>=aq and ap.Position.Y<=ar)then
local as=ak.AbsolutePosition.Y
local at=ak.AbsoluteSize.Y
local au=al.AbsoluteSize.Y

local av=ap.Position.Y-as-au/2
local aw=at-au

local ax=math.clamp(av/aw,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end
end)

ad.AddSignal(am.InputBegan,function(ap)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
an=true
ao=ap.Position.Y-al.AbsolutePosition.Y

local aq
local ar

aq=ac.InputChanged:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseMovement or as.UserInputType==Enum.UserInputType.Touch then
local at=ak.AbsolutePosition.Y
local au=ak.AbsoluteSize.Y
local av=al.AbsoluteSize.Y

local aw=as.Position.Y-at-ao
local ax=au-av

local ay=math.clamp(aw/ax,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end)

ar=ac.InputEnded:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
an=false
if aq then aq:Disconnect()end
if ar then ar:Disconnect()end
end
end)
end
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",function()
if not an then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return ak
end


return aa end function a.x()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,
Border=af.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(ah.Icon,ah.Icon,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"
and ab.GetTextColorForHSB(ah.Color)
or typeof(ah.Color)=="string"
and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme)))
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or typeof(
ah.Color
)=="string"and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))),
})

local ak

if typeof(ah.Color)=="table"then
ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
end

local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color
or typeof(ah.Color)=="table"and Color3.new(1,1,1)
or nil,
ThemeTag=typeof(ah.Color)=="string"and{
ImageColor3=ah.Color,
},
},{
ak,
ab.NewRoundFrame(ah.Radius,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0.55,
}),
ac("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
ai,
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5),
}),
}),
})

function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an

return ah
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=ab.GetAverageColor(an)
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do
ap[aq]=ar
end
ad(al,0.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,0.06,{ImageColor3=ab.GetTextColorForHSB(an)}):Play()
end
ad(al,0.06,{ImageColor3=an}):Play()
end

return ah
end

function ah.SetIcon(am,an)
ah.Icon=an

if an then
ai=ab.Image(an,an,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.Parent=al

if typeof(ah.Color)=="Color3"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ah.Color)
elseif typeof(ah.Color)=="table"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
else
if ai then
ai:Destroy()
ai=nil
end
end
return ah
end

function ah.Destroy(am)
al:Destroy()
return ah
end

ab:OnThemeChange(function(am,an)
aj.TextColor3=ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
ai.ImageLabel.ImageColor3=
ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
end)

return ah
end

return aa end function a.y()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ac=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
if af.Callback then
task.spawn(function()
pcall(af.Callback,af.Default,af.Transparency)
end)
end
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
if af.Callback then
task.spawn(function()
pcall(af.Callback,af.Value)
end)
end
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return false
end

ad=ag
ad.DataKeyCounts={}
ad.DataLoading=false
ae.Folder=ad.Folder
ae.Path="WindUI/"..tostring(ae.Folder).."/config/"

if not isfolder"WindUI"then
makefolder"WindUI"
end
if not isfolder("WindUI/"..tostring(ae.Folder))then
makefolder("WindUI/"..tostring(ae.Folder))
end
if not isfolder(ae.Path)then
makefolder(ae.Path)
end

local ah=ae:AllConfigs()

for ai,aj in next,ah do
if isfile and readfile and isfile(aj..".json")then
ae.Configs[aj]=readfile(aj..".json")
end
end

return ae
end

function ae.SetPath(af,ag)
if not ag then
warn"[ WindUI.ConfigManager ] Custom path is not specified."
return false
end

ae.Path=ag
if not ag:match"/$"then
ae.Path=ag.."/"
end

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

return true
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad.CurrentConfig=ai
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ac:JSONEncode(ak)
if writefile then
writefile(ai.Path,al)
end

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ac:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

ad.DataLoading=true
ad.PendingConfigData=al.__elements or{}

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

for am,an in next,(al.__elements or{})do
if ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
end
end

ai.CustomData=al.__custom or{}
ad.DataLoading=false

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ac:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.MarkDirty(af)
if not ad or not ad.DataSave or ad.DataLoading then
return
end

ad.DataDirty=true
if ad.DataSaveTask then
return
end

ad.DataSaveTask=task.delay(0.35,function()
ad.DataSaveTask=nil
if ad.DataDirty then
ad:SaveData()
end
end)
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
if not isfolder(ae.Path)then
makefolder(ae.Path)
return ag
end

for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.z()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


function aa.New(af)
local ag={
Button=nil
}

local ah













local ai=ac("TextLabel",{
Text=af.Title,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local aj=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"move"[1],
ImageRectOffset=ab.Icon"move"[2].ImageRectPosition,
ImageRectSize=ab.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})
local ak=ac("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,36,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local al=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=af.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})


local am=ac("UIScale",{
Scale=1,
})

local an=ac("Frame",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=al,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
am,
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
aj,
ak,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),

BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ah,
ac("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai,
ac("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
}),
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ag.Button=an



function ag.SetIcon(ao,ap)
if ah then
ah:Destroy()
end
if ap then
ah=ab.Image(
ap,
af.Title,
0,
af.Folder,
"OpenButton",
true,
af.IconThemed
)
ah.Size=UDim2.new(0,22,0,22)
ah.LayoutOrder=-1
ah.Parent=ag.Button.TextButton
end
end

if af.Icon then
ag:SetIcon(af.Icon)
end



ab.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
al.Size=UDim2.new(
0,an.AbsoluteSize.X,
0,an.AbsoluteSize.Y
)
end)

ab.AddSignal(an.TextButton.MouseEnter,function()
ad(an.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(an.TextButton.MouseLeave,function()
ad(an.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local ao=ab.Drag(al)


function ag.Visible(ap,aq)
al.Visible=aq
end

function ag.SetScale(ap,aq)
am.Scale=aq
end

function ag.Edit(ap,aq)
local ar={
Title=aq.Title,
Icon=aq.Icon,
Enabled=aq.Enabled,
Position=aq.Position,
OnlyIcon=aq.OnlyIcon or false,
Draggable=aq.Draggable or nil,
OnlyMobile=aq.OnlyMobile,
CornerRadius=aq.CornerRadius or UDim.new(1,0),
StrokeThickness=aq.StrokeThickness or 2,
Scale=aq.Scale or 1,
Color=aq.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if ar.Enabled==false then
af.IsOpenButtonEnabled=false
end

if ar.OnlyMobile~=false then
ar.OnlyMobile=true
else
af.IsPC=false
end


if ar.Draggable==false and aj and ak then
aj.Visible=ar.Draggable
ak.Visible=ar.Draggable

if ao then
ao:Set(ar.Draggable)
end
end

if ar.Position and al then
al.Position=ar.Position
end

if ar.OnlyIcon==true and ai then
ai.Visible=false
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,7)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,7)
elseif ar.OnlyIcon==false then
ai.Visible=true
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,11)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,11)
end





if ai then
if ar.Title then
ai.Text=ar.Title
ab:ChangeTranslationKey(ai,ar.Title)
elseif ar.Title==nil then

end
end

if ar.Icon then
ag:SetIcon(ar.Icon)
end

if Glow then
Glow.UIGradient.Color=ar.Color
end

an.UICorner.CornerRadius=ar.CornerRadius
an.TextButton.UICorner.CornerRadius=UDim.new(ar.CornerRadius.Scale,ar.CornerRadius.Offset-4)

ag:SetScale(ar.Scale)
end

return ag
end



return aa end function a.A()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=ai=="Small"and 16 or 24,
TooltipArrowSizeY=ai=="Small"and 6 or 9,

PaddingX=ai=="Small"and 12 or 14,
PaddingY=ai=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ah=ah or""
aj=aj~=false

local al=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=aj,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=ai=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ah.."Text",
}
})

ak.TitleFrame=al

local am=ac("UIScale",{
Scale=.9
})

local an=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ag,
Name="Arrow",
},{
ac("ImageLabel",{
Size=UDim2.new(0,ak.TooltipArrowSizeX,0,ak.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
},{










}),
}),
ab.NewRoundFrame(ak.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

al,
ac("UIPadding",{
PaddingTop=UDim.new(0,ak.PaddingY),
PaddingLeft=UDim.new(0,ak.PaddingX),
PaddingRight=UDim.new(0,ak.PaddingX),
PaddingBottom=UDim.new(0,ak.PaddingY),
}),
})
}),
am,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ak.Container=an

function ak.Open(ao)
an.Visible=true


ad(an.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ak.Close(ao,ap)

ad(an.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

ap=ap~=false
if ap then
task.wait(.35)

an.Visible=false
an:Destroy()
end
end

return ak
end



return aa end function a.B()
game:GetService"ReplicatedStorage"
local aa=a.load'c'
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween

local ae=(cloneref or clonereference or function(ae)
return ae
end)

ae(game:GetService"UserInputService")

local function Color3ToHSB(af)
local ag,ah,ai=af.R,af.G,af.B
local aj=math.max(ag,ah,ai)
local ak=math.min(ag,ah,ai)
local al=aj-ak

local am=0
if al~=0 then
if aj==ag then
am=(ah-ai)/al%6
elseif aj==ah then
am=(ai-ag)/al+2
else
am=(ag-ah)/al+4
end
am=am*60
else
am=0
end

local an=(aj==0)and 0 or(al/aj)
local ao=aj

return{
h=math.floor(am+0.5),
s=an,
b=ao,
}
end

local function GetPerceivedBrightness(af)
local ag=af.R
local ah=af.G
local ai=af.B
return 0.299*ag+0.587*ah+0.114*ai
end

local function GetTextColorForHSB(af)
local ag=Color3ToHSB(af)local
ah, ai, aj=ag.h, ag.s, ag.b
if GetPerceivedBrightness(af)>0.5 then
return Color3.fromHSV(ah/360,0,0.05)
else
return Color3.fromHSV(ah/360,0,0.98)
end
end

local function getElementPosition(af,ag)
if type(ag)~="number"or ag~=math.floor(ag)then
return nil,1
end






local ah=#af


if ah==0 or ag<1 or ag>ah then
return nil,2
end

local function isDelimiter(ai)
if ai==nil then
return true
end
local aj=ai.__type
return aj=="Divider"or aj=="Space"or aj=="Section"or aj=="Code"
end

if isDelimiter(af[ag])then
return nil,3
end

local function calculate(ai,aj)
if aj==1 then
return"Squircle"
end
if ai==1 then
return"Squircle-TL-TR"
end
if ai==aj then
return"Squircle-BL-BR"
end
return"Square"
end

local ai=1
local aj=0

for ak=1,ah do
local al=af[ak]
if isDelimiter(al)then
if ag>=ai and ag<=ak-1 then
local am=ag-ai+1
return calculate(am,aj)
end
ai=ak+1
aj=0
else
aj=aj+1
end
end

if ag>=ai and ag<=ah then
local ak=ag-ai+1
return calculate(ak,aj)
end

return nil,4
end

return function(af)
local ag={
Title=af.Title,
Desc=af.Desc or nil,
Hover=af.Hover,
Thumbnail=af.Thumbnail,
ThumbnailSize=af.ThumbnailSize or 80,
Image=af.Image,
IconThemed=af.IconThemed or false,
ImageSize=af.ImageSize or 30,
Color=af.Color,
Scalable=af.Scalable,
Parent=af.Parent,
Justify=af.Justify or"Between",
UIPadding=af.Window.ElementConfig.UIPadding,
UICorner=af.Window.ElementConfig.UICorner,
Size=af.Size or"Default",
UIElements={},

Index=af.Index,
}

local ah=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0
local ai=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0

local aj=ag.ImageSize
local ak=ag.ThumbnailSize
local al=true


local am=0

local an
local ao
if ag.Thumbnail then
an=aa.Image(
ag.Thumbnail,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
end
if ag.Image then
ao=aa.Image(
ag.Image,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)

if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Size=UDim2.new(0,aj,0,aj)

am=aj
end

local function CreateText(ap,aq)
local ar=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=ap or"",
TextSize=aq=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ag.Color and("Element"..aq)or nil,
},
TextColor3=ag.Color and ar or nil,
TextTransparency=aq=="Desc"and 0.3 or 0,
TextWrapped=true,
Size=UDim2.new(ag.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,aq=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
})
end

local ap=CreateText(ag.Title,"Title")
local aq=CreateText(ag.Desc,"Desc")
if not ag.Title or ag.Title==""then
aq.Visible=false
end
if not ag.Desc or ag.Desc==""then
aq.Visible=false
end

ag.UIElements.Title=ap
ag.UIElements.Desc=aq

ag.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ag.Justify=="Between"and"Left"or"Center",
}),
an,
ab("Frame",{
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and-af.TextOffset or 0,
0,
0
),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=af.Window.NewElements and(ag.Justify=="Between"and"Top"or"Center")
or"Center",
HorizontalAlignment=ag.Justify~="Between"and ag.Justify or"Center",
}),
ao,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and(ao and-am-ag.UIPadding or-am)
or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ai),
PaddingLeft=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ah),
PaddingRight=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ah
),
PaddingBottom=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ai
),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap,
aq,
}),
}),
})





local ar=aa.Image("lock","lock",0,af.Window.Folder,"Lock",false)
ar.Size=UDim2.new(0,20,0,20)
ar.ImageLabel.ImageColor3=Color3.new(1,1,1)
ar.ImageLabel.ImageTransparency=0.4

local as=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local at=ab("Frame",{
Size=UDim2.new(1,ag.UIPadding*2,1,ag.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local au,av=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ar,
as,
},nil,true)

local aw,ax=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local ay,az=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local aA,aB=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
},nil,true)

local b,d=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local f,g=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ag.Color and 0.05 or nil,



Parent=af.Parent,
ThemeTag={
ImageColor3=not ag.Color and"ElementBackground"or nil,
ImageTransparency=not ag.Color and"ElementBackgroundTransparency"or nil,
},
ImageColor3=ag.Color and(typeof(ag.Color)=="string"and Color3.fromHex(
aa.Colors[ag.Color]
)or typeof(ag.Color)=="Color3"and ag.Color)or nil,
},{
ag.UIElements.Container,
at,
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
}),
},true,true)

ag.UIElements.Main=f
ag.UIElements.Locked=au

if ag.Hover then
aa.AddSignal(f.MouseEnter,function()
if al then

ad(b,0.12,{ImageTransparency=0.9}):Play()
ad(aA,0.12,{ImageTransparency=0.8}):Play()
aa.AddSignal(f.MouseMoved,function(h,i)
b.HoverGradient.Offset=
Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
aA.HoverGradient.Offset=
Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(f.InputEnded,function()
if al then

ad(b,0.12,{ImageTransparency=1}):Play()
ad(aA,0.12,{ImageTransparency=1}):Play()
end
end)
end

function ag.SetTitle(h,i)
ag.Title=i
ap.Text=i
end

function ag.SetDesc(h,i)
ag.Desc=i
aq.Text=i or""
if not i then
aq.Visible=false
elseif not aq.Visible then
aq.Visible=true
end
end

function ag.Colorize(h,i,l)
if ag.Color then
i[l]=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)
or nil
end
end

if af.ElementTable then
aa.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ag.Title~=ap.Text then
ag:SetTitle(ap.Text)
af.ElementTable.Title=ap.Text
end
end)
aa.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if ag.Desc~=aq.Text then
ag:SetDesc(aq.Text)
af.ElementTable.Desc=aq.Text
end
end)
end





function ag.SetThumbnail(h,i,l)
ag.Thumbnail=i
if l then
ag.ThumbnailSize=l
ak=l
end

if an then
if i then
an:Destroy()
an=aa.Image(
i,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
if an then
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
end
else
an.Visible=false

end
else
if i then
an=aa.Image(
i,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
if an then
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
end
end
end
end

function ag.SetImage(h,i,l)
ag.Image=i
if l then
ag.ImageSize=l
aj=l
end

if i then
local m=ao and ao.Parent or ag.UIElements.Container.TitleFrame
if ao then ao:Destroy()end

ao=aa.Image(
i,
i,
ag.UICorner-3,
af.Window.Folder,
"Image",
not ag.Color and true or false
)
if ao then
if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end


ao.Visible=true
ao.Parent=m
ao.LayoutOrder=-99

ao.Size=UDim2.new(0,aj,0,aj)
am=ag.ImageSize+ag.UIPadding
end
else
if ao then
ao.Visible=true
end
am=0
end

ag.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-am,1,0)
end

function ag.Destroy(h)
f:Destroy()
end

function ag.Lock(h,i)
al=false
au.Active=true
au.Visible=true
as.Text=i or"Locked"
end

function ag.Unlock(h)
al=true
au.Active=false
au.Visible=false
end

function ag.Highlight(h)
local i=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=aw,
})

local l=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=ay,
})

aw.ImageTransparency=0.65
ay.ImageTransparency=0.88

ad(i,0.75,{
Offset=Vector2.new(1,0),
}):Play()

ad(l,0.75,{
Offset=Vector2.new(1,0),
}):Play()

task.spawn(function()
task.wait(0.75)
aw.ImageTransparency=1
ay.ImageTransparency=1
i:Destroy()
l:Destroy()
end)
end

function ag.UpdateShape(h)
if af.Window.NewElements then
local i
if af.ParentConfig.ParentType=="Group"then
i="Squircle"
else
i=getElementPosition(h.Elements,ag.Index)
end

if i and f then
g:SetType(i)
av:SetType(i)
az:SetType(i)
ax:SetType(i.."-Outline")
d:SetType(i)
aB:SetType(i.."-Outline")
end
end
end





return ag
end end function a.C()

local aa=a.load'c'
local ab=aa.New

local ac={}

local ad=a.load'l'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,

Locked=af.Locked or false,
}
local ah=a.load'B'(af)

ag.ParagraphFrame=ah
if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for aj,ak in next,af.Buttons do
local al=ad(ak.Title,ak.Icon,ak.Callback,"White",ai,nil,nil,af.Window.NewElements and 999 or 10)
al.Size=UDim2.new(1,0,0,38)

end
end

return ag.__type,ag

end

return ac end function a.D()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag,ah,ai,aj,ak,al)
if type(ae)=="table"and type(af)=="table"and af.Window then
local am=af
local an={
__type="Button",
Title=am.Title or"Button",
Icon=am.Icon,
Callback=am.Callback,
Variant=am.Variant,
UIElements={},
}

an.ButtonFrame=a.load'B'{
Title=an.Title,
Desc=am.Desc,
Window=am.Window,
Parent=am.Parent,
TextOffset=0,
Hover=false,
Tab=am.Tab,
Index=am.Index,
ElementTable=an,
ParentConfig=am,
}

local ao=a.load'l'.New(
an.Title,
an.Icon,
an.Callback,
an.Variant,
an.ButtonFrame.UIElements.Main,
nil,
am.Window.NewElements,
am.Radius
)
ao.Size=UDim2.new(0,0,0,38)
ao.AutomaticSize="X"
ao.AnchorPoint=Vector2.new(1,am.Window.NewElements and 0 or 0.5)
ao.Position=UDim2.new(1,0,am.Window.NewElements and 0 or 0.5,0)
an.Button=ao
return an.__type,an
end

ah=ah or"Primary"
local am=al or(not ak and 10 or 99)
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
},
})
end

local ao=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 0.9,
}),

ab.NewRoundFrame(am,"Squircle",{
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(am,"Shadow-sm",{
ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",
ImageTransparency=1,
Visible=not ak,
}),


ab.NewRoundFrame(am,not ak and"Glass-1"or"Glass-0.7",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.6,
Name="Outline",
}),

ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil,
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
an,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)
or ah=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})

ab.AddSignal(ao.MouseEnter,function()
ad(ao.Frame,0.047,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(ao.MouseLeave,function()
ad(ao.Frame,0.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ao.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return ao
end

return aa end function a.E()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=game:GetService"UserInputService"

function aa.New(af,ag,ah,ai,aj,ak,al)
local am={
GlassSpritesheet={
Id="rbxassetid://77297718671545",
MirroredId="rbxassetid://92258969882244",
Size=Vector2.new(102,128),
Total=80,
Cols=10,
}
}

function am.GetGlassFrame(an,ao:number):(string,Vector2,Vector2)
local ap=am.GlassSpritesheet
local aq:number

if ao<=0.4 then
aq=math.floor((ao/0.4)*(ap.Total-1))
elseif ao<0.6 then
aq=ap.Total-1
else
aq=math.floor(((ao-0.6)/0.4)*(ap.Total-1))
end

aq=math.clamp(aq,0,ap.Total-1)

local ar=ao>=0.6
if ar then
aq=(ap.Total-1)-aq
end

local as=ar and ap.MirroredId or ap.Id

return as,
ap.Size,
Vector2.new(
(aq%ap.Cols)*ap.Size.X,
math.floor(aq/ap.Cols)*ap.Size.Y
)
end

local an=12
local ao
if ag and ag~=""then
ao=ac("ImageLabel",{
Size=UDim2.new(0,13,0,13),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ag)[1],
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local ap=ac("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=ai,
})

local aq=ab.NewRoundFrame(an,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ap,
Size=UDim2.new(0,ak and(52)or(40.8),0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
Name="ToggleFrame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(0,ak and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,

AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar"
},{
ab.NewRoundFrame(an,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=1,
},{













ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="GlassBackground",
ImageTransparency=0,
ThemeTag={
ImageColor3="ElementBackground",
},
ZIndex=-1,
}),
ac("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Glass",
ImageTransparency=0,
},{
ac("UICorner",{
CornerRadius=UDim.new(1,0),
})
}),
ab.NewRoundFrame(an,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.3,
}),
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="BarOverlay",
ThemeTag={
ImageColor3="ToggleBar",
},
ZIndex=999,
})
}),
ao,
ac("UIScale",{
Scale=1,
})
}),
}),
ac("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="Hitbox",
Text="",
})
})

local ar
local as

local at=ak and 30 or 20
local au=aq.Size.X.Offset

function am.Set(av,aw,ax,ay)
if not ay then
if aw then
ad(aq.Frame,0.35,{
Position=UDim2.new(0,au-at-2,0.5,0),
},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Toggle"},0.15)
ad(aq.Frame.Bar.Highlight.Glass,0.15,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(aq.Frame,0.35,{
Position=UDim2.new(0,2,0.5,0),
},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Text"},0.15)
ad(aq.Frame.Bar.Highlight.Glass,0.15,{ImageTransparency=0.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
else
if aw then
aq.Frame.Position=UDim2.new(0,au-at-2,0.5,0)
else
aq.Frame.Position=UDim2.new(0,2,0.5,0)
end
end

if aw then
ad(aq.Layer,0.1,{
ImageTransparency=0,
}):Play()
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Toggle"},0.1)
ad(aq.Frame.Bar.Highlight.Glass,0.1,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=0,
}):Play()
end

local az,aA,aB=am:GetGlassFrame(1)

aq.Frame.Bar.Highlight.Glass.Image=az
aq.Frame.Bar.Highlight.Glass.ImageRectSize=aA
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=aB
else
ad(aq.Layer,0.1,{
ImageTransparency=1,
}):Play()
ab.SetThemeTag(aq.Frame.Bar.Highlight.Glass,{ImageColor3="Text"},0.1)
ad(aq.Frame.Bar.Highlight.Glass,0.1,{ImageTransparency=0.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=1,
}):Play()
end

local az,aA,aB=am:GetGlassFrame(0)

aq.Frame.Bar.Highlight.Glass.Image=az
aq.Frame.Bar.Highlight.Glass.ImageRectSize=aA
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=aB
end

ax=ax~=false

task.spawn(function()
if aj and ax then
ab.SafeCallback(aj,aw)
end
end)
end

am.SetValue=am.Set
am.SetState=am.Set

function am.Animate(av,aw,ax)
if not al.Window.IsToggleDragging then
al.Window.IsToggleDragging=true

local ay=aw.Position.X
local az=aw.Position.Y
local aA=aq.Frame.Position.X.Offset
local aB=false
local b=false

ad(aq.Frame.Bar.UIScale,0.28,{Scale=1.5},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar.Highlight.BarOverlay,0.28,{ImageTransparency=.86},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ar then ar:Disconnect()end

ar=ae.InputChanged:Connect(function(d)
if not al.Window.IsToggleDragging then return end
if d.UserInputType~=Enum.UserInputType.MouseMovement and d.UserInputType~=Enum.UserInputType.Touch then return end
if aB then return end

local f=math.abs(d.Position.X-ay)
math.abs(d.Position.Y-az)

if not b and f>8 then
b=true
end

local g=d.Position.X-ay
local h=math.max(2,math.min(aA+g,au-at-2))

local i=math.clamp((h-2)/(au-at-4),0,1)

local l,m,p=am:GetGlassFrame(i)
aq.Frame.Bar.Highlight.Glass.Image=l
aq.Frame.Bar.Highlight.Glass.ImageRectSize=m
aq.Frame.Bar.Highlight.Glass.ImageRectOffset=p

ad(aq.Frame,0.12,{
Position=UDim2.new(0,h,0.5,0)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

if as then as:Disconnect()end

as=ae.InputEnded:Connect(function(d)
if not al.Window.IsToggleDragging then return end
if d.UserInputType~=Enum.UserInputType.MouseButton1 and d.UserInputType~=Enum.UserInputType.Touch then return end

al.Window.IsToggleDragging=false

if ar then ar:Disconnect()ar=nil end
if as then as:Disconnect()as=nil end

if aB then return end

if not b then
ax:Set(not ax.Value,true,false)
else
local f=aq.Frame.Position.X.Offset
local g=f+at/2
local h=g>au/2
ax:Set(h,true,false)
end

ad(aq.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar.Highlight.BarOverlay,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end
end

return ap,am
end

return aa end function a.F()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")
local ac=aa(game:GetService"RunService")

local ad=a.load'c'
local ae=ad.New
local af=ad.Tween

local ag={}

local ah=false

function ag.New(ai,aj)
local ak={
__type="Slider",
Title=aj.Title or nil,
Desc=aj.Desc or nil,
Locked=aj.Locked or nil,
LockedTitle=aj.LockedTitle,
Value=aj.Value or{},
Icons=aj.Icons or nil,
IsTooltip=aj.IsTooltip or false,
IsTextbox=aj.IsTextbox,
Step=aj.Step or 1,
Callback=aj.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=aj.Width or 130,
TextBoxWidth=aj.Window.NewElements and 40 or 30,
ThumbSize=13,
IconSize=26,
}
if ak.Icons=={}then
ak.Icons={
From="sfsymbols:sunMinFill",
To="sfsymbols:sunMaxFill",
}
end
if ak.IsTextbox==nil and ak.Title==nil then ak.IsTextbox=false else ak.IsTextbox=ak.IsTextbox~=false end

local al
local am
local an
local ao=ak.Value.Default or ak.Value.Min or 0

local ap=ao
local aq=(ao-(ak.Value.Min or 0))/((ak.Value.Max or 100)-(ak.Value.Min or 0))

local ar=true
local as=ak.Step%1~=0

local function FormatValue(at)
if as then
return tonumber(string.format("%.2f",at))
end
return math.floor(at+0.5)
end

local function CalculateValue(at)
if as then
return math.floor(at/ak.Step+0.5)*ak.Step
else
return math.floor(at/ak.Step+0.5)*ak.Step
end
end

local at,au
local av=32
if ak.Icons then
if ak.Icons.From then
at=ad.Image(
ak.Icons.From,
ak.Icons.From,
0,
aj.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
at.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
av=av+ak.IconSize-2
end
if ak.Icons.To then
au=ad.Image(
ak.Icons.To,
ak.Icons.To,
0,
aj.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
au.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
av=av+ak.IconSize-2
end
end
ak.SliderFrame=a.load'B'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=ak.Width,
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
}





ak.UIElements.SliderIcon=ad.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,not ak.IsTextbox and-av or(-ak.TextBoxWidth-8),0,4),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{

ad.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(aq,0,1,0),
ImageTransparency=.1,

ImageColor3=Color3.fromRGB(0,255,106),
},{

ad.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,aj.Window.NewElements and(ak.ThumbSize*2)or(ak.ThumbSize+2),0,aj.Window.NewElements and(ak.ThumbSize+4)or(ak.ThumbSize+2)),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ImageColor3=Color3.fromRGB(255,255,255),
Name="Thumb",
},{
ad.NewRoundFrame(99,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=.6,
}),
})
})
})





ak.UIElements.SliderContainer=ae("Frame",{
Size=UDim2.new(ak.Title==nil and 1 or 0,ak.Title==nil and 0 or ak.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,ak.IsTextbox and(aj.Window.NewElements and-16 or 0)or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=ak.SliderFrame.UIElements.Main,
},{
ae("UIListLayout",{
Padding=UDim.new(0,ak.Title~=nil and 8 or 12),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=ak.Icons and(ak.Icons.From and(ak.Icons.To and"Center"or"Left")or ak.Icons.To and"Right")or"Center",
}),
at,
ak.UIElements.SliderIcon,
au,
ae("TextBox",{
Size=UDim2.new(0,ak.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(ao),
ThemeTag={
TextColor3="Text"
},
TextTransparency=.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
Visible=ak.IsTextbox,
})
})

local aw
if ak.IsTooltip then
aw=a.load'A'.New(ao,ak.UIElements.SliderIcon.Frame.Thumb,true,"Secondary","Small",false)
aw.Container.AnchorPoint=Vector2.new(0.5,1)
aw.Container.Position=UDim2.new(0.5,0,0,-8)
end

function ak.Lock(ax)
ak.Locked=true
ar=false
return ak.SliderFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(ax)
ak.Locked=false
ar=true
return ak.SliderFrame:Unlock()
end

if ak.Locked then
ak:Lock()
end

local ax=aj.Tab.UIElements.ContainerFrame

function ak.Set(ay,az,aA)
if ar then
if not ak.IsFocusing and not ah and(not aA or(aA.UserInputType==Enum.UserInputType.MouseButton1 or aA.UserInputType==Enum.UserInputType.Touch))then
if aA then
al=(aA.UserInputType==Enum.UserInputType.Touch)
ax.ScrollingEnabled=false
ah=true

local aB=al and aA.Position.X or ab:GetMouseLocation().X
local b=math.clamp((aB-ak.UIElements.SliderIcon.AbsolutePosition.X)/ak.UIElements.SliderIcon.AbsoluteSize.X,0,1)
az=CalculateValue(ak.Value.Min+b*(ak.Value.Max-ak.Value.Min))
az=math.clamp(az,ak.Value.Min or 0,ak.Value.Max or 100)

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(b,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
if aj.Window.ConfigManager then aj.Window.ConfigManager:MarkDirty()end
ad.SafeCallback(ak.Callback,FormatValue(az))
end

am=ac.RenderStepped:Connect(function()
local d=al and aA.Position.X or ab:GetMouseLocation().X
local f=math.clamp((d-ak.UIElements.SliderIcon.AbsolutePosition.X)/ak.UIElements.SliderIcon.AbsoluteSize.X,0,1)
az=CalculateValue(ak.Value.Min+f*(ak.Value.Max-ak.Value.Min))

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(f,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
if aj.Window.ConfigManager then aj.Window.ConfigManager:MarkDirty()end
ad.SafeCallback(ak.Callback,FormatValue(az))
end
end)

an=ab.InputEnded:Connect(function(d)
if(d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch)and aA==d then
am:Disconnect()
an:Disconnect()
ah=false
ax.ScrollingEnabled=true

if aj.Window.NewElements then
af(ak.UIElements.SliderIcon.Frame.Thumb,.2,{ImageTransparency=0,Size=UDim2.new(0,aj.Window.NewElements and(ak.ThumbSize*2)or(ak.ThumbSize+2),0,aj.Window.NewElements and(ak.ThumbSize+4)or(ak.ThumbSize+2))},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
if aw then aw:Close(false)end
end
end)
else
az=math.clamp(az,ak.Value.Min or 0,ak.Value.Max or 100)

local aB=math.clamp((az-(ak.Value.Min or 0))/((ak.Value.Max or 100)-(ak.Value.Min or 0)),0,1)
az=CalculateValue(ak.Value.Min+aB*(ak.Value.Max-ak.Value.Min))

if az~=ap then
af(ak.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(aB,0,1,0)}):Play()
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(az)
if aw then aw.TitleFrame.Text=FormatValue(az)end
ak.Value.Default=FormatValue(az)
ap=az
if aj.Window.ConfigManager then aj.Window.ConfigManager:MarkDirty()end
ad.SafeCallback(ak.Callback,FormatValue(az))
end
end
end
end
end

function ak.SetMax(ay,az)
ak.Value.Max=az

local aA=tonumber(ak.Value.Default)or ap
if aA>az then
ak:Set(az)
else
local aB=math.clamp((aA-(ak.Value.Min or 0))/(az-(ak.Value.Min or 0)),0,1)
af(ak.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aB,0,1,0)}):Play()
end
end

function ak.SetMin(ay,az)
ak.Value.Min=az

local aA=tonumber(ak.Value.Default)or ap
if aA<az then
ak:Set(az)
else
local aB=math.clamp((aA-az)/((ak.Value.Max or 100)-az),0,1)
af(ak.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aB,0,1,0)}):Play()
end
end

ad.AddSignal(ak.UIElements.SliderContainer.TextBox.FocusLost,function(ay)
if ay then
local az=tonumber(ak.UIElements.SliderContainer.TextBox.Text)
if az then
ak:Set(az)
else
ak.UIElements.SliderContainer.TextBox.Text=FormatValue(ap)
if aw then aw.TitleFrame.Text=FormatValue(ap)end
end
end
end)

ad.AddSignal(ak.UIElements.SliderContainer.InputBegan,function(ay)
if ak.Locked or ah then
return
end

ak:Set(ao,ay)

if ay.UserInputType==Enum.UserInputType.MouseButton1 or ay.UserInputType==Enum.UserInputType.Touch then
if aj.Window.NewElements then
af(ak.UIElements.SliderIcon.Frame.Thumb,.24,{ImageTransparency=.85,Size=UDim2.new(0,(aj.Window.NewElements and(ak.ThumbSize*2)or(ak.ThumbSize))+8,0,ak.ThumbSize+8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
if aw then aw:Open()end
end
end)

return ak.__type,ak
end

return ag end function a.G()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.load'c'
local ad=ac.New local ae=
ac.Tween

local af={
UICorner=6,
UIPadding=8,
}

local ag=a.load'v'.New

function af.New(ah,ai)
local function NormalizeKeyCode(aj)
if typeof(aj)=="EnumItem"then
return aj.Name
elseif type(aj)=="string"then
return aj
else
return"F"
end
end

local aj={
__type="Keybind",
Title=ai.Title or"Keybind",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
Value=NormalizeKeyCode(ai.Value)or"F",
Callback=ai.Callback or function()end,
CanChange=ai.CanChange or true,
Picking=false,
UIElements={},
}

local ak=true

aj.KeybindFrame=a.load'B'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=85,
Hover=aj.CanChange,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
}

aj.UIElements.Keybind=ag(aj.Value,nil,aj.KeybindFrame.UIElements.Main,nil,ai.Window.NewElements and 12 or 10)

aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
aj.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=aj.UIElements.Keybind,
Scale=.85,
})

ac.AddSignal(aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function aj.Lock(al)
aj.Locked=true
ak=false
return aj.KeybindFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(al)
aj.Locked=false
ak=true
return aj.KeybindFrame:Unlock()
end

function aj.Set(al,am)
local an=NormalizeKeyCode(am)
aj.Value=an
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
if ai.Window.ConfigManager then
ai.Window.ConfigManager:MarkDirty()
end
end

if aj.Locked then
aj:Lock()
end

ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
if aj.CanChange then
aj.Picking=true
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=ab.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

local ao
ao=ab.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1 or an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2 then
aj.Picking=false

aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
aj.Value=an
if ai.Window.ConfigManager then
ai.Window.ConfigManager:MarkDirty()
end

al:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)

ac.AddSignal(ab.InputBegan,function(al,am)
if ab:GetFocusedTextBox()then
return
end

if not ak then
return
end

if al.UserInputType==Enum.UserInputType.Keyboard then
if al.KeyCode.Name==aj.Value then
ac.SafeCallback(aj.Callback,al.KeyCode.Name)
end
elseif al.UserInputType==Enum.UserInputType.MouseButton1 and aj.Value=="MouseLeft"then
ac.SafeCallback(aj.Callback,"MouseLeft")
elseif al.UserInputType==Enum.UserInputType.MouseButton2 and aj.Value=="MouseRight"then
ac.SafeCallback(aj.Callback,"MouseRight")
end
end)

return aj.__type,aj
end

return af end function a.H()
local aa=a.load'c'
local ab=aa.New local ac=
aa.Tween

local ad={
UICorner=8,
UIPadding=8,
}local ae=a.load'l'


.New
local af=a.load'm'.New

function ad.New(ag,ah)
local ai={
__type="Input",
Title=ah.Title or"Input",
Desc=ah.Desc or nil,
Type=ah.Type or"Input",
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
InputIcon=ah.InputIcon or false,
Placeholder=ah.Placeholder or"Enter Text...",
Value=ah.Value or"",
Callback=ah.Callback or function()end,
ClearTextOnFocus=ah.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local aj=true

ai.InputFrame=a.load'B'{
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
ParentConfig=ah,
}

local ak=af(
ai.Placeholder,
ai.InputIcon,
ai.Type=="Textarea"and ai.InputFrame.UIElements.Container or ai.InputFrame.UIElements.Main,
ai.Type,
function(ak)
ai:Set(ak,true)
end,
nil,
ah.Window.NewElements and 12 or 10,
ai.ClearTextOnFocus
)

if ai.Type=="Input"then
ak.Size=UDim2.new(0,ai.Width,0,36)
ak.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)
ak.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
else
ak.Size=UDim2.new(1,0,0,148)
end

ab("UIScale",{
Parent=ak,
Scale=1,
})

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.InputFrame:Lock(ai.LockedTitle)
end
function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.InputFrame:Unlock()
end


function ai.Set(al,am,an)
if aj then
ai.Value=am
if ah.Window.ConfigManager then
ah.Window.ConfigManager:MarkDirty()
end
aa.SafeCallback(ai.Callback,am)

if not an then
ak.Frame.Frame.TextBox.Text=am
end
end
end

function ai.SetPlaceholder(al,am)
ak.Frame.Frame.TextBox.PlaceholderText=am
ai.Placeholder=am
end

ai:Set(ai.Value)

if ai.Locked then
ai:Lock()
end

return ai.__type,ai
end

return ad end function a.I()
local aa=a.load'c'
local ab=aa.New

local ad={}

function ad.New(ae,af)
local ag=ab("Frame",{
Size=af.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ah=ab("Frame",{
Parent=af.Parent,
Size=af.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ag
})

return"Divider",{__type="Divider",ElementFrame=ah}
end

return ad end function a.J()
local aa={}

local ab=(cloneref or clonereference or function(ab)
return ab
end)

local ad=ab(game:GetService"UserInputService")
local ae=ab(game:GetService"Players").LocalPlayer:GetMouse()
local af=ab(game:GetService"Workspace").CurrentCamera

local ag=workspace.CurrentCamera

local ah=a.load'm'.New

local ai=a.load'c'
local aj=ai.New
local ak=ai.Tween

function aa.New(al,am,an,ao,ap)
local aq={}

if not am.Callback then
ap="Menu"
end

am.UIElements.UIListLayout=aj("UIListLayout",{
Padding=UDim.new(0,an.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

am.UIElements.Menu=ai.NewRoundFrame(an.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,an.MenuPadding),
PaddingLeft=UDim.new(0,an.MenuPadding),
PaddingRight=UDim.new(0,an.MenuPadding),
PaddingBottom=UDim.new(0,an.MenuPadding),
}),
aj("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.MenuPadding),
}),
aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,am.SearchBarEnabled and-an.MenuPadding-an.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
Name="Frame",
},{
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
am.UIElements.UIListLayout,
}),
}),
})

am.UIElements.MenuCanvas=aj("Frame",{
Size=UDim2.new(0,am.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=al.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
am.UIElements.Menu,
aj("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
}),
})

local function RecalculateCanvasSize()
am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=
UDim2.fromOffset(0,am.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
local ar=ag.ViewportSize.Y*0.6

local as=am.UIElements.UIListLayout.AbsoluteContentSize.Y
local at=am.SearchBarEnabled and(an.SearchBarHeight+(an.MenuPadding*3))
or(an.MenuPadding*2)
local au=as+at

if au>ar then
am.UIElements.MenuCanvas.Size=
UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,ar)
else
am.UIElements.MenuCanvas.Size=
UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,au)
end
end

function UpdatePosition()
local ar=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local as=am.UIElements.MenuCanvas

local at=af.ViewportSize.Y
-(ar.AbsolutePosition.Y+ar.AbsoluteSize.Y)
-an.MenuPadding
-54
local au=as.AbsoluteSize.Y+an.MenuPadding

local av=-54
if at<au then
av=au-at-54
end

as.Position=UDim2.new(
0,
ar.AbsolutePosition.X+ar.AbsoluteSize.X,
0,
ar.AbsolutePosition.Y+ar.AbsoluteSize.Y-av+(an.MenuPadding*2)
)
end

local ar

function aq.Display(as)
local at=am.Values
local au=""

if am.Multi then
local av={}
if typeof(am.Value)=="table"then
for aw,ax in ipairs(am.Value)do
local ay=typeof(ax)=="table"and ax.Title or ax
av[ay]=true
end
end

for aw,ax in ipairs(at)do
local ay=typeof(ax)=="table"and ax.Title or ax
if av[ay]then
au=au..ay..", "
end
end

if#au>0 then
au=au:sub(1,#au-2)
end
else
au=typeof(am.Value)=="table"and(am.Value.Title or am.Value[1])or am.Value or""
end

if am.UIElements.Dropdown then
am.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(au==""and"--"or au)
end
end

local function Callback(as)
aq:Display()
if al.Window.ConfigManager then
al.Window.ConfigManager:MarkDirty()
end
if am.Callback then
task.spawn(function()
ai.SafeCallback(am.Callback,am.Value)
end)
else
task.spawn(function()
ai.SafeCallback(as)
end)
end
end

function aq.LockValues(as,at)
if not at then
return
end

for au,av in next,am.Tabs do
if av and av.UIElements and av.UIElements.TabItem then
local aw=av.Name
local ax=false

for ay,az in next,at do
if aw==az then
ax=true
break
end
end

if ax then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

av.UIElements.TabItem.Active=false
av.Locked=true
else
if av.Selected then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(
av.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=ap=="Dropdown"and 0.4 or 0.05}
):Play()
if av.UIElements.TabIcon then
ak(
av.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=ap=="Dropdown"and 0.2 or 0}
):Play()
end
end

av.UIElements.TabItem.Active=true
av.Locked=false
end
end
end
end

function aq.Refresh(as,at)
for au,av in next,am.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not av:IsA"UIListLayout"then
av:Destroy()
end
end

am.Tabs={}

if am.SearchBarEnabled then
if not ar then
ar=ah("Search...","search",am.UIElements.Menu,nil,function(au)
for av,aw in next,am.Tabs do
if string.find(string.lower(aw.Name),string.lower(au),1,true)then
aw.UIElements.TabItem.Visible=true
else
aw.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
ar.Size=UDim2.new(1,0,0,an.SearchBarHeight)
ar.Position=UDim2.new(0,0,0,0)
ar.Name="SearchBar"
end
end

for au,av in next,at do
if av.Type~="Divider"then
local aw={
Name=typeof(av)=="table"and av.Title or av,
Desc=typeof(av)=="table"and av.Desc or nil,
Icon=typeof(av)=="table"and av.Icon or nil,
IconSize=typeof(av)=="table"and av.IconSize or nil,
Original=av,
Selected=false,
Locked=typeof(av)=="table"and av.Locked or false,
UIElements={},
}
local ax
if aw.Icon then
ax=ai.Image(aw.Icon,aw.Icon,0,al.Window.Folder,"Dropdown",true)
ax.Size=
UDim2.new(0,aw.IconSize or an.TabIcon,0,aw.IconSize or an.TabIcon)
ax.ImageLabel.ImageTransparency=ap=="Dropdown"and 0.2 or 0
aw.UIElements.TabIcon=ax
end
aw.UIElements.TabItem=ai.NewRoundFrame(
an.MenuCorner-an.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,36),
AutomaticSize=aw.Desc and"Y",
ImageTransparency=1,
Parent=am.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not aw.Locked,
},
{
ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,an.TabPadding),
PaddingLeft=UDim.new(0,an.TabPadding),
PaddingRight=UDim.new(0,an.TabPadding),
PaddingBottom=UDim.new(0,an.TabPadding),
}),
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
ax,
aj("Frame",{
Size=UDim2.new(1,ax and-an.TabPadding-an.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
aj("TextLabel",{
Text=aw.Name,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
aj("TextLabel",{
Text=aw.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=aw.Desc and true or false,
Name="Desc",
}),
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)
aw.UIElements.HoverScale=aj("UIScale",{
Scale=1,
Parent=aw.UIElements.TabItem,
})

if aw.Locked then
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if am.Multi and typeof(am.Value)=="string"then
for ay,az in next,am.Values do
if typeof(az)=="table"then
if az.Title==am.Value then
am.Value={az}
end
else
if az==am.Value then
am.Value={am.Value}
end
end
end
end

if am.Multi then
local ay=false
if typeof(am.Value)=="table"then
for az,aA in ipairs(am.Value)do
local aB=typeof(aA)=="table"and aA.Title or aA
if aB==aw.Name then
ay=true
break
end
end
end
aw.Selected=ay
else
local ay=typeof(am.Value)=="table"and am.Value.Title or am.Value
aw.Selected=ay==aw.Name
end

if aw.Selected and not aw.Locked then
aw.UIElements.TabItem.ImageTransparency=0.95
aw.UIElements.TabItem.Highlight.ImageTransparency=0.75
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

am.Tabs[au]=aw

aq:Display()

if ap=="Dropdown"then
if not aw.Locked then
ai.AddSignal(aw.UIElements.TabItem.MouseEnter,function()
ak(aw.UIElements.HoverScale,0.12,{Scale=0.98}):Play()
ak(aw.UIElements.TabItem,0.12,{
Position=UDim2.new(0,3,0,0),
ImageTransparency=0.95,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
ai.AddSignal(aw.UIElements.TabItem.MouseLeave,function()
ak(aw.UIElements.HoverScale,0.16,{Scale=1}):Play()
ak(aw.UIElements.TabItem,0.16,{
Position=UDim2.new(0,0,0,0),
ImageTransparency=aw.Selected and 0.95 or 1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then
return
end

if am.Multi then
if not aw.Selected then
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(am.Value,aw.Original)
else
if not am.AllowNone and#am.Value==1 then
return
end
aw.Selected=false
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for ay,az in next,am.Value do
if typeof(az)=="table"and(az.Title==aw.Name)or(az==aw.Name)then
table.remove(am.Value,ay)
break
end
end
end
else
for ay,az in next,am.Tabs do
ak(az.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(az.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(
az.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if az.UIElements.TabIcon then
ak(az.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
az.Selected=false
end
aw.Selected=true
ak(aw.UIElements.HoverScale,0.1,{Scale=0.97},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
am.Value=aw.Original
end
Callback()
if not am.Multi then
aq:Close()
end
end)
elseif ap=="Menu"then
if not aw.Locked then
ai.AddSignal(aw.UIElements.TabItem.MouseEnter,function()
ak(aw.UIElements.HoverScale,0.12,{Scale=0.98}):Play()
ak(aw.UIElements.TabItem,0.12,{
Position=UDim2.new(0,3,0,0),
ImageTransparency=0.95,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
ai.AddSignal(aw.UIElements.TabItem.InputEnded,function()
ak(aw.UIElements.HoverScale,0.16,{Scale=1}):Play()
ak(aw.UIElements.TabItem,0.16,{
Position=UDim2.new(0,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then
return
end
ak(aw.UIElements.HoverScale,0.1,{Scale=0.97}):Play()
Callback(av.Callback or function()end)
aq:Close(true)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'I'
:New{Parent=am.UIElements.Menu.Frame.ScrollingFrame}
end
end










am.UIElements.MenuCanvas.Size=UDim2.new(
0,
am.MenuWidth+6+6+5+5+18+6+6,
am.UIElements.MenuCanvas.Size.Y.Scale,
am.UIElements.MenuCanvas.Size.Y.Offset
)
Callback()

am.Values=at
end

aq:Refresh(am.Values)

function aq.Select(as,at)
if at then
am.Value=at
else
if am.Multi then
am.Value={}
else
am.Value=nil
end
end
aq:Refresh(am.Values)
if al.Window.ConfigManager then
al.Window.ConfigManager:MarkDirty()
end
end

RecalculateListSize()
RecalculateCanvasSize()

function aq.Open(as)
if ao then
am.UIElements.Menu.Visible=true
am.UIElements.MenuCanvas.Visible=true
am.UIElements.MenuCanvas.Active=true
am.UIElements.Menu.Size=UDim2.new(1,0,0,0)
ak(am.UIElements.Menu,0.1,{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.05,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
am.Opened=true
end)

UpdatePosition()
end
end

function aq.Close(as,at)
am.Opened=false

if at then
am.UIElements.Menu.Visible=false
am.UIElements.MenuCanvas.Visible=false
am.UIElements.MenuCanvas.Active=false
return
end

ak(am.UIElements.Menu,0.25,{
Size=UDim2.new(1,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
am.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(0.25)
am.UIElements.MenuCanvas.Visible=false
am.UIElements.MenuCanvas.Active=false
end)
end

ai.AddSignal(
(
am.UIElements.Dropdown and am.UIElements.Dropdown.MouseButton1Click
or am.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
aq:Open()
end
)

ai.AddSignal(ad.InputBegan,function(as)
if
as.UserInputType==Enum.UserInputType.MouseButton1
or as.UserInputType==Enum.UserInputType.Touch
then
local at=am.UIElements.MenuCanvas
local au,av=at.AbsolutePosition,at.AbsoluteSize

local aw=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local ax=aw.AbsolutePosition
local ay=aw.AbsoluteSize

local az=ae.X>=ax.X
and ae.X<=ax.X+ay.X
and ae.Y>=ax.Y
and ae.Y<=ax.Y+ay.Y

local aA=ae.X>=au.X
and ae.X<=au.X+av.X
and ae.Y>=au.Y
and ae.Y<=au.Y+av.Y

if al.Window.CanDropdown and am.Opened and not az and not aA then
aq:Close()
end
end
end)

ai.AddSignal(
am.UIElements.Dropdown and am.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or am.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return aq
end

return aa end function a.K()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ab=
aa(game:GetService"Workspace").CurrentCamera

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween

local ag=a.load'v'.New local ah=a.load'm'
.New
local ai=a.load'J'.New local aj=

workspace.CurrentCamera

local ak={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function ak.New(al,am)
local an={
__type="Dropdown",
Title=am.Title or"Dropdown",
Desc=am.Desc or nil,
Locked=am.Locked or false,
LockedTitle=am.LockedTitle,
Values=am.Values or{},
MenuWidth=am.MenuWidth or 180,
Value=am.Value~=nil and am.Value or am.Default,
AllowNone=am.AllowNone,
SearchBarEnabled=am.SearchBarEnabled or false,
Multi=am.Multi,
Callback=am.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if an.Multi and not an.Value then
an.Value={}
end
if an.Values and typeof(an.Value)=="number"then
an.Value=an.Values[an.Value]
end

local ao=true

an.DropdownFrame=a.load'B'{
Title=an.Title,
Desc=an.Desc,
Parent=am.Parent,
TextOffset=an.Callback and an.Width or 20,
Hover=not an.Callback and true or false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
ParentConfig=am,
}

if an.Callback then
an.UIElements.Dropdown=
ag("",nil,an.DropdownFrame.UIElements.Main,nil,am.Window.NewElements and 12 or 10)

an.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
an.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,an.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

an.UIElements.Dropdown.Size=UDim2.new(0,an.Width,0,36)
an.UIElements.Dropdown.Position=UDim2.new(1,0,am.Window.NewElements and 0 or 0.5,0)
an.UIElements.Dropdown.AnchorPoint=Vector2.new(1,am.Window.NewElements and 0 or 0.5)





end

an.DropdownMenu=ai(am,an,ak,ao,"Dropdown")

an.Display=an.DropdownMenu.Display
an.Refresh=an.DropdownMenu.Refresh
an.Select=an.DropdownMenu.Select
an.Open=an.DropdownMenu.Open
an.Close=an.DropdownMenu.Close

ae("ImageLabel",{
Image=ad.Icon"chevrons-up-down"[1],
ImageRectOffset=ad.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ad.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,an.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=an.UIElements.Dropdown and an.UIElements.Dropdown.Frame
or an.DropdownFrame.UIElements.Main,
})

function an.Lock(ap)
an.Locked=true
ao=false
return an.DropdownFrame:Lock(an.LockedTitle)
end
function an.Unlock(ap)
an.Locked=false
ao=true
return an.DropdownFrame:Unlock()
end

if an.Locked then
an:Lock()
end

return an.__type,an
end

return ak end function a.L()







local aa={}
local ad={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local ae={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ag)
local ai={}
for aj,ak in ipairs(ag)do
ai[ak]=true
end
return ai
end

local ag=createKeywordSet(ad.lua)
local ai=createKeywordSet(ad.rbx)
local aj=createKeywordSet(ad.operators)

local function getHighlight(ak,al)
local am=ak[al]

if ae[am.."_color"]then
return ae[am.."_color"]
end

if tonumber(am)then
return ae.numbers
elseif am=="nil"then
return ae.null
elseif am:sub(1,2)=="--"then
return ae.comment
elseif aj[am]then
return ae.operator
elseif ag[am]then
return ae.lua
elseif ai[am]then
return ae.rbx
elseif am:sub(1,1)=="\""or am:sub(1,1)=="\'"then
return ae.str
elseif am=="true"or am=="false"then
return ae.boolean
end

if ak[al+1]=="("then
if ak[al-1]==":"then
return ae.self_call
end

return ae.call
end

if ak[al-1]=="."then
if ak[al-2]=="Enum"then
return ae.rbx
end

return ae.local_property
end
end

function aa.run(ak)
local al={}
local am=""

local an=false
local ao=false
local ap=false

for aq=1,#ak do
local ar=ak:sub(aq,aq)

if ao then
if ar=="\n"and not ap then
table.insert(al,am)
table.insert(al,ar)
am=""

ao=false
elseif ak:sub(aq-1,aq)=="]]"and ap then
am=am.."]"

table.insert(al,am)
am=""

ao=false
ap=false
else
am=am..ar
end
elseif an then
if ar==an and ak:sub(aq-1,aq-1)~="\\"or ar=="\n"then
am=am..ar
an=false
else
am=am..ar
end
else
if ak:sub(aq,aq+1)=="--"then
table.insert(al,am)
am="-"
ao=true
ap=ak:sub(aq+2,aq+3)=="[["
elseif ar=="\""or ar=="\'"then
table.insert(al,am)
am=ar
an=ar
elseif aj[ar]then
table.insert(al,am)
table.insert(al,ar)
am=""
elseif ar:match"[%w_]"then
am=am..ar
else
table.insert(al,am)
table.insert(al,ar)
am=""
end
end
end

table.insert(al,am)

local aq={}

for ar,as in ipairs(al)do
local at=getHighlight(al,ar)

if at then
local au=string.format("<font color = \"#%s\">%s</font>",at:ToHex(),as:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(aq,au)
else
table.insert(aq,as)
end
end

return table.concat(aq)
end

return aa end function a.M()
local aa={}

local ad=a.load'c'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'L'

function aa.New(aj,ak,al,am,an)
local ao={
Radius=12,
Padding=10
}

local ap=ae("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ao.Padding+3),
PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),
PaddingBottom=UDim.new(0,ao.Padding+3),
})
})
ap.Font="Code"

local aq=ae("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ap
})

local ar=ae("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ao.Padding/2,0,ao.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=am and true or false,
},{
ad.NewRoundFrame(ao.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ae("UIScale",{
Scale=1,
}),
ae("ImageLabel",{
Image=ad.Icon"copy"[1],
ImageRectSize=ad.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ad.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ad.AddSignal(ar.MouseEnter,function()
ag(ar.Button,.05,{ImageTransparency=.95}):Play()
ag(ar.Button.UIScale,.05,{Scale=.9}):Play()
end)
ad.AddSignal(ar.InputEnded,function()
ag(ar.Button,.08,{ImageTransparency=1}):Play()
ag(ar.Button.UIScale,.08,{Scale=1}):Play()
end)

local as=ad.NewRoundFrame(ao.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
AutomaticSize="Y",
Parent=al,
},{
ad.NewRoundFrame(ao.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ad.NewRoundFrame(ao.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
Visible=ak and true or false
},{
ae("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
ae("TextLabel",{
Text=ak,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,ar and-20-(ao.Padding*2),0,0)
}),
ae("UIPadding",{

PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),

}),
ae("UIListLayout",{
Padding=UDim.new(0,ao.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
aq,
ae("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
ar,
})

ao.CodeFrame=as

ad.AddSignal(ap:GetPropertyChangedSignal"TextBounds",function()
aq.Size=UDim2.new(1,0,0,(ap.TextBounds.Y/(an or 1))+((ao.Padding+3)*2))
end)

function ao.Set(at)
ap.Text=ai.run(at)
end

function ao.Destroy()
as:Destroy()
ao=nil
end

ao.Set(aj)

ad.AddSignal(ar.MouseButton1Click,function()
if am then
am()
local at=ad.Icon"check"
ar.Button.ImageLabel.Image=at[1]
ar.Button.ImageLabel.ImageRectSize=at[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=at[2].ImageRectPosition

task.wait(1)
local au=ad.Icon"copy"
ar.Button.ImageLabel.Image=au[1]
ar.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition
end
end)
return ao
end


return aa end function a.N()
local aa=a.load'c'local ad=
aa.New


local ae=a.load'M'

local ag={}

function ag.New(ai,aj)
local ak={
__type="Code",
Title=aj.Title,
Code=aj.Code,
OnCopy=aj.OnCopy,
}

local al=not ak.Locked











local am=ae.New(ak.Code,ak.Title,aj.Parent,function()
if al then
local am=ak.Title or"code"
local an,ao=pcall(function()
toclipboard(ak.Code)

if ak.OnCopy then ak.OnCopy()end
end)
if not an then
aj.WindUI:Notify{
Title="Error",
Content="The "..am.." is not copied. Error: "..ao,
Icon="x",
Duration=5,
}
end
end
end,aj.WindUI.UIScale,ak)

function ak.SetCode(an,ao)
am.Set(ao)
ak.Code=ao
end

function ak.Set(an,ao)
return ak.SetCode(ao)
end

function ak.Destroy(an)
am.Destroy()
ak=nil
end

ak.ElementFrame=am.CodeFrame

return ak.__type,ak
end

return ag end function a.O()
local aa=a.load'c'
local ad=aa.New local ae=
aa.Tween

local ag=(cloneref or clonereference or function(ag)return ag end)

local ai=ag(game:GetService"UserInputService")
ag(game:GetService"TouchInputService")
local aj=ag(game:GetService"RunService")
local ak=ag(game:GetService"Players")

local al=aj.RenderStepped
local am=ak.LocalPlayer
local an=am:GetMouse()

local ao=a.load'l'.New
local ap=a.load'm'.New

local aq={
UICorner=9,

}

function aq.Colorpicker(ar,as,at,au,av)
local aw={
__type="Colorpicker",
Title=as.Title,
Desc=as.Desc,
Default=as.Value or as.Default,
Callback=as.Callback,
Transparency=as.Transparency,
UIElements=as.UIElements,

TextPadding=10,
}

function aw.SetHSVFromRGB(ax,ay)
local az,aA,aB=Color3.toHSV(ay)
aw.Hue=az
aw.Sat=aA
aw.Vib=aB
end

aw:SetHSVFromRGB(aw.Default)

local ax=a.load'n'
local ay=ax.Create(nil,"Dialog",at,au,at.UIElements.Main.Main)

aw.ColorpickerFrame=ay

ay.UIElements.Main.Size=UDim2.new(1,0,0,0)



local az,aA,aB=aw.Hue,aw.Sat,aw.Vib

aw.UIElements.Title=ad("TextLabel",{
Text=aw.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,aw.TextPadding/2),
PaddingLeft=UDim.new(0,aw.TextPadding/2),
PaddingRight=UDim.new(0,aw.TextPadding/2),
PaddingBottom=UDim.new(0,aw.TextPadding/2),
})
})





local b=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=aw.Default
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

aw.UIElements.SatVibMap=ad("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+aw.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(az,1,1),
BackgroundTransparency=0,
Parent=ay.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

b,
})

aw.UIElements.Inputs=ad("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(aw.Transparency and 240 or 210,40+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ad("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local d=ad("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=aw.Transparency,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







d,
})

local f=ad("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
f,
})

local g={}

for h=0,1,0.1 do
table.insert(g,ColorSequenceKeypoint.new(h,Color3.fromHSV(h,1,1)))
end

local h=ad("UIGradient",{
Color=ColorSequence.new(g),
Rotation=90,
})

local i=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local l=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=i,


BackgroundColor3=aw.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local m=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+aw.TextPadding),
Parent=ay.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
h,
i,
})


function CreateNewInput(p,r)
local u=ap(p,nil,aw.UIElements.Inputs)

ad("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=u.Frame,
Text=p,
})

ad("UIScale",{
Parent=u,
Scale=.85,
})

u.Frame.Frame.TextBox.Text=r
u.Size=UDim2.new(0,150,0,42)

return u
end

local function ToRGB(p)
return{
R=math.floor(p.R*255),
G=math.floor(p.G*255),
B=math.floor(p.B*255)
}
end

local p=CreateNewInput("Hex","#"..aw.Default:ToHex())

local r=CreateNewInput("Red",ToRGB(aw.Default).R)
local u=CreateNewInput("Green",ToRGB(aw.Default).G)
local v=CreateNewInput("Blue",ToRGB(aw.Default).B)
local x
if aw.Transparency then
x=CreateNewInput("Alpha",((1-aw.Transparency)*100).."%")
end

local z=ad("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main,
LayoutOrder=4,
},{
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local A={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()av(Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib),aw.Transparency)end
}
}

for B,C in next,A do
local F=ao(C.Title,C.Icon,C.Callback,C.Variant,z,ay,false)
F.Size=UDim2.new(0.5,-3,0,40)
F.AutomaticSize="None"
end



local B,C,F
if aw.Transparency then
local G=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

C=ad("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=G,

},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

F=ad("Frame",{
Size=UDim2.fromScale(1,1),
},{
ad("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ad("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

B=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+aw.TextPadding),
Parent=ay.UIElements.Main,
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ad("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
F,
G,
})
end

function aw.Round(G,H,J)
if J==0 then
return math.floor(H)
end
H=tostring(H)
return H:find"%."and tonumber(H:sub(1,H:find"%."+J))or H
end


function aw.Update(G,H,J)
if H then az,aA,aB=Color3.toHSV(H)else az,aA,aB=aw.Hue,aw.Sat,aw.Vib end

aw.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(az,1,1)
b.Position=UDim2.new(aA,0,1-aB,0)
b.BackgroundColor3=Color3.fromHSV(az,aA,aB)
f.BackgroundColor3=Color3.fromHSV(az,aA,aB)
l.BackgroundColor3=Color3.fromHSV(az,1,1)
l.Position=UDim2.new(0.5,0,az,0)

p.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(az,aA,aB):ToHex()
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).R
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).G
v.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).B

if J or aw.Transparency then
f.BackgroundTransparency=aw.Transparency or J
F.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundTransparency=aw.Transparency or J
C.Position=UDim2.new(0.5,0,1-aw.Transparency or J,0)
x.Frame.Frame.TextBox.Text=aw:Round((1-aw.Transparency or J)*100,0).."%"
end
end

aw:Update(aw.Default,aw.Transparency)




local function GetRGB()
local G=Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib)
return{R=math.floor(G.r*255),G=math.floor(G.g*255),B=math.floor(G.b*255)}
end



local function clamp(G,H,J)
return math.clamp(tonumber(G)or 0,H,J)
end

aa.AddSignal(p.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=p.Frame.Frame.TextBox.Text:gsub("#","")
local J,L=pcall(Color3.fromHex,H)
if J and typeof(L)=="Color3"then
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(L)
aw:Update()
aw.Default=L
end
end
end)

local function updateColorFromInput(G,H)
aa.AddSignal(G.Frame.Frame.TextBox.FocusLost,function(J)
if J then
local L=G.Frame.Frame.TextBox
local M=GetRGB()
local N=clamp(L.Text,0,255)
L.Text=tostring(N)

M[H]=N
local O=Color3.fromRGB(M.R,M.G,M.B)
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(O)
aw:Update()
end
end)
end

updateColorFromInput(r,"R")
updateColorFromInput(u,"G")
updateColorFromInput(v,"B")

if aw.Transparency then
aa.AddSignal(x.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=x.Frame.Frame.TextBox
local J=clamp(H.Text,0,100)
H.Text=tostring(J)

aw.Transparency=1-J*0.01
aw:Update(nil,aw.Transparency)
end
end)
end



local G=aw.UIElements.SatVibMap
aa.AddSignal(G.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=G.AbsolutePosition.X
local L=J+G.AbsoluteSize.X
local M=math.clamp(an.X,J,L)

local N=G.AbsolutePosition.Y
local O=N+G.AbsoluteSize.Y
local P=math.clamp(an.Y,N,O)

aw.Sat=(M-J)/(L-J)
aw.Vib=1-((P-N)/(O-N))
aw:Update()

al:Wait()
end
end
end)

aa.AddSignal(m.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=m.AbsolutePosition.Y
local L=J+m.AbsoluteSize.Y
local M=math.clamp(an.Y,J,L)

aw.Hue=((M-J)/(L-J))
aw:Update()

al:Wait()
end
end
end)

if aw.Transparency then
aa.AddSignal(B.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=B.AbsolutePosition.Y
local L=J+B.AbsoluteSize.Y
local M=math.clamp(an.Y,J,L)

aw.Transparency=1-((M-J)/(L-J))
aw:Update()

al:Wait()
end
end
end)
end

return aw
end

function aq.New(ar,as)
local at={
__type="Colorpicker",
Title=as.Title or"Colorpicker",
Desc=as.Desc or nil,
Locked=as.Locked or false,
LockedTitle=as.LockedTitle,
Default=as.Default or Color3.new(1,1,1),
Callback=as.Callback or function()end,

UIScale=as.UIScale,
Transparency=as.Transparency,
UIElements={}
}

local au=true



at.ColorpickerFrame=a.load'B'{
Title=at.Title,
Desc=at.Desc,
Parent=as.Parent,
TextOffset=40,
Hover=false,
Tab=as.Tab,
Index=as.Index,
Window=as.Window,
ElementTable=at,
ParentConfig=as,
}

at.UIElements.Colorpicker=aa.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=at.Default,
Parent=at.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function at.Lock(av)
at.Locked=true
au=false
return at.ColorpickerFrame:Lock(at.LockedTitle)
end
function at.Unlock(av)
at.Locked=false
au=true
return at.ColorpickerFrame:Unlock()
end

if at.Locked then
at:Lock()
end


function at.Update(av,aw,ax)
at.UIElements.Colorpicker.ImageTransparency=ax or 0
at.UIElements.Colorpicker.ImageColor3=aw
at.Default=aw
if ax then
at.Transparency=ax
end
if as.Window.ConfigManager then
as.Window.ConfigManager:MarkDirty()
end
end

function at.Set(av,aw,ax)
return at:Update(aw,ax)
end

aa.AddSignal(at.UIElements.Colorpicker.MouseButton1Click,function()
if au then
aq:Colorpicker(at,as.Window,as.WindUI,function(av,aw)
at:Update(av,aw)
at.Default=av
at.Transparency=aw
aa.SafeCallback(at.Callback,av,aw)
end).ColorpickerFrame:Open()
end
end)

return at.__type,at
end

return aq end function a.P()
local aa=a.load'c'
local ad=aa.New
local ae=aa.Tween

local ag={}

function ag.New(ai,aj)
local ak={
__type="Section",
Title=aj.Title or"Section",
Desc=aj.Desc,
Icon=aj.Icon,
IconThemed=aj.IconThemed,
TextXAlignment=aj.TextXAlignment or"Left",
TextSize=aj.TextSize or 19,
DescTextSize=aj.DescTextSize or 16,
Box=aj.Box or false,
BoxBorder=aj.BoxBorder or false,
FontWeight=aj.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=aj.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=aj.TextTransparency or 0.05,
DescTextTransparency=aj.DescTextTransparency or 0.4,
Opened=aj.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local al


function ak.SetIcon(am,an)
ak.Icon=an or nil
if al then al:Destroy()end
if an then
al=aa.Image(
an,
an..":"..ak.Title,
0,
aj.Window.Folder,
ak.__type,
true,
ak.IconThemed,
"SectionIcon"
)
al.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
end
end

local am=ad("Frame",{
Size=UDim2.new(0,ak.IconSize,0,ak.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
})
})


if ak.Icon then
ak:SetIcon(ak.Icon)
end

local an=ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=ak.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4)
})
})

local ao,ap

local function createTitle(aq,ar)
return ad("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=ak.TextXAlignment,
AutomaticSize="Y",
TextSize=ar=="Title"and ak.TextSize or ak.DescTextSize,
TextTransparency=ar=="Title"and ak.TextTransparency or ak.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,ar=="Title"and ak.FontWeight or ak.DescFontWeight),


Text=aq,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
Parent=an,
})
end

ao=createTitle(ak.Title,"Title")
if ak.Desc then
ap=createTitle(ak.Desc,"Desc")
end

local function UpdateTitleSize()
local aq=0
if al then
aq=aq-(ak.IconSize+8)
end
if am.Visible then
aq=aq-(ak.IconSize+8)
end
an.Size=UDim2.new(1,aq,0,0)
end


local aq=aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=aj.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag={
ImageTransparency=ak.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not ak.Box and 1 or nil,
},{
aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,aj.Window.NewElements and"Glass-1"or"SquircleOutline",{
Size=UDim2.new(1,0,1,0),

ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=ak.Box and ak.BoxBorder,
Name="Outline",
}),
ad("TextButton",{
Size=UDim2.new(1,0,0,ak.Expandable and 0 or(not ap and ak.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not ak.Expandable or ap)and"Y"or nil,
Text="",
Name="Top",
},{
ak.Box and ad("UIPadding",{
PaddingTop=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingBottom=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
})or nil,
al,
an,
ad("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
}),
ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,ak.HeaderSize)
},{
ak.Box and ad("UIPadding",{
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,aj.Window.ElementConfig.UIPadding),
})or nil,
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,aj.Tab.Gap),
VerticalAlignment="Top",
}),
})
})





ak.ElementFrame=aq

if ap then
aq.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
aq.Content.Position=UDim2.new(0,0,0,aq.Top.AbsoluteSize.Y/aj.UIScale)

if ak.Opened then ak:Open(true)else ak.Close(true)end
end)
end


local ar=aj.ElementsModule

ar.Load(ak,aq.Content,ar.Elements,aj.Window,aj.WindUI,function()
if not ak.Expandable then
ak.Expandable=true
am.Visible=true
UpdateTitleSize()
end
end,ar,aj.UIScale,aj.Tab)


UpdateTitleSize()

function ak.SetTitle(as,at)
ak.Title=at
ao.Text=at
end

function ak.SetDesc(as,at)
ak.Desc=at
if not ap then
ap=createTitle(at,"Desc")
end
ap.Text=at
end

function ak.Destroy(as)
for at,au in next,ak.Elements do
au:Destroy()
end








aq:Destroy()
end

function ak.Open(as,at)
if ak.Expandable then
ak.Opened=true
if at then
aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y)/aj.UIScale+(aq.Content.AbsoluteSize.Y/aj.UIScale))
am.ImageLabel.Rotation=180
else
ae(aq,0.33,{
Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y)/aj.UIScale+(aq.Content.AbsoluteSize.Y/aj.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ae(am.ImageLabel,0.2,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end
function ak.Close(as,at)
if ak.Expandable then
ak.Opened=false
if at then
aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y/aj.UIScale))
am.ImageLabel.Rotation=0
else
ae(aq,0.26,{
Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y/aj.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(am.ImageLabel,0.2,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

aa.AddSignal(aq.Top.MouseButton1Click,function()
if ak.Expandable then
if ak.Opened then
ak:Close()
else
ak:Open()
end
end
end)

aa.AddSignal(aq.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ak.Opened then
ak:Open(true)
end
end)

task.spawn(function()
task.wait(0.02)
if ak.Expandable then








aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,aq.Top.AbsoluteSize.Y/aj.UIScale)
aq.AutomaticSize="None"
aq.Top.Size=UDim2.new(1,0,0,(not ap and ak.HeaderSize or 0))
aq.Top.AutomaticSize=(not ak.Expandable or ap)and"Y"or"None"
aq.Content.Visible=true
end
if ak.Opened then
ak:Open()
end

end)

return ak.__type,ak
end

return ag end function a.Q()

local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj=ad("Frame",{
Parent=ai.Parent,
Size=not table.find({"Group","HStack"},ai.ParentType)and UDim2.new(1,-7,0,7*(ai.Columns or 1))or UDim2.new(0,7*(ai.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=aj}
end

return ae end function a.R()
local aa=a.load'c'
local ad=aa.New

local ae={}

local function ParseAspectRatio(ag)
if type(ag)=="string"then
local ai,aj=ag:match"(%d+):(%d+)"
if ai and aj then
return tonumber(ai)/tonumber(aj)
end
elseif type(ag)=="number"then
return ag
end
return nil
end

function ae.New(ag,ai)
local aj={
__type="Image",
Image=ai.Image or"",
AspectRatio=ai.AspectRatio or"16:9",
Radius=ai.Radius or ai.Window.ElementConfig.UICorner,
}
local ak=aa.Image(
aj.Image,
aj.Image,
aj.Radius,
ai.Window.Folder,
"Image",
false
)
if ak and ak.Parent then
ak.Parent=ai.Parent
ak.Size=UDim2.new(1,0,0,0)
ak.BackgroundTransparency=1












local al=ParseAspectRatio(aj.AspectRatio)
local am

if al then
am=ad("UIAspectRatioConstraint",{
Parent=ak,
AspectRatio=al,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function aj.Destroy(an)
ak:Destroy()
end
end

return aj.__type,aj
end

return ae end function a.S()
local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="Group",
Elements={},
ElementFrame=nil,
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6))
}),
})

aj.ElementFrame=ak

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.WindUI,
function(am,an)
local ao=ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6)

local ap={}
local aq=0

for ar,as in next,an do
if as.__type=="Space"then
aq=aq+(as.ElementFrame.Size.X.Offset or 6)
elseif as.__type=="Divider"then
aq=aq+(as.ElementFrame.Size.X.Offset or 1)
else
table.insert(ap,as)
end
end

local ar=#ap
if ar==0 then return end

local as=1/ar

local at=ao*(ar-1)

local au=-(at+aq)

local av=math.floor(au/ar)
local aw=au-(av*ar)

for ax,ay in next,ap do
local az=av
if ax<=math.abs(aw)then
az=az-1
end

if ay.ElementFrame then
ay.ElementFrame.Size=UDim2.new(as,az,1,0)
end
end
end,
al,
ai.UIScale,
ai.Tab
)



return aj.__type,aj
end

return ae end function a.T()
local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="HStack",
AutoSpace=ai.AutoSpace or false,
Elements={},
ElementFrame=nil,
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6))
}),
})

aj.ElementFrame=ak

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.WindUI,
function(am,an)
local ao=ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6)

local ap={}
local aq=0

for ar,as in next,an do
if as.__type=="Space"then
aq=aq+(as.ElementFrame.Size.X.Offset or 6)
elseif as.__type=="Divider"then
aq=aq+(as.ElementFrame.Size.X.Offset or 1)
else
table.insert(ap,as)
end
end

local ar=#ap
if ar==0 then return end

local as=1/ar

local at=ao*(ar-1)

local au=-(at+aq)

local av=math.floor(au/ar)
local aw=au-(av*ar)

for ax,ay in next,ap do
local az=av
if ax<=math.abs(aw)then
az=az-1
end

if ay.ElementFrame then
ay.ElementFrame.Size=UDim2.new(as,az,1,0)
end
end
end,
al,
ai.UIScale,
ai.Tab
)

if aj.AutoSpace then
for am in next,al.Elements do
if am~="Space"and am~="Divider"then
local an=aj[am]
aj[am]=function(ao,ap)
if#aj.Elements>0 then
aj:Space()
end
return an(ao,ap)
end
end
end
end


return aj.__type,aj
end

return ae end function a.U()
local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="VStack",
Elements={},
ElementFrame=nil,
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment="Center",

Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6))
}),
})

aj.ElementFrame=ak

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.WindUI,







































nil,
al,
ai.UIScale,
ai.Tab
)



return aj.__type,aj
end

return ae end function a.V()
return{
Elements={
Paragraph=a.load'C',
Button=a.load'D',
Toggle=a.load'E',
Slider=a.load'F',
Keybind=a.load'G',
Input=a.load'H',
Dropdown=a.load'K',
Code=a.load'N',
Colorpicker=a.load'O',
Section=a.load'P',
Divider=a.load'I',
Space=a.load'Q',
Image=a.load'R',
Group=a.load'S',
HStack=a.load'T',
VStack=a.load'U',

},
Load=function(aa,ad,ae,ag,ai,aj,ak,al,am)
local function DataSegment(an)
local ao=tostring(an or"")
ao=ao:gsub("[^%w]+","_")
ao=ao:gsub("^_+",""):gsub("_+$","")
return ao
end

local function GetAutomaticDataKey(an,ao)
local ap=am and am.Title or"Tab"
local aq=aa~=am and aa.Title or nil
local ar={DataSegment(ap)}
if aq then
table.insert(ar,DataSegment(aq))
end
table.insert(ar,DataSegment(ao.__type))
table.insert(ar,DataSegment(ao.Title))

local as="__auto/"..table.concat(ar,"/")
local at=(ag.DataKeyCounts[as]or 0)+1
ag.DataKeyCounts[as]=at
return at==1 and as or as.."_"..tostring(at)
end

for an,ao in next,ae do
aa[an]=function(ap,aq)
aq=aq or{}
aq.Tab=am or aa
aq.ParentType=aa.__type
aq.ParentTable=aa
aq.Index=#aa.Elements+1
aq.GlobalIndex=#ag.AllElements+1
aq.Parent=ad
aq.Window=ag
aq.WindUI=ai
aq.UIScale=al
aq.ElementsModule=ak local

ar, as=ao:New(aq)
local at=aq.Flag
if not at and ag.DataSave then
at=GetAutomaticDataKey(aq,as)
as.__dataKey=at
end

if at and typeof(at)=="string"then
if ag.CurrentConfig then
ag.CurrentConfig:Register(at,as)

local au=at
if ag.PendingConfigData and not ag.PendingConfigData[au]and aq.GlobalIndex then
au="__auto_"..tostring(aq.GlobalIndex).."_"..tostring(as.__type)
end
if ag.PendingConfigData and ag.PendingConfigData[au]then
local av=ag.PendingConfigData[au]

local aw=ag.ConfigManager
if aw.Parser[av.__type]then
task.defer(function()
local ax,ay=pcall(function()
aw.Parser[av.__type].Load(as,av)
end)

if ax then
ag.PendingConfigData[au]=nil
else
warn(
"[ WindUI ] Failed to apply pending config for '"
..at
.."': "
..tostring(ay)
)
end
end)
end
end
else
ag.PendingFlags=ag.PendingFlags or{}
ag.PendingFlags[at]=as
end
end

local au
for av,aw in next,as do
if typeof(aw)=="table"and av~="ElementFrame"and av:match"Frame$"then
au=aw
break
end
end

if au then
as.ElementFrame=au.UIElements.Main
function as.SetTitle(av,aw)
return au.SetTitle and au:SetTitle(aw)
end
function as.SetDesc(av,aw)
return au.SetDesc and au:SetDesc(aw)
end
function as.SetImage(av,aw,ax)
return au.SetImage and au:SetImage(aw,ax)
end
function as.SetThumbnail(av,aw,ax)
return au.SetThumbnail and au:SetThumbnail(aw,ax)
end
function as.Highlight(av)
au:Highlight()
end
function as.Destroy(av)
au:Destroy()

table.remove(ag.AllElements,aq.GlobalIndex)
table.remove(aa.Elements,aq.Index)
table.remove(am.Elements,aq.Index)
aa:UpdateAllElementShapes(aa)
end
end

ag.AllElements[aq.Index]=as
aa.Elements[aq.Index]=as
if am then
am.Elements[aq.Index]=as
end

if ag.NewElements then
aa:UpdateAllElementShapes(aa)
end

if aj then
aj(as,aa.Elements)
end
return as
end
end
function aa.UpdateAllElementShapes(an,ao)
for ap,aq in next,ao.Elements do
local ar
for as,at in pairs(aq)do
if typeof(at)=="table"and as:match"Frame$"then
ar=at
break
end
end

if ar then

ar.Index=ap
if ar.UpdateShape then

ar.UpdateShape(ao)
end
end
end
end
end,
}end function a.W()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=game:GetService"Players"

aa(game:GetService"UserInputService")
local ae=ad.LocalPlayer:GetMouse()

local ag=a.load'c'
local ai=ag.New

local aj=a.load'A'.New
local ak=a.load'w'.New



local al={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(al)end,
}

function al.Init(am,an,ao,ap)
Window=am
WindUI=an
al.ToolTipParent=ao
al.TabHighlight=ap
return al
end

function al.New(am,an)
local ao={
__type="Tab",
Title=am.Title or"Tab",
Desc=am.Desc,
Icon=am.Icon,
IconColor=am.IconColor,
IconShape=am.IconShape,
IconThemed=am.IconThemed,
Locked=am.Locked,
ShowTabTitle=am.ShowTabTitle,
TabTitleAlign=am.TabTitleAlign or"Left",
CustomEmptyPage=(am.CustomEmptyPage and next(am.CustomEmptyPage)~=nil)and am.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=am.Border,
Selected=false,
Index=nil,
Parent=am.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}









if ao.IconShape then
ao.TabPaddingX=2+(Window.UIPadding/4)
ao.TabPaddingY=2+(Window.UIPadding/4)
ao.TitlePaddingY=2+(Window.UIPadding/4)
end

al.TabCount=al.TabCount+1

local ap=al.TabCount
ao.Index=ap

ao.UIElements.Main=ag.NewRoundFrame(ao.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=am.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ag.NewRoundFrame(ao.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline",
},{













}),
ag.NewRoundFrame(ao.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="TabTitle",
},
TextTransparency=not ao.Locked and 0.4 or 0.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,ao.TitlePaddingY),


PaddingBottom=UDim.new(0,ao.TitlePaddingY),
}),
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,ao.TabPaddingY),
PaddingLeft=UDim.new(0,ao.TabPaddingX),
PaddingRight=UDim.new(0,ao.TabPaddingX),
PaddingBottom=UDim.new(0,ao.TabPaddingY),
}),
}),
},true)

local aq=ai("UIScale",{
Scale=1,
Parent=ao.UIElements.Main,
})


local ar=ao.UIElements.Main.Position
local as=ar+UDim2.new(0,3,0,0)

ag.AddSignal(ao.UIElements.Main.MouseEnter,function()
if not ao.Locked then
ag.Tween(
ao.UIElements.Main,
0.18,
{
Position=as
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

ag.AddSignal(ao.UIElements.Main.MouseLeave,function()
ag.Tween(
ao.UIElements.Main,
0.18,
{
Position=ar
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end)

ag.AddSignal(ao.UIElements.Main.InputBegan,function(at)
if ao.Locked then
return
end

if at.UserInputType==Enum.UserInputType.Touch
or at.UserInputType==Enum.UserInputType.MouseButton1 then
ag.Tween(aq,0.1,{Scale=0.97},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)


ao.UIElements.ActiveIndicator=ag.NewRoundFrame(ao.UICorner,"Squircle",{
Size=UDim2.new(0,0,1,-8),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageColor3=Color3.fromHex"#FFFFFF",
ImageTransparency=1,
LayoutOrder=1,
ZIndex=10,
Parent=ao.UIElements.Main,
})

local at=0
local au
local av

if ao.Icon then
au=ag.Image(
ao.Icon,
ao.Icon..":"..ao.Title,
0,
Window.Folder,
ao.__type,
ao.IconColor and false or true,
ao.IconThemed,
"TabIcon"
)
au.Size=UDim2.new(0,16,0,16)
if ao.IconColor then
au.ImageLabel.ImageColor3=ao.IconColor
end
if not ao.IconShape then
au.Parent=ao.UIElements.Main.Frame
ao.UIElements.Icon=au
au.ImageLabel.ImageTransparency=not ao.Locked and 0 or 0.7
at=-18-(Window.UIPadding/2)
ao.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,at,0,0)
elseif ao.IconColor then
ag.NewRoundFrame(
ao.IconShape~="Circle"and(ao.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=ao.IconColor,
Parent=ao.UIElements.Main.Frame,
},
{
au,
ag.NewRoundFrame(
ao.IconShape~="Circle"and(ao.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Glass-1.4",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0,
Name="Outline",
},
{













}
),
}
)
au.AnchorPoint=Vector2.new(0.5,0.5)
au.Position=UDim2.new(0.5,0,0.5,0)
au.ImageLabel.ImageTransparency=0
au.ImageLabel.ImageColor3=ag.GetTextColorForHSB(ao.IconColor,0.68)
at=-28-(Window.UIPadding/2)
ao.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,at,0,0)
end

av=
ag.Image(ao.Icon,ao.Icon..":"..ao.Title,0,Window.Folder,ao.__type,true,ao.IconThemed)
av.Size=UDim2.new(0,16,0,16)
av.ImageLabel.ImageTransparency=not ao.Locked and 0 or 0.7
at=-30




end

ao.UIElements.ContainerFrame=ai("ScrollingFrame",{
Size=UDim2.new(1,0,1,ao.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ao.Gap),
HorizontalAlignment="Center",
}),
})





ao.UIElements.ContainerFrameCanvas=ai("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
ao.UIElements.ContainerFrame,
ai("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ao.ShowTabTitle or false,
Name="TabTitle",
},{
av,
ai("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),

RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=ao.TabTitleAlign,
}),
}),
ai("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ao.ShowTabTitle or false,
}),
})
ao.UIElements.ContainerRevealScale=ai("UIScale",{
Scale=1,
Parent=ao.UIElements.ContainerFrameCanvas,
})

al.Containers[ap]=ao.UIElements.ContainerFrameCanvas
al.Tabs[ap]=ao

ao.ContainerFrame=ao.UIElements.ContainerFrameCanvas
if ap==1 then
al:SelectTab(ap)
end

ag.AddSignal(ao.UIElements.Main.MouseButton1Click,function()
if not ao.Locked then
al:SelectTab(ap)
end
end)

if Window.ScrollBarEnabled then
ak(ao.UIElements.ContainerFrame,ao.UIElements.ContainerFrameCanvas,Window,3)
end

local aw
local ax
local ay
local az=false


if ao.Desc then
ag.AddSignal(ao.UIElements.Main.InputBegan,function()
az=true
ax=task.spawn(function()
task.wait(0.35)
if az and not aw then
aw=aj(ao.Desc,al.ToolTipParent,true)
aw.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if aw then
aw.Container.Position=UDim2.new(0,ae.X,0,ae.Y-4)
end
end

updatePosition()
ay=ae.Move:Connect(updatePosition)
aw:Open()
end
end)
end)
end

ag.AddSignal(ao.UIElements.Main.MouseEnter,function()
if not ao.Locked then
ag.SetThemeTag(ao.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)
ag.AddSignal(ao.UIElements.Main.InputEnded,function(aA)
if ao.Desc then
az=false
if ax then
task.cancel(ax)
ax=nil
end
if ay then
ay:Disconnect()
ay=nil
end
if aw then
aw:Close()
aw=nil
end
end

if not ao.Locked then
ag.SetThemeTag(ao.UIElements.Main.Frame,{
ImageTransparency="TabBorderTransparency",
},0.1)
end

if aA.UserInputType==Enum.UserInputType.Touch
or aA.UserInputType==Enum.UserInputType.MouseButton1 then
ag.Tween(aq,0.16,{Scale=1},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
end
end)

function ao.ScrollToTheElement(aA,aB)
ao.UIElements.ContainerFrame.ScrollingEnabled=false

ag.Tween(ao.UIElements.ContainerFrame,0.45,{
CanvasPosition=Vector2.new(
0,
ao.Elements[aB].ElementFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.48)

if ao.Elements[aB].Highlight then
ao.Elements[aB]:Highlight()
end
ao.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return ao
end



local aA=a.load'V'

aA.Load(
ao,
ao.UIElements.ContainerFrame,
aA.Elements,
Window,
WindUI,
nil,
aA,
an,
ao
)

function ao.AddButton(aB,b)
return ao:Button(b)
end

function ao.AddToggle(aB,b)
b=b or{}
if b.Value==nil and b.Default~=nil then
b.Value=b.Default
end
return ao:Toggle(b)
end

function ao.AddSlider(aB,b)
b=b or{}
if b.Value==nil then
b.Value={
Min=b.Min,
Max=b.Max,
Default=b.Default,
}
end
return ao:Slider(b)
end

function ao.LockAll(aB)

for b,d in next,Window.AllElements do
if d.Tab and d.Tab.Index and d.Tab.Index==ao.Index and d.Lock then
d:Lock()
end
end
end
function ao.UnlockAll(aB)
for b,d in next,Window.AllElements do
if d.Tab and d.Tab.Index and d.Tab.Index==ao.Index and d.Unlock then
d:Unlock()
end
end
end
function ao.GetLocked(aB)
local b={}

for d,f in next,Window.AllElements do
if f.Tab and f.Tab.Index and f.Tab.Index==ao.Index and f.Locked==true then
table.insert(b,f)
end
end

return b
end
function ao.GetUnlocked(aB)
local b={}

for d,f in next,Window.AllElements do
if f.Tab and f.Tab.Index and f.Tab.Index==ao.Index and f.Locked==false then
table.insert(b,f)
end
end

return b
end

function ao.Select(aB)
return al:SelectTab(ao.Index)
end

task.spawn(function()
local aB
if ao.CustomEmptyPage.Icon then
aB=
ag.Image(ao.CustomEmptyPage.Icon,ao.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
aB.Size=
UDim2.fromOffset(ao.CustomEmptyPage.IconSize or 48,ao.CustomEmptyPage.IconSize or 48)
end

local b=ai("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ao.UIElements.ContainerFrame,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),











aB,
ao.CustomEmptyPage.Title
and ai("TextLabel",{
AutomaticSize="XY",
Text=ao.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
})
or nil,
ao.CustomEmptyPage.Desc
and ai("TextLabel",{
AutomaticSize="XY",
Text=ao.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(ag.Font,Enum.FontWeight.Regular),
})
or nil,
})





local d
d=ag.AddSignal(ao.UIElements.ContainerFrame.ChildAdded,function()
b.Visible=false
d:Disconnect()
end)
end)

return ao
end

function al.OnChange(am,an)
al.OnChangeFunc=an
end

function al.SelectTab(am,an)
if not al.Tabs[an].Locked then
al.SelectedTab=an

for ao,ap in next,al.Tabs do
if not ap.Locked then
ag.SetThemeTag(ap.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if ap.Border then
ag.SetThemeTag(ap.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
ag.SetThemeTag(ap.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
if ap.UIElements.Icon and not ap.IconColor then
ag.SetThemeTag(ap.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparency",
},0.15)
end

if ap.UIElements.ActiveIndicator then
ag.Tween(ap.UIElements.ActiveIndicator,0.2,{
Size=UDim2.new(0,0,1,-8),
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
ap.Selected=false
end
end
ag.SetThemeTag(al.Tabs[an].UIElements.Main,{
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if al.Tabs[an].Border then
ag.SetThemeTag(al.Tabs[an].UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
ag.SetThemeTag(al.Tabs[an].UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
if al.Tabs[an].UIElements.Icon and not al.Tabs[an].IconColor then
ag.SetThemeTag(al.Tabs[an].UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end

if al.Tabs[an].UIElements.ActiveIndicator then
ag.Tween(al.Tabs[an].UIElements.ActiveIndicator,0.2,{
Size=UDim2.new(0,4,1,-8),
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
al.Tabs[an].Selected=true

task.spawn(function()
for ao,ap in next,al.Containers do
ap.AnchorPoint=Vector2.new(0,0)
ap.Position=UDim2.new(0,0,0,12)
ap.Visible=false
end
local ao=al.Containers[an]
local ap=al.Tabs[an]
ao.Visible=true
ap.UIElements.ContainerRevealScale.Scale=0.985

ag.Tween(ao,0.28,{
Position=UDim2.new(0,0,0,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag.Tween(ap.UIElements.ContainerRevealScale,0.28,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

al.OnChangeFunc(an)
end
end

return al end function a.X()

local aa={}


local ad=a.load'c'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'W'

function aa.New(aj,ak,al,am,an)
local ao={
Title=aj.Title or"Section",
Icon=aj.Icon,
IconThemed=aj.IconThemed,
Opened=aj.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local ap
if ao.Icon then
ap=ad.Image(
ao.Icon,
ao.Icon,
0,
al,
"Section",
true,
ao.IconThemed,
"TabSectionIcon"
)

ap.Size=UDim2.new(0,ao.IconSize,0,ao.IconSize)
ap.ImageLabel.ImageTransparency=.25
end

local aq=ae("Frame",{
Size=UDim2.new(0,ao.IconSize,0,ao.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ad.Icon"chevron-down"[1],
ImageRectSize=ad.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ad.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local ar=ae("Frame",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Parent=ak,
ClipsDescendants=true,
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
ap,
ae("TextLabel",{
Text=ao.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
ap and(-ao.IconSize-10)*2
or(-ao.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ad.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=0,
TextWrapped=true
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
aq,
ae("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ao.HeaderSize)
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ao.Tab(as,at)
if not ao.Expandable then
ao.Expandable=true
aq.Visible=true
end
at.Parent=ar.Content
return ai.New(at,am)
end

function ao.Open(as)
if ao.Expandable then
ao.Opened=true
ag(ar,0.33,{
Size=UDim2.new(1,0,0,ao.HeaderSize+(ar.Content.AbsoluteSize.Y/am))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ag(aq.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ao.Close(as)
if ao.Expandable then
ao.Opened=false
ag(ar,0.26,{
Size=UDim2.new(1,0,0,ao.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag(aq.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ad.AddSignal(ar.TextButton.MouseButton1Click,function()
if ao.Expandable then
if ao.Opened then
ao:Close()
else
ao:Open()
end
end
end)

ad.AddSignal(ar.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ao.Opened then
ao:Open()
end
end)

if ao.Opened then
task.spawn(function()
task.wait()
ao:Open()
end)
end



return ao
end


return aa end function a.Y()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.Z()
local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")

local ad={
Margin=8,
Padding=9,
}

local ae=a.load'c'
local ag=ae.New
local ai=ae.Tween

function ad.new(aj,ak,al)
local am={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'Y',
}

local an=ag("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(1,-((am.IconSize*2)+(am.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ao=ag("ImageLabel",{
Image=ae.Icon"x"[1],
ImageRectSize=ae.Icon"x"[2].ImageRectSize,
ImageRectOffset=ae.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
},{
ag("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})

local ap=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding),
}),
})

local aq=ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("ImageLabel",{
Image=ae.Icon"search"[1],
ImageRectSize=ae.Icon"search"[2].ImageRectSize,
ImageRectOffset=ae.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
}),
an,
ao,
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
}),
}),
}),
ag("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
ap,
ag("UISizeConstraint",{
MaxSize=Vector2.new(am.Width,am.MaxHeight),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
})

local ar=ag("Frame",{
Size=UDim2.new(0,am.Width,0,0),
AutomaticSize="Y",
Parent=ak,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ag("UIScale",{
Scale=0.9,
}),
aq,
ae.NewRoundFrame(am.Radius,"Glass-0.7",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,


ThemeTag={
ImageColor3="SearchBarBorder",
ImageTransparency="SearchBarBorderTransparency",
},
Name="Outline",
}),
})

local function CreateSearchTab(as,at,au,av,aw,ax)
local ay=ag("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av or nil,
},{
ae.NewRoundFrame(am.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
ae.NewRoundFrame(am.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding-2),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding-2),
}),
ag("ImageLabel",{
Image=ae.Icon(au)[1],
ImageRectSize=ae.Icon(au)[2].ImageRectSize,
ImageRectOffset=ae.Icon(au)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
}),
ag("Frame",{
Size=UDim2.new(1,-am.IconSize-am.Padding,0,0),
BackgroundTransparency=1,
},{
ag("TextLabel",{
Text=as,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
ag("TextLabel",{
Text=at or"",
Visible=at and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
}),
}),
},true),
ag("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-am.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aw,

},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
ag("Frame",{
Size=UDim2.new(1,-am.Padding-2,0,0),
Position=UDim2.new(0,am.Padding+2,0,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



ay.Main.Size=UDim2.new(
1,
0,
0,
ay.Main.Outline.Frame.Desc.Visible
and(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y+6+ay.Main.Outline.Frame.Desc.TextBounds.Y)
or(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y)
)

ae.AddSignal(ay.Main.MouseEnter,function()
ai(ay.Main,0.04,{ImageTransparency=0.95}):Play()
ai(ay.Main.Outline,0.04,{ImageTransparency=0.75}):Play()
end)
ae.AddSignal(ay.Main.InputEnded,function()
ai(ay.Main,0.08,{ImageTransparency=1}):Play()
ai(ay.Main.Outline,0.08,{ImageTransparency=1}):Play()
end)
ae.AddSignal(ay.Main.MouseButton1Click,function()
if ax then
ax()
end
end)

return ay
end

local function ContainsText(as,at)
if not at or at==""then
return false
end

if not as or as==""then
return false
end

local au=string.lower(as)
local av=string.lower(at)

return string.find(au,av,1,true)~=nil
end

local function Search(as)
if not as or as==""then
return{}
end

local at={}
for au,av in next,aj.Tabs do
local aw=ContainsText(av.Title or"",as)
local ax={}

for ay,az in next,av.Elements do
if az.__type~="Section"then
local aA=ContainsText(az.Title or"",as)
local aB=ContainsText(az.Desc or"",as)

if aA or aB then
ax[ay]={
Title=az.Title,
Desc=az.Desc,
Original=az,
__type=az.__type,
Index=ay,
}
end
end
end

if aw or next(ax)~=nil then
at[au]={
Tab=av,
Title=av.Title,
Icon=av.Icon,
Elements=ax,
}
end
end
return at
end

ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ai(ap,0.06,{
Size=UDim2.new(
1,
0,
0,
math.clamp(
ap.UIListLayout.AbsoluteContentSize.Y+(am.Padding*2),
0,
am.MaxHeight
)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function am.Open(as)
task.spawn(function()
aq.Frame.Visible=true
ar.Visible=true
ai(ar.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Close(as,at)
task.spawn(function()
al()
aq.Frame.Visible=false
ai(ar.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.12)
ar.Visible=false
if at then
ar:Destroy()
end
end)
end

ae.AddSignal(ao.TextButton.MouseButton1Click,function()
am:Close(true)
end)

am:Open()

function am.Search(as,at)
at=at or""

local au=Search(at)

ap.Visible=true
aq.Frame.Results.Frame.Visible=true
for av,aw in next,ap:GetChildren()do
if aw.ClassName~="UIListLayout"and aw.ClassName~="UIPadding"then
aw:Destroy()
end
end

if au and next(au)~=nil then
for av,aw in next,au do
local ax=am.Icons.Tab
local ay=CreateSearchTab(aw.Title,nil,ax,ap,true,function()
am:Close()
aj:SelectTab(av)
end)
if aw.Elements and next(aw.Elements)~=nil then
for az,aA in next,aw.Elements do
local aB=am.Icons[aA.__type]
CreateSearchTab(
aA.Title,
aA.Desc,
aB,
ay:FindFirstChild"ParentContainer"and ay.ParentContainer.Frame
or nil,
false,
function()
am:Close()
aj:SelectTab(av)
if aw.Tab.ScrollToTheElement then

aw.Tab:ScrollToTheElement(aA.Index)
end

end
)

end
end
end
elseif at~=""then
ag("TextLabel",{
Size=UDim2.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Parent=ap,
Name="NotFound",
})
else
ap.Visible=false
aq.Frame.Results.Frame.Visible=false
end
end

ae.AddSignal(an:GetPropertyChangedSignal"Text",function()
am:Search(an.Text)
end)

return am
end

return ad end function a._()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=aa(game:GetService"UserInputService")
local ae=aa(game:GetService"RunService")
local ag=aa(game:GetService"Players")

local ai=workspace.CurrentCamera

local aj=a.load's'

local ak=a.load'c'
local al=ak.New
local am=ak.Tween


local an=a.load'v'.New
local ao=a.load'l'.New
local ap=a.load'w'.New
local aq=a.load'x'

local ar=a.load'y'



return function(as)
local at={
Title=as.Title or"UI Library",
Author=as.Author,
Icon=as.Icon,
IconSize=as.IconSize or 22,
IconThemed=as.IconThemed,
IconRadius=as.IconRadius or 0,
Folder=as.Folder or(as.DataSystem and as.DataSystem.DataSave and(as.Title or"UI Library")),
Resizable=as.Resizable~=false,
Background=as.Background,
BackgroundImageTransparency=as.BackgroundImageTransparency or 0,
ShadowTransparency=as.ShadowTransparency or 0.6,
User=as.User or{},
Footer=as.Footer or{},
Topbar=as.Topbar or{Height=52,ButtonsType="Default"},

Size=as.Size,

MinSize=as.MinSize or Vector2.new(560,350),
MaxSize=as.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=as.TopBarButtonIconSize,

ToggleKey=as.ToggleKey,
ElementsRadius=as.ElementsRadius,
Radius=as.Radius or 16,
Transparent=as.Transparent or false,
HideSearchBar=as.HideSearchBar~=false,
ScrollBarEnabled=as.ScrollBarEnabled or false,
SideBarWidth=as.SideBarWidth or 200,
Acrylic=as.Acrylic or false,
NewElements=as.NewElements or false,
IgnoreAlerts=as.IgnoreAlerts or false,
HidePanelBackground=as.HidePanelBackground or false,
AutoScale=as.AutoScale~=false,
OpenButton=as.OpenButton,
DataSave=as.DataSystem and as.DataSystem.DataSave==true,
DragFrameSize=160,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=16,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=as.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=as.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},
DataKeyCounts={},
DataDirty=false,
DataSaveTask=nil,
DataLoading=false,

IsToggleDragging=false,
}

at.UICorner=at.Radius

at.TopBarButtonIconSize=at.TopBarButtonIconSize or(at.Topbar.ButtonsType=="Mac"and 11 or 16)

at.ElementConfig={
UIPadding=(at.NewElements and 10 or 13),
UICorner=at.ElementsRadius or(at.NewElements and 23 or 12),
}

local au=at.Size or UDim2.new(0,580,0,460)
at.Size=UDim2.new(
au.X.Scale,
math.clamp(au.X.Offset,at.MinSize.X,at.MaxSize.X),
au.Y.Scale,
math.clamp(au.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

if at.Topbar=={}then
at.Topbar={Height=52,ButtonsType="Default"}
end

if not ae:IsStudio()and at.Folder and writefile then
if not isfolder("WindUI/"..at.Folder)then
makefolder("WindUI/"..at.Folder)
end
if not isfolder("WindUI/"..at.Folder.."/assets")then
makefolder("WindUI/"..at.Folder.."/assets")
end
end

local av=al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
})

if at.Folder then
at.ConfigManager=ar:Init(at)
if at.DataSave and at.ConfigManager then
local aw=ag.LocalPlayer and ag.LocalPlayer.UserId or 0
at.DataConfig=at.ConfigManager:CreateConfig("__autosave_"..tostring(aw),false)
at.DataConfig:Load()

local ax=at.DataConfig:Get"windowPosition"
if ax then
at.Position=UDim2.new(
ax.xScale or 0.5,
ax.xOffset or 0,
ax.yScale or 0.5,
ax.yOffset or 0
)
end
end
end

if at.Acrylic then local
aw=aj.AcrylicPaint{UseAcrylic=at.Acrylic}

at.AcrylicPaint=aw
end

local aw=al("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
al("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})
local ax=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
al("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ak.Icon"expand"[1],
ImageRectOffset=ak.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ak.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local ay=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})









at.UIElements.SideBar=al("ScrollingFrame",{
Size=UDim2.new(
1,
at.ScrollBarEnabled and-3-(at.UIPadding/2)or 0,
1,
not at.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
al("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
al("UIPadding",{



PaddingBottom=UDim.new(0,at.UIPadding/2),
}),
al("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,at.Gap),
}),
}),
al("UIPadding",{

PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),

}),

})

at.UIElements.SideBarContainer=al("Frame",{
Size=UDim2.new(
0,
at.SideBarWidth,
1,
at.User.Enabled and-at.Topbar.Height-42-(at.UIPadding*2)or-at.Topbar.Height
),
Position=UDim2.new(0,0,0,at.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
al("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,not at.HideSearchBar and-45-at.UIPadding/2 or 0),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
at.UIElements.SideBar,
})

if at.ScrollBarEnabled then
ap(at.UIElements.SideBar,at.UIElements.SideBarContainer.Content,at,3)
end

at.UIElements.MainBar=al("Frame",{
Size=UDim2.new(1,-at.UIElements.SideBarContainer.AbsoluteSize.X,1,-at.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},


ZIndex=3,
Name="Background",
Visible=not at.HidePanelBackground,
}),
al("UIPadding",{

PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
PaddingBottom=UDim.new(0,at.UIPadding/2),
}),
})

local az=al("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

if ad.TouchEnabled and not ad.KeyboardEnabled then
at.IsPC=false
elseif ad.KeyboardEnabled then
at.IsPC=true
else
at.IsPC=nil
end







local aA
if at.User then
local function GetUserThumb()local
aB=ag:GetUserThumbnailAsync(
at.User.Anonymous and 1 or ag.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return aB
end

aA=al("TextButton",{
Size=UDim2.new(
0,
at.UIElements.SideBarContainer.AbsoluteSize.X-(at.UIPadding/2),
0,
42+at.UIPadding
),
Position=UDim2.new(0,at.UIPadding/2,1,-(at.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=at.User.Enabled or false,
},{
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline",
},{
al("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
al("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=0.93,
},{
al("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
al("TextLabel",{
Text=at.User.Anonymous and"Anonymous"or ag.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName",
}),
al("TextLabel",{
Text=at.User.Anonymous and"anonymous"or ag.LocalPlayer.Name,
TextSize=15,
TextTransparency=0.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName",
}),
al("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
}),
}),
al("UIListLayout",{
Padding=UDim.new(0,at.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
}),
}),
})

function at.User.Enable(aB)
at.User.Enabled=true
am(
at.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,at.SideBarWidth,1,-at.Topbar.Height-42-(at.UIPadding*2))},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aA.Visible=true
end
function at.User.Disable(aB)
at.User.Enabled=false
am(
at.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,at.SideBarWidth,1,-at.Topbar.Height)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aA.Visible=false
end
function at.User.SetAnonymous(aB,b)
if b~=false then
b=true
end
at.User.Anonymous=b
aA.UserIcon.ImageLabel.Image=GetUserThumb()
aA.UserIcon.Frame.DisplayName.Text=b and"Anonymous"or ag.LocalPlayer.DisplayName
aA.UserIcon.Frame.UserName.Text=b and"anonymous"or ag.LocalPlayer.Name
end

if at.User.Enabled then
at.User:Enable()
else
at.User:Disable()
end

if at.User.Callback then
ak.AddSignal(aA.MouseButton1Click,function()
at.User.Callback()
end)
ak.AddSignal(aA.MouseEnter,function()
am(aA.UserIcon,0.04,{ImageTransparency=0.95}):Play()
am(aA.Outline,0.04,{ImageTransparency=0.85}):Play()
end)
ak.AddSignal(aA.InputEnded,function()
am(aA.UserIcon,0.04,{ImageTransparency=1}):Play()
am(aA.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local aB
local b

local d=false
local f

local g=typeof(at.Background)=="string"and string.match(at.Background,"^video:(.+)")or nil
local h=typeof(at.Background)=="string"
and not g
and string.match(at.Background,"^(https?://.+|rbx%w+://.+)")
or nil

local function GetImageExtension(i)
local l=i:match"%.(%w+)$"or i:match"%.(%w+)%?"
if l then
l=l:lower()
if l=="jpg"or l=="jpeg"or l=="png"or l=="webp"then
return"."..l
end
end
return".png"
end

if typeof(at.Background)=="string"and g then
d=true

if string.find(g,"http")then
local i="WindUI/"..at.Folder.."/assets/."..ak.SanitizeFilename(g)..".webm"
if not isfile(i)then
local l,m=pcall(function()





local l=game.HttpGet and game:HttpGet(g)
writefile(i,l.Body)
end)
if not l then
warn("[ WindUI.Window.Background ] Failed to download video: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(i)
end)
if not l then
warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(m))
return
end
warn"[ WindUI.Window.Background ] VideoFrame may not work with custom video"
g=m
end

f=al("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=g,
Looped=true,
Volume=0,
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
f:Play()
elseif h then
local i=at.Folder
.."/assets/."
..ak.SanitizeFilename(h)
..GetImageExtension(h)
if isfile and not isfile(i)then
local l,m=pcall(function()





local l=game.HttpGet and game:HttpGet(h)
writefile(i,l.Body)
end)
if not l then
warn("[ Window.Background ] Failed to download image: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(i)
end)
if not l then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(m))
return
end

f=al("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=m or h,
ImageTransparency=0,
ScaleType="Crop",
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
elseif at.Background then
f=al("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(at.Background)=="string"and at.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
end

local i=ak.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
al("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

function createAuthor(l)
return al("TextLabel",{
Text=l,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=at.UIElements.Main and at.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local l
local m

if at.Author then
l=createAuthor(at.Author)
end

local p=al("TextLabel",{
Text=at.Title,
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
})

at.UIElements.Main=al("Frame",{
Size=at.Size,
Position=at.Position,
BackgroundTransparency=1,
Parent=as.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
as.WindUI.UIScaleObj,
at.AcrylicPaint and at.AcrylicPaint.Frame or nil,
az,
ak.NewRoundFrame(at.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
},

},{
f,
i,
aw,



}),

av,
ax,
ay,
al("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
at.UIElements.SideBarContainer,
at.UIElements.MainBar,

aA,

b,
al("Frame",{
Size=UDim2.new(1,0,0,at.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar",
},{
aB,






al("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
al("UIListLayout",{
Padding=UDim.new(0,at.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
al("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
p,
l,
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,4),
}),
}),
al("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
Visible=false,
},{
al("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,at.UIPadding/2),
}),
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(at.Topbar.ButtonsType=="Default"and 1 or 0,0,0.5,0),
AnchorPoint=Vector2.new(at.Topbar.ButtonsType=="Default"and 1 or 0,0.5),
Name="Right",
},{
al("UIListLayout",{
Padding=UDim.new(0,at.Topbar.ButtonsType=="Default"and 9 or 0),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),
}),
al("UIPadding",{
PaddingTop=UDim.new(0,at.UIPadding),
PaddingLeft=UDim.new(
0,
at.Topbar.ButtonsType=="Default"and at.UIPadding or at.UIPadding-2
),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,at.UIPadding),
}),
}),
}),
})

ak.AddSignal(at.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local r=0
local u=at.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
/as.WindUI.UIScale





r=at.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X/as.WindUI.UIScale
if at.Topbar.ButtonsType~="Default"then
r=r+u+at.UIPadding-4
end



at.UIElements.Main.Main.Topbar.Center.Position=
UDim2.new(0,r+(at.UIPadding/as.WindUI.UIScale),0.5,0)
at.UIElements.Main.Main.Topbar.Center.Size=
UDim2.new(1,-r-u-((at.UIPadding*2)/as.WindUI.UIScale),1,0)
end)

if at.Topbar.ButtonsType~="Default"then
ak.AddSignal(at.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal"AbsoluteSize",function()
at.UIElements.Main.Main.Topbar.Left.Position=UDim2.new(
0,
(at.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X/as.WindUI.UIScale)+at.UIPadding-4,
0,
0
)
end)
end

function at.CreateTopbarButton(r,u,v,x,z,A,B,C)
local F=ak.Image(
v,
v,
0,
at.Folder,
"WindowTopbarIcon",
at.Topbar.ButtonsType=="Default"and true or false,
A,
"WindowTopbarButtonIcon"
)
F.Size=at.Topbar.ButtonsType=="Default"
and UDim2.new(0,C or at.TopBarButtonIconSize,0,C or at.TopBarButtonIconSize)
or UDim2.new(0,0,0,0)
F.AnchorPoint=Vector2.new(0.5,0.5)
F.Position=UDim2.new(0.5,0,0.5,0)
F.ImageLabel.ImageTransparency=at.Topbar.ButtonsType=="Default"and 0 or 1

if at.Topbar.ButtonsType~="Default"then
F.ImageLabel.ImageColor3=ak.GetTextColorForHSB(B)
end

local G=ak.NewRoundFrame(
at.Topbar.ButtonsType=="Default"and at.UICorner-(at.UIPadding/2)or 999,
"Squircle",
{
Size=at.Topbar.ButtonsType=="Default"
and UDim2.new(0,at.Topbar.Height-16,0,at.Topbar.Height-16)
or UDim2.new(0,14,0,14),
LayoutOrder=z or 999,


ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=at.Topbar.ButtonsType~="Default"and(B or Color3.fromHex"#ff3030")or nil,
ThemeTag=at.Topbar.ButtonsType=="Default"and{
ImageColor3="Text",
}or nil,
ImageTransparency=at.Topbar.ButtonsType=="Default"and 1 or 0,
},
{
ak.NewRoundFrame(
at.Topbar.ButtonsType=="Default"and at.UICorner-(at.UIPadding/2)or 999,
"Glass-1",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=at.Topbar.ButtonsType=="Default"and 1 or 0.5,
Name="Outline",
}
),
F,
al("UIScale",{
Scale=1,
}),
},
true
)

al("Frame",{
Size=at.Topbar.ButtonsType~="Default"and UDim2.new(0,24,0,24)
or UDim2.new(0,at.Topbar.Height-16,0,at.Topbar.Height-16),
BackgroundTransparency=1,
Parent=at.UIElements.Main.Main.Topbar.Right,
LayoutOrder=z or 999,
},{
G,
})



at.TopBarButtons[100-z]={
Name=u,
Object=G,
}

ak.AddSignal(G.MouseButton1Click,function()
if x then
x()
end
end)
ak.AddSignal(G.MouseEnter,function()
if at.Topbar.ButtonsType=="Default"then
am(G,0.15,{ImageTransparency=0.93}):Play()
am(G.Outline,0.15,{ImageTransparency=0.75}):Play()

else

am(
F.ImageLabel,
0.1,
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
am(F,0.1,{
Size=UDim2.new(
0,
C or at.TopBarButtonIconSize,
0,
C or at.TopBarButtonIconSize
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)

ak.AddSignal(G.MouseButton1Down,function()
am(G.UIScale,0.2,{Scale=0.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

ak.AddSignal(G.MouseLeave,function()
if at.Topbar.ButtonsType=="Default"then
am(G,0.1,{ImageTransparency=1}):Play()
am(G.Outline,0.1,{ImageTransparency=1}):Play()

else

am(
F.ImageLabel,
0.1,
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
am(
F,
0.1,
{Size=UDim2.new(0,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

ak.AddSignal(G.InputEnded,function()
am(G.UIScale,0.2,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end)

return G
end

function at.Topbar.Button(r,u:{
Name:string,
Icon:string,
Callback:any,
LayoutOrder:number,
IconThemed:boolean,
Color:Color3,
IconSize:number,
})
return at:CreateTopbarButton(
u.Name,
u.Icon,
u.Callback,
u.LayoutOrder or 0,
u.IconThemed,
u.Color,
u.IconSize
)
end



local r=ak.Drag(
at.UIElements.Main,
{at.UIElements.Main.Main.Topbar,i.Frame},
function(r,u)
if not at.Closed then
if r and u==i.Frame then
am(i,0.1,{ImageTransparency=0.35}):Play()
else
am(i,0.2,{ImageTransparency=0.8}):Play()
end
at.Position=at.UIElements.Main.Position
at.Dragging=r
if at.ConfigManager then
at.ConfigManager:MarkDirty()
end
end
end
)

if not d and at.Background and typeof(at.Background)=="table"then
local u=al"UIGradient"
for v,x in next,at.Background do
u[v]=x
end

at.UIElements.BackgroundGradient=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=at.UIElements.Main.Background,
ImageTransparency=at.Transparent and as.WindUI.TransparencyValue or 0,
},{
u,
})
end














at.OpenButtonMain=a.load'z'.New(at)

task.spawn(function()
if at.Icon then
local u=al("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=at.UIElements.Main.Main.Topbar.Left,
})

m=ak.Image(
at.Icon,
at.Title,
at.IconRadius,
at.Folder,
"Window",
true,
at.IconThemed,
"WindowTopbarIcon"
)
m.Parent=u
m.Size=UDim2.new(0,at.IconSize,0,at.IconSize)
m.Position=UDim2.new(0.5,0,0.5,0)
m.AnchorPoint=Vector2.new(0.5,0.5)

at.OpenButtonMain:SetIcon(at.Icon)











else
at.OpenButtonMain:SetIcon(at.Icon)

end
end)

function at.SetToggleKey(u,v)
at.ToggleKey=v
end

function at.SetTitle(u,v)
at.Title=v
p.Text=v
end

function at.SetAuthor(u,v)
at.Author=v
if not l then
l=createAuthor(at.Author)
end

l.Text=v
end

function at.SetSize(u,v)
if typeof(v)=="UDim2"then
at.Size=v

am(at.UIElements.Main,0.08,{Size=v},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

function at.SetBackgroundImage(u,v)
at.UIElements.Main.Background.ImageLabel.Image=v
end
function at.SetBackgroundImageTransparency(u,v)
if f and f:IsA"ImageLabel"then
f.ImageTransparency=math.floor(v*10+0.5)/10
end
at.BackgroundImageTransparency=math.floor(v*10+0.5)/10
end

function at.SetBackgroundTransparency(u,v)
local x=math.floor(tonumber(v)*10+0.5)/10
as.WindUI.TransparencyValue=x
at:ToggleTransparency(x>0)
end

local u
local v
ak.Icon"minimize"
ak.Icon"maximize"

at:CreateTopbarButton(
"Fullscreen",
at.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
at:ToggleFullscreen()
end,
(at.Topbar.ButtonsType=="Default"and 998 or 999),
true,
Color3.fromHex"#60C762",
at.Topbar.ButtonsType=="Mac"and 9 or nil
)

function at.ToggleFullscreen(x)
local z=at.IsFullscreen

r:Set(z)

if not z then
u=at.UIElements.Main.Position
v=at.UIElements.Main.Size

at.CanResize=false
else
if at.Resizable then
at.CanResize=true
end
end

am(
at.UIElements.Main,
0.45,
{Size=z and v or UDim2.new(1,-20,1,-72)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

am(
at.UIElements.Main,
0.45,
{Position=z and u or UDim2.new(0.5,0,0.5,26)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()



at.IsFullscreen=not z
end

at:CreateTopbarButton("Minimize","minus",function()
at:Close()






















end,(at.Topbar.ButtonsType=="Default"and 997 or 998),nil,Color3.fromHex"#F4C948")

function at.OnOpen(x,z)
at.OnOpenCallback=z
end
function at.OnClose(x,z)
at.OnCloseCallback=z
end
function at.OnDestroy(x,z)
at.OnDestroyCallback=z
end

if as.WindUI.UseAcrylic then
at.AcrylicPaint.AddParent(at.UIElements.Main)
end

function at.SetIconSize(x,z)
local A
if typeof(z)=="number"then
A=UDim2.new(0,z,0,z)
at.IconSize=z
elseif typeof(z)=="UDim2"then
A=z
at.IconSize=z.X.Offset
end

if m then
m.Size=A
end
end

function at.Open(x)
task.spawn(function()
if not at.UIElements.RevealScale then
at.UIElements.RevealScale=al("UIScale",{
Scale=0.96,
Parent=at.UIElements.Main,
})
end
am(at.UIElements.RevealScale,0.45,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if at.OnOpenCallback then
task.spawn(function()
ak.SafeCallback(at.OnOpenCallback)
end)
end

task.wait(0.06)
at.Closed=false

am(at.UIElements.Main.Background,0.2,{
ImageTransparency=at.Transparent and as.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if at.UIElements.BackgroundGradient then
am(at.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

am(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if f then
if f:IsA"VideoFrame"then
f.Visible=true
else
am(f,0.2,{
ImageTransparency=at.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if at.OpenButtonMain and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(false)
end


am(
az,
0.25,
{ImageTransparency=at.ShadowTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

task.spawn(function()
task.wait(0.3)
am(
i,
0.45,
{Size=UDim2.new(0,at.DragFrameSize,0,4),ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
r:Set(true)
task.wait(0.45)
if at.Resizable then
am(
aw.ImageLabel,
0.45,
{ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
at.CanResize=true
end
end)

at.CanDropdown=true
at.UIElements.Main.Visible=true
task.spawn(function()
task.wait(0.05)
at.UIElements.Main:WaitForChild"Main".Visible=true

as.WindUI:ToggleAcrylic(true)
end)
end)
end
function at.Close(x)
local z={}
at:SaveData()

if at.OnCloseCallback then
task.spawn(function()
ak.SafeCallback(at.OnCloseCallback)
end)
end

as.WindUI:ToggleAcrylic(false)

if at.UIElements.Main and at.UIElements.Main:WaitForChild"Main"then
at.UIElements.Main.Main.Visible=false
end

at.CanDropdown=false
at.Closed=true

if at.UIElements.RevealScale then
am(at.UIElements.RevealScale,0.32,{
Scale=0.96,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

if at.OpenButtonMain and not at.IsPC and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(true)
end

am(at.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if at.UIElements.BackgroundGradient then
am(at.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

am(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if f then
if f:IsA"VideoFrame"then
f.Visible=false
else
am(f,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
am(az,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

am(
i,
0.3,
{Size=UDim2.new(0,0,0,4),ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.InOut
):Play()
am(
aw.ImageLabel,
0.3,
{ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
r:Set(false)
at.CanResize=false

task.spawn(function()
task.wait(0.4)
at.UIElements.Main.Visible=false

if at.OpenButtonMain and not at.Destroyed and not at.IsPC and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(true)
end
end)

function z.Destroy(A)
task.spawn(function()
if at.OnDestroyCallback then
task.spawn(function()
ak.SafeCallback(at.OnDestroyCallback)
end)
end
if at.AcrylicPaint and at.AcrylicPaint.Model then
at.AcrylicPaint.Model:Destroy()
end
at.Destroyed=true
task.wait(0.4)
as.WindUI.ScreenGui:Destroy()
as.WindUI.NotificationGui:Destroy()
as.WindUI.DropdownGui:Destroy()
as.WindUI.TooltipGui:Destroy()

ak.DisconnectAll()

return
end)
end

return z
end
function at.Destroy(x)
return at:Close():Destroy()
end
function at.Toggle(x)
if at.Closed then
at:Open()
else
at:Close()
end
end

function at.ToggleTransparency(x,z)

at.Transparent=z
as.WindUI.Transparent=z

at.UIElements.Main.Background.ImageTransparency=z and as.WindUI.TransparencyValue or 0


end

function at.LockAll(x)
for z,A in next,at.AllElements do
if A.Lock then
A:Lock()
end
end
end
function at.UnlockAll(x)
for z,A in next,at.AllElements do
if A.Unlock then
A:Unlock()
end
end
end
function at.GetLocked(x)
local z={}

for A,B in next,at.AllElements do
if B.Locked then
table.insert(z,B)
end
end

return z
end
function at.GetUnlocked(x)
local z={}

for A,B in next,at.AllElements do
if B.Locked==false then
table.insert(z,B)
end
end

return z
end

function at.GetUIScale(x,z)
return as.WindUI.UIScale
end

function at.SetUIScale(x,z)
as.WindUI.UIScale=z
am(as.WindUI.UIScaleObj,0.2,{Scale=z},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return at
end

function at.SetToTheCenter(x)
am(
at.UIElements.Main,
0.45,
{Position=UDim2.new(0.5,0,0.5,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
return at
end

function at.SetCurrentConfig(x,z)
at.CurrentConfig=z
end

function at.SaveData(x)
if not at.DataSave or not at.DataConfig then
return false
end
at.DataSaveTask=nil

local z=at.UIElements.Main and at.UIElements.Main.Position or at.Position
at.DataConfig:Set("windowPosition",{
xScale=z.X.Scale,
xOffset=z.X.Offset,
yScale=z.Y.Scale,
yOffset=z.Y.Offset,
})
local A=at.DataConfig:Save()
at.DataDirty=false
return A
end

do
local x=40
local z=ai.ViewportSize
local A=at.UIElements.Main.AbsoluteSize

if not at.IsFullscreen and at.AutoScale then
local B=z.X-(x*2)
local C=z.Y-(x*2)

local F=B/A.X
local G=C/A.Y

local H=math.min(F,G)

local J=0.3
local L=1.0

local M=math.clamp(H,J,L)

local N=at:GetUIScale()or 1
local O=0.05

if math.abs(M-N)>O then
at:SetUIScale(M)
end
end
end

if at.OpenButtonMain and at.OpenButtonMain.Button then
ak.AddSignal(at.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


at:Open()
end)
end

ak.AddSignal(ad.InputBegan,function(x,z)
if z then
return
end

if at.ToggleKey then
if x.KeyCode==at.ToggleKey then
at:Toggle()
end
end
end)

task.spawn(function()

if as.OpenOnCreate~=false then
at:Open()
end
end)

function at.EditOpenButton(x,z)
return at.OpenButtonMain:Edit(z)
end

if at.OpenButton and typeof(at.OpenButton)=="table"then
at:EditOpenButton(at.OpenButton)
end

local x=a.load'W'
local z=a.load'X'
local A=x.Init(at,as.WindUI,as.WindUI.TooltipGui)
A:OnChange(function(B)
at.CurrentTab=B
end)

at.TabModule=A

function at.Tab(B,C)
if typeof(C)=="string"then
C={Title=C}
end
C.Parent=at.UIElements.SideBar.Frame
return A.New(C,as.WindUI.UIScale)
end

function at.AddTab(B,C)
return at:Tab(C)
end

function at.SelectTab(B,C)
A:SelectTab(C)
end

function at.Section(B,C)
return z.New(
C,
at.UIElements.SideBar.Frame,
at.Folder,
as.WindUI.UIScale,
at
)
end

function at.IsResizable(B,C)
at.Resizable=C
at.CanResize=C
end

function at.SetPanelBackground(B,C)
if typeof(C)=="boolean"then
at.HidePanelBackground=C

at.UIElements.MainBar.Background.Visible=C

if A then
for F,G in next,A.Containers do
G.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,at.HidePanelBackground and 20 or 10)
G.ScrollingFrame.UIPadding.PaddingLeft=
UDim.new(0,at.HidePanelBackground and 20 or 10)
G.ScrollingFrame.UIPadding.PaddingRight=
UDim.new(0,at.HidePanelBackground and 20 or 10)
G.ScrollingFrame.UIPadding.PaddingBottom=
UDim.new(0,at.HidePanelBackground and 20 or 10)
end
end
end
end

function at.Divider(B)
local C=al("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})
local F=al("Frame",{
Parent=at.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
C,
})

return F
end

local B=a.load'n'
function at.Dialog(C,F)
local G={
Title=F.Title or"Dialog",
Width=F.Width or 320,
Content=F.Content,
Buttons=F.Buttons or{},

TextPadding=14,
}
local H=B.Create(false,"Dialog",at,as.WindUI,at.UIElements.Main.Main)

H.UIElements.Main.Size=UDim2.new(0,G.Width,0,0)

local J=al("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=H.UIElements.Main,
},{
al("UIListLayout",{
FillDirection="Vertical",

Padding=UDim.new(0,H.UIPadding),
}),
})

local L=al("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=J,
},{
al("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,H.UIPadding),
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingTop=UDim.new(0,G.TextPadding/2),
PaddingLeft=UDim.new(0,G.TextPadding/2),
PaddingRight=UDim.new(0,G.TextPadding/2),
}),
})

local M
if F.Icon then
M=ak.Image(
F.Icon,
G.Title..":"..F.Icon,
0,
at,
"Dialog",
true,
F.IconThemed
)
M.Size=UDim2.new(0,22,0,22)
M.Parent=L
end

H.UIElements.UIListLayout=al("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=H.UIElements.Main,
})

al("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=H.UIElements.Main,
})

H.UIElements.Title=al("TextLabel",{
Text=G.Title,
TextSize=20,
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,M and-26-H.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=L,
})
if G.Content then
al("TextLabel",{
Text=G.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=J,
},{
al("UIPadding",{
PaddingLeft=UDim.new(0,G.TextPadding/2),
PaddingRight=UDim.new(0,G.TextPadding/2),
PaddingBottom=UDim.new(0,G.TextPadding/2),
}),
})
end

local N=al("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
HorizontalFlex="Fill",
})

local O=al("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=H.UIElements.Main,
LayoutOrder=4,
},{
N,






})



for P,Q in next,G.Buttons do

ao(Q.Title,Q.Icon,Q.Callback,Q.Variant,O,H,true,nil,Q.Color)
end





















































H:Open()

return H
end

local C=false

at:CreateTopbarButton("Close","x",function()
if not C then
if not at.IgnoreAlerts then
C=true

at:Dialog{
Title="Close | Peakx Hub",
Content="Are you sure you want to close the Hub interface?",
Buttons={
{
Title="Cancel",
Callback=function()
C=false
end,
Variant="Secondary",
},

{
Title="Yes, Close",
Callback=function()
C=false
at:Destroy()
end,
Variant="Primary",
Color=Color3.fromHex"#b33b3b",
},
},
}
else
at:Destroy()
end
end
end,(at.Topbar.ButtonsType=="Default"and 999 or 997),nil,Color3.fromHex"#F4695F")

function at.Tag(F,G)
if at.UIElements.Main.Main.Topbar.Center.Visible==false then
at.UIElements.Main.Main.Topbar.Center.Visible=true
end
G.Window=at
return aq:New(G,at.UIElements.Main.Main.Topbar.Center)
end

local function startResizing(F)
if at.CanResize then
isResizing=true
ax.Active=true
initialSize=at.UIElements.Main.Size
initialInputPosition=F.Position


am(aw.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

ak.AddSignal(F.Changed,function()
if F.UserInputState==Enum.UserInputState.End then
isResizing=false
ax.Active=false


am(aw.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

ak.AddSignal(aw.InputBegan,function(F)
if
F.UserInputType==Enum.UserInputType.MouseButton1
or F.UserInputType==Enum.UserInputType.Touch
then
if at.CanResize then
startResizing(F)
end
end
end)

ak.AddSignal(ad.InputChanged,function(F)
if
F.UserInputType==Enum.UserInputType.MouseMovement
or F.UserInputType==Enum.UserInputType.Touch
then
if isResizing and at.CanResize then
local G=F.Position-initialInputPosition
local H=UDim2.new(0,initialSize.X.Offset+G.X*2,0,initialSize.Y.Offset+G.Y*2)

H=UDim2.new(
H.X.Scale,
math.clamp(H.X.Offset,at.MinSize.X,at.MaxSize.X),
H.Y.Scale,
math.clamp(H.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

am(at.UIElements.Main,0.08,{
Size=H,
},Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()

at.Size=H
end
end
end)

ak.AddSignal(aw.MouseEnter,function()
if not isResizing then
am(aw.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)
ak.AddSignal(aw.MouseLeave,function()
if not isResizing then
am(aw.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)



local F=0
local G=0.4
local H
local J=0

function onDoubleClick()
at:SetToTheCenter()
end

ak.AddSignal(i.Frame.MouseButton1Up,function()
local L=tick()
local M=at.Position

J=J+1

if J==1 then
F=L
H=M

task.spawn(function()
task.wait(G)
if J==1 then
J=0
H=nil
end
end)
elseif J==2 then
if L-F<=G and M==H then
onDoubleClick()
end

J=0
H=nil
F=0
else
J=1
F=L
H=M
end
end)



if not at.HideSearchBar then
local L=a.load'Z'
local M=false





















local N=an("Search","search",at.UIElements.SideBarContainer,true)
N.Size=UDim2.new(1,-at.UIPadding/2,0,39)
N.Position=UDim2.new(0,at.UIPadding/2,0,0)

ak.AddSignal(N.MouseButton1Click,function()
if M then
return
end

L.new(at.TabModule,at.UIElements.Main,function()

M=false
if at.Resizable then
at.CanResize=true
end

am(ay,0.1,{ImageTransparency=1}):Play()
ay.Active=false
end)
am(ay,0.1,{ImageTransparency=0.65}):Play()
ay.Active=true

M=true
at.CanResize=false
end)
end



function at.DisableTopbarButtons(L,M)
for N,O in next,M do
for P,Q in next,at.TopBarButtons do
if Q.Name==O then
Q.Object.Visible=false
end
end
end
end



























return at
end end end

local aa={
Window=nil,
Theme=nil,
Creator=a.load'c',
LocalizationModule=a.load'd',
NotificationModule=a.load'e',
Themes=nil,
Transparent=false,

TransparencyValue=0.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.load'j',

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,
}

local ad=(cloneref or clonereference or function(ad)
return ad
end)

aa.cloneref=ad

local ae=ad(game:GetService"HttpService")
local ag=ad(game:GetService"Players")
local ai=ad(game:GetService"CoreGui")
local aj=ad(game:GetService"RunService")

local ak=ag.LocalPlayer or nil

local al=ae:JSONDecode(a.load'k')
if al then
aa.Version=al.version
end

local am=a.load'o'
local an=aa.Creator

local ao=an.New




local ap=a.load's'

local aq=protectgui or(syn and syn.protect_gui)or function()end

local ar=gethui and gethui()or(ai or ak:WaitForChild"PlayerGui")

local as=ao("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=as

aa.ScreenGui=ao("ScreenGui",{
Name="WindUI",
Parent=ar,
IgnoreGuiInset=true,
ScreenInsets="None",
DisplayOrder=-99999,
},{

ao("Folder",{
Name="Window",
}),






ao("Folder",{
Name="KeySystem",
}),
ao("Folder",{
Name="Popups",
}),
ao("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=ao("ScreenGui",{
Name="WindUI/Notifications",
Parent=ar,
IgnoreGuiInset=true,
DisplayOrder=999999,
ResetOnSpawn=false,
})
aa.DropdownGui=ao("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=ar,
IgnoreGuiInset=true,
})
aa.TooltipGui=ao("ScreenGui",{
Name="WindUI/Tooltips",
Parent=ar,
IgnoreGuiInset=true,
})
aq(aa.ScreenGui)
aq(aa.NotificationGui)
aq(aa.DropdownGui)
aq(aa.TooltipGui)

an.Init(aa)

function aa.SetParent(at,au)
if aa.ScreenGui then
aa.ScreenGui.Parent=au
end
if aa.NotificationGui then
aa.NotificationGui.Parent=au
end
if aa.DropdownGui then
aa.DropdownGui.Parent=au
end
if aa.TooltipGui then
aa.TooltipGui.Parent=au
end
end
math.clamp(aa.TransparencyValue,0,1)

local at=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(au,av)
av.Holder=at.Frame
av.Window=aa.Window

return aa.NotificationModule.New(av)
end

function aa.SetNotificationLower(au,av)
at.SetLower(av)
end

function aa.SetFont(au,av)
an.UpdateFont(av)
end

function aa.OnThemeChange(au,av)
aa.OnThemeChangeFunction=av
end

function aa.AddTheme(au,av)
aa.Themes[av.Name]=av
return av
end

function aa.SetTheme(au,av)
if aa.Themes[av]then
aa.Theme=aa.Themes[av]
an.SetTheme(aa.Themes[av])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(av)
end

return aa.Themes[av]
end
return nil
end

function aa.GetThemes(au)
return aa.Themes
end
function aa.GetCurrentTheme(au)
return aa.Theme.Name
end
function aa.GetTransparency(au)
return aa.Transparent or false
end
function aa.GetWindowSize(au)
return aa.Window.UIElements.Main.Size
end
function aa.Localization(au,av)
return aa.LocalizationModule:New(av,an)
end

function aa.SetLanguage(au,av)
if an.Localization then
return an.SetLanguage(av)
end
return false
end

function aa.ToggleAcrylic(au,av)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=av
aa.Window.AcrylicPaint.Model.Transparency=av and 0.98 or 1
if av then
ap.Enable()
else
ap.Disable()
end
end
end

function aa.Gradient(au,av,aw)
local ax={}
local ay={}

for az,aA in next,av do
local aB=tonumber(az)
if aB then
aB=math.clamp(aB/100,0,1)

local b=aA.Color
if typeof(b)=="string"and string.sub(b,1,1)=="#"then
b=Color3.fromHex(b)
end

local d=aA.Transparency or 0

table.insert(ax,ColorSequenceKeypoint.new(aB,b))
table.insert(ay,NumberSequenceKeypoint.new(aB,d))
end
end

table.sort(ax,function(az,aA)
return az.Time<aA.Time
end)
table.sort(ay,function(az,aA)
return az.Time<aA.Time
end)

if#ax<2 then
table.insert(ax,ColorSequenceKeypoint.new(1,ax[1].Value))
table.insert(ay,NumberSequenceKeypoint.new(1,ay[1].Value))
end

local az={
Color=ColorSequence.new(ax),
Transparency=NumberSequence.new(ay),
}

if aw then
for aA,aB in pairs(aw)do
az[aA]=aB
end
end

return az
end

function aa.Popup(au,av)
av.WindUI=aa
return a.load't'.new(av,aa.ScreenGui.Popups)
end

aa.Themes=a.load'u'(aa,an)

an.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(an.Language)

function aa.CreateWindow(au,av)
local aw=a.load'_'

if not aj:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
end

av.WindUI=aa
av.Window=aa.Window
av.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local ax=true

local ay=aa.Themes[av.Theme or"Dark"]


an.SetTheme(ay)

local az=gethwid or function()
return ag.LocalPlayer.UserId
end

local aA=az()

if av.KeySystem then
ax=false

local function loadKeysystem()
am.new(av,aA,function(aB)
ax=aB
end)
end

local aB="WindUI/"..(av.Folder or"Temp").."/"..aA..".key"

if av.KeySystem.KeyValidator then
if av.KeySystem.SaveKey and isfile(aB)then
local b=readfile(aB)
local d=av.KeySystem.KeyValidator(b)

if d then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not av.KeySystem.API then
if av.KeySystem.SaveKey and isfile(aB)then
local b=readfile(aB)
local d=(type(av.KeySystem.Key)=="table")and table.find(av.KeySystem.Key,b)
or tostring(av.KeySystem.Key)==tostring(b)

if d then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(aB)then
local b=readfile(aB)
local d=false

for f,g in next,av.KeySystem.API do
local h=aa.Services[g.Type]
if h then
local i={}
for l,m in next,h.Args do
table.insert(i,g[m])
end

local l=h.New(table.unpack(i))
local m=l.Verify(b)
if m then
d=true
break
end
end
end

ax=d
if not d then
loadKeysystem()
end
else
loadKeysystem()
end
end

repeat
task.wait()
until ax
end

av.OpenOnCreate=false
local aB=aw(av)
aa.Transparent=av.Transparent
aa.Window=aB
aB:Open()

if av.Acrylic then
ap.init()
end













return aB
end

return aa