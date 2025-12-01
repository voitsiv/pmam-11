local vector = require "vector"
local ffi = require 'ffi'


local inspect = require 'gamesense/inspect'
local http = require 'gamesense/http'
local function rgba(r, g, b, a, ...) return ("\a%x%x%x%x"):format(r, g, b, a) .. ... end
local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(h,i,j,...)table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=h,["g"]=i,["b"]=j,a=0},x=e().x/2,y=e().y,text=...},g)})end;function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=255, 170, 220 end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local k=(function()local d={}d.rec=function(d,b,c,e,f,g,k,l,m)m=math.min(d/2,b/2,m)renderer.rectangle(d,b+m,c,e-m*2,f,g,k,l)renderer.rectangle(d+m,b,c-m*2,m,f,g,k,l)renderer.rectangle(d+m,b+e-m,c-m*2,m,f,g,k,l)renderer.circle(d+m,b+m,f,g,k,l,m,180,0.25)renderer.circle(d-m+c,b+m,f,g,k,l,m,90,0.25)renderer.circle(d-m+c,b-m+e,f,g,k,l,m,0,0.25)renderer.circle(d+m,b-m+e,f,g,k,l,m,-90,0.25)end;d.rec_outline=function(d,b,c,e,f,g,k,l,m,n)m=math.min(c/2,e/2,m)if m==1 then renderer.rectangle(d,b,c,n,f,g,k,l)renderer.rectangle(d,b+e-n,c,n,f,g,k,l)else renderer.rectangle(d+m,b,c-m*2,n,f,g,k,l)renderer.rectangle(d+m,b+e-n,c-m*2,n,f,g,k,l)renderer.rectangle(d,b+m,n,e-m*2,f,g,k,l)renderer.rectangle(d+c-n,b+m,n,e-m*2,f,g,k,l)renderer.circle_outline(d+m,b+m,f,g,k,l,m,180,0.25,n)renderer.circle_outline(d+m,b+e-m,f,g,k,l,m,90,0.25,n)renderer.circle_outline(d+c-m,b+m,f,g,k,l,m,-90,0.25,n)renderer.circle_outline(d+c-m,b+e-m,f,g,k,l,m,0,0.25,n)end end;d.glow_module_notify=function(b,c,e,f,g,k,l,m,n,o,p,q,r,s,s)local t=1;local u=1;if s then d.rec(b,c,e,f,l,m,n,o,k)end;for l=0,g do local m=o/2*(l/g)^3;d.rec_outline(b+(l-g-u)*t,c+(l-g-u)*t,e-(l-g-u)*t*2,f-(l-g-u)*t*2,p,q,r,m/1.5,k+t*(g-l+u),t)end end;return d end)()function g:render_bottom(g,l)local e=e()local m=6;local n="     "..self:get_text()local f=f("",n)local o=8;local p=5;local q=0+m+f.x;local q,r=q+p*2,12+10+1;local s,t=self.x-q/2,math.ceil(self.y-40+0.4)local u=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(l-g)*r*1.4,u*7)self.color.a=c(self.color.a,255,u*2)else self.y=c(self.y,self.y-10,u*15)self.color.a=c(self.color.a,0,u*20)if self.color.a<=1 then self.active=false end end;local c,e,g,l=self.color.r,self.color.g,self.color.b,self.color.a;k.glow_module_notify(s,t,q,r,1,o,25,25,25,l,255, 226, 255,l,true)local k=p+2;k=k+0+m;renderer.text(s+k,t+r/2-f.y/2,255,199,255,l,"b",nil,"Ð¾â€žÐ… ")renderer.text(s+k,t+r/2-f.y/2   ,c,e,g,l,"",nil,n)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()
local w, h = client.screen_size()

local dragging = (function() local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;client.set_event_callback("paint",function()c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end)function a.drag(q,r,A,B,C,D,E)if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end;if E then end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local ui_lib = (function() local function a(b,c,d,e)c=c or""d=d or 1;e=e or#b;local f=""for g=d,e do f=f..c..tostring(b[g])end;return f end;local function h(b,i)for g=1,#b do if b[g]==i then return true end end;return false end;local function j(k,...)if not k then error(a({...}),3)end end;local function l(b)local m,n=false,false;for o,k in pairs(b)do if type(o)=="number"then m=true else n=true end end;return m,n end;local p=globals.realtime()local q={}local r={}local s={}local function t(b)local u=false;for o,k in pairs(b)do if getmetatable(k)==s then u=true end end;return u end;local function v(k,w)return k~=q[w].default end;local function x(k)return#k>0 end;function s.__index(w,o)if q[w]~=nil and type(o)=="string"and o:sub(1,1)~="_"then return q[w][o]or r[o]end end;function s.__call(w,...)local y={...}if globals.realtime()==p and#y==1 and type(y[1])=="table"then local z={}local A=y[1]local B=false;local C=false;local D={}for o,k in pairs(A)do if type(o)~="number"then D[o]=k;C=true end end;if A[1]~=nil and(type(A[1])~="table"or not t(A[1]))then D[1]=A[1]B=true;if type(D[1])~="table"then D[1]={D[1]}end end;if C then table.insert(z,D)end;for g=B and 2 or 1,#A do if t(A[g])then table.insert(z,A[g])end end;for g=1,#z do local E=z[g]local k;if E[1]~=nil then k=E[1]end;for o,F in pairs(E)do if o~=1 then w:add_children(F,k,o)end end end;return w end;if#y==0 then return w:get()else local G,H=pcall(ui.set,y[1].reference,select(2,unpack(y)))end end;function s.__tostring(w)return"Menu item: "..w.tab.." - "..w.container.." - "..w.name end;function r.new(I,J,K,L,...)local y={...}local M,N;local O;if type(I)=="function"and I~=ui.reference then for o,k in pairs(ui)do if k==I and o:sub(1,4)=="new_"then O=o:sub(5,-1)end end;local G;G,M=pcall(I,J,K,L,unpack(y))if not G then error(M,2)end;N=I==ui.reference else M=I;N=true end;if O==nil then local k={pcall(ui.get,M)}if k[1]==false then O="button"else k={select(2,unpack(k))}if#k==1 then local P=type(k[1])if P=="string"then local G=pcall(ui.set,M,nil)ui.set(M,k[1])O=G and"textbox"or"combobox"elseif P=="number"then local G=pcall(ui.set,M,-9999999999999999)ui.set(M,k[1])O=G and"listbox"or"slider"elseif P=="boolean"then O="checkbox"elseif P=="table"then O="multiselect"end elseif#k>=2 and type(k[1])=="boolean"and type(k[2])=="number"then O="hotkey"elseif#k==4 then if type(k[1])=="number"and type(k[2])=="number"and type(k[3])=="number"and type(k[4])=="number"then O="color_picker"end end end end;local Q;if N==false and O~=nil then if O=="slider"then Q=y[3]or y[1]elseif O=="combobox"then Q=y[1][1]elseif O=="checkbox"then Q=false end end;local w={}q[w]={tab=J,container=K,name=L,reference=M,type=O,default=Q,visible=true,ui_callback=nil,callbacks={},is_gamesense_reference=N,children_values={},children_callbacks={}}if N==false and O~=nil then if O=="slider"then q[w].min=y[1]q[w].max=y[2]elseif O=="combobox"or O=="multiselect"or O=="listbox"then q[w].values=y[1]end end;return setmetatable(w,s)end;function r:set(...)local R={...}local S=q[self]local T={pcall(ui.set,S.reference,unpack(R))}end;function r:get()local S=q[self]return ui.get(S.reference)end;function r:contains(k)local S=q[self]if S.type=="multiselect"then return h(ui.get(S.reference),k)elseif S.type=="combobox"then return ui.get(S.reference)==k else error(string.format("Invalid type %s for contains",S.type),2)end end;function r:as_keys()local S=q[self]if S.type=="multiselect"then local k=ui.get(S.reference)local f={}for g=1,#k do f[k[g]]=true end;return f elseif S.type=="combobox"then return{[ui.get(S.reference)]=true}else error(string.format("Invalid type %s for as_keys",S.type),2)end end;function r:set_visible(U)local S=q[self]if S==nil then error("Invalid ui element",2)end;ui.set_visible(S.reference,U)S.visible=U end;function r:set_default(k)q[self].default=k;self:set(k)end;function r:add_children(V,W,o)local S=q[self]local X=type(W)=="function"if W==nil then W=true;if S.type=="boolean"then W=true elseif S.type=="combobox"then X=true;W=v elseif S.type=="multiselect"then X=true;W=x end end;if getmetatable(V)==s then V={V}end;for Y,F in pairs(V)do if X then q[F].parent_visible_callback=W else q[F].parent_visible_value=W end;self[o or F.reference]=F end;r._process_callbacks(self)end;function r:add_callback(Z)local S=q[self]table.insert(S.callbacks,Z)r._process_callbacks(self)end;r.set_callback=r.add_callback;function r:_process_callbacks()local S=q[self]if S.ui_callback==nil then local Z=function(M,_)local k=self:get()local a0=S.combo_elements;if a0~=nil and#a0>0 then local a1;for g=1,#a0 do local a2=a0[g]if#a2>0 then local a3={}for g=1,#a2 do if h(k,a2[g])then table.insert(a3,a2[g])end end;if#a3>1 then a1=a1 or k;for g=#a3,1,-1 do if h(S.value_prev,a3[g])and#a3>1 then table.remove(a3,g)end end;local a4=a3[1]for g=#a1,1,-1 do if a1[g]~=a4 and h(a2,a1[g])then table.remove(a1,g)end end elseif#a3==0 and not(a2.required==false)then a1=a1 or k;if S.value_prev~=nil then for g=1,#S.value_prev do if h(a2,S.value_prev[g])then table.insert(a1,S.value_prev[g])break end end end end end end;if a1~=nil then self:set(a1)end;S.value_prev=k;k=a1 or k end;for o,F in pairs(self)do local a5=q[F]local a6=false;if S.visible then if a5.parent_visible_callback~=nil then a6=a5.parent_visible_callback(k,self,F)elseif S.type=="multiselect"then local a7=type(a5.parent_visible_value)for g=1,#k do if a7 and h(a5.parent_visible_value,k[g])or a5.parent_visible_value==k[g]then a6=true;break end end elseif type(a5.parent_visible_value)=="table"then a6=a5.parent_visible_value[k]or h(a5.parent_visible_value,k)else a6=k==a5.parent_visible_value end end;ui.set_visible(a5.reference,a6)a5.visible=a6;if a5.ui_callback~=nil then a5.ui_callback(F)end end;for g=1,#S.callbacks do S.callbacks[g]()end end;ui.set_callback(S.reference,Z)S.ui_callback=Z end;S.ui_callback()end;local a8={}local a9={__index=function(Y,o)if a8[o]then return a8[o]end;local aa=o;if aa:sub(1,4)~="new_"then aa="new_"..aa end;if ui[aa]~=nil then local ab=ui[aa]return function(self,L,...)local y={...}local a0={}local ac=aa:sub(5,-1)local ad="Cannot create a "..ac..": "local w;if ab==ui.new_textbox and L==nil then L="\n"end;L=(self.prefix or"")..L..(self.suffix or"")if ab==ui.new_slider then local ae,af,ag,ah,ai,aj,ak=unpack(y)if type(ag)=="table"then local al=ag;ag=al.default;ah=al.show_tooltip;ai=al.unit;aj=al.scale;ak=al.tooltips end;if ag~=nil then end;if ai~=nil then end;ag=ag or nil;if ah==nil then ah=true end;ai=ai or nil;aj=aj or 1;ak=ak or nil;w=r.new(ui.new_slider,self.tab,self.container,L,ae,af,ag,ah,ai,aj,ak)elseif ab==ui.new_combobox or ab==ui.new_multiselect or ab==ui.new_listbox then local am={...}if#am==1 and type(am[1])=="table"then am=am[1]end;if ab==ui.new_multiselect then local an={}for g=1,#am do local I=am[g]if type(I)=="table"then table.insert(a0,I)for ao=1,#I do table.insert(an,I[ao])end else table.insert(an,I)end end;am=an end;for g=1,#am do local I=am[g]end;if ab==ui.new_multiselect then local G;G,w=pcall(r.new,ui.new_multiselect,self.tab,self.container,L,am)if not G then error(w,2)end end elseif ab==ui.new_hotkey then if y[1]==nil then y[1]=false end;local ap=unpack(y)elseif ab==ui.new_button then local Z=unpack(y)elseif ab==ui.new_color_picker then local aq,ar,as,at=unpack(y)end;if w==nil then local G;G,w=pcall(r.new,ab,self.tab,self.container,L,...)if not G then error(w,2)end end;self[q[w].reference]=w;if#a0>0 then q[w].combo_elements=a0;local au={}for g=1,#a0 do if not a0[g].required==false then table.insert(au,a0[g][1])end end;w:set(au)q[w].value_prev=au;r._process_callbacks(w)end;return w end end end}local av={RAGE={"Aimbot","Other"},AA={"Anti-aimbot angles","Fake lag","Other"},LEGIT={"Weapon type","Aimbot","Triggerbot","Other"},VISUALS={"Player ESP","Other ESP","Colored models","Effects"},MISC={"Miscellaneous","Settings","Lua","Other"},SKINS={"Weapon skin","Knife options","Glove options"},PLAYERS={"Players","Adjustments"},LUA={"A","B"}}for J,aw in pairs(av)do av[J]={}for g=1,#aw do av[J][aw[g]:lower()]=true end end;function a8.new(J,K)J=J:upper()return setmetatable({tab=J,container=K,items={}},a9)end;function a8.reference(J,K,L)if L==nil and type(J)=="table"and getmetatable(J)==a9 then L=K;J,K=J.tab,J.container end;local ax={pcall(ui.reference,J,K,L)}j(ax[1]==true,"Cannot reference a Gamesense menu item: the menu item does not exist.")local ay={select(2,unpack(ax))}local az={}for g=1,#ay do local M=ay[g]local w=r.new(M,J,K,L)table.insert(az,w)end;return unpack(az)end;local aA=setmetatable({},{__index=function(Y,o)if ui[o]~=nil and o~="new_string"and(o==ui.reference or o:sub(1,4)=="new_")then return function(...)local G,f=pcall(ui[o],...)if not G then error(f,2)end;return r.new(f,...)end end end})return setmetatable(a8,{__call=function(Y,...)return a8.new(...)end,__index=function(Y,aB)return r[aB]or aA[aB]or ui[aB]end}) end)()

-- Existing imports and utility functions remain unchanged
-- Existing imports and utility functions remain unchanged
client.set_event_callback("paint_ui", function() end)

local client_camera_angles           = client.camera_angles
local client_create_interface        = client.create_interface
local client_eye_position            = client.eye_position
local client_set_event_callback      = client.set_event_callback
local client_userid_to_entindex      = client.userid_to_entindex

local entity_get_local_player        = entity.get_local_player
local entity_get_player_name         = entity.get_player_name
local entity_get_prop                = entity.get_prop
local entity_is_alive                = entity.is_alive

local globals_chokedcommands         = globals.chokedcommands
local globals_realtime               = globals.realtime
local globals_tickcount              = globals.tickcount
local globals_tickinterval           = globals.tickinterval
local globals_curtime                = globals.curtime

local math_abs                       = math.abs
local math_ceil                      = math.ceil
local math_floor                     = math.floor

local string_format                  = string.format
local string_lower                   = string.lower

local table_concat                   = table.concat
local table_insert                   = table.insert

local ui_new_checkbox                = ui.new_checkbox
local ui_reference                   = ui.reference
local error                          = error
local pairs                          = pairs
local plist_get                      = plist.get
local ui_get                         = ui.get
local print                          = print
local ui_set_callback                = ui.set_callback
local ui_new_combobox                = ui.new_combobox
local client_set_clan_tag            = client.set_clan_tag

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end

local ffi = require("ffi")
client.exec("clear")
client.color_log(0, 150, 255, 'starting..')
client.color_log(0, 150, 255, 'hook 1 ')
client.color_log(0, 150, 255, 'hook 2')
client.color_log(0, 150, 255, 'hook 3')
client.color_log(0, 150, 255, 'hook 4')
client.color_log(0, 150, 255, 'hook 5')
client.color_log(0, 150, 255, 'hook 6')
client.color_log(0, 150, 255, 'hook 7')
client.color_log(0, 150, 255, 'other 9 hooks enabled')
print("succesfully, welcome to AimSense resolver v14.88!")

function Clamp(value, min, max) return math.min(math.max(value, min), max) end

local function NormalizeAngle(angle)
    if angle == nil then return 0 end
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end
local function AngleDifference(dest_angle, src_angle)
    local delta = math.fmod(dest_angle - src_angle, 360)
    if dest_angle > src_angle then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end
    return delta
end

local function DegToRad(Deg) return Deg * (math.pi / 180) end
local function RadToDeg(Rad) return Rad * (180 / math.pi) end

local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}

local menu_color = ui.reference("MISC", "Settings", "Menu color")

client.set_event_callback("paint", function()
    local r, g, b, a = ui.get(menu_color)
end)

local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'
local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local tab_selector = ui.new_combobox("LUA", "B", "\aFF0A0AFfÐ¾â€¦â‚¬ \rSAimsense Resolver crack by bibizyan", {"Home", "Resolver", "Misc"})
local resolver_enabled = ui.new_checkbox("LUA", "B", "\aFF0A0AFf Enable settings")
local resolver_mode = ui.new_combobox("LUA", "B", "Resolver Mode", {"Headshot Mode", "Aggressive Mode", "Duck Mode"})
local color = ui.new_color_picker("LUA", "B", "debug color", 255,255,255)
local multibox = ui.new_multiselect("LUA", "B", "Body Settings", {"hp lower than x value"})
local health = ui.new_slider("LUA", "B", "Ð¾â€¦Ñ› HP", 0, 100, 92, true)
local multibox2 = ui.new_multiselect("LUA", "B", "Head Settings", {"hp lower than x value", "after x misses"})
local health2 = ui.new_slider("LUA", "B", "Ð¾â€¦Ñ› HP", 0, 100, 92, true)
local missed = ui.new_slider("LUA", "B", "Ð¾â€¦Ñ› miss count", 0, 10, 2, true)
local master_switch = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€¦Â˜ Hitlogs")
local dormant_beta = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€¦â€¹ Dormant Aimbot")
local predict_command = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€¦â‚¬ Custom Predict")
local target_hitbox = ui.reference("RAGE", "Aimbot", "Target hitbox")
local forcehead = ui.new_hotkey("LUA", "B", "\aFF0A0AFfÐ¾â€žâ€œ Only Headshot")
local defensive_check_slider1 = ui.new_slider("LUA", "B", "min tick", 1, 13, 4)
local defensive_check_slider2 = ui.new_slider("LUA", "B", "max tick", 1, 13, 12)
local prefer_safe_point = ui.reference("RAGE", "Aimbot", "Prefer safe point")
local force_safe_point = ui.reference("RAGE", "Aimbot", "Force safe point")
local reset = ui.new_button("LUA", "B", "Ð¾â€žÂ˜ Reset Data", function() end)
local clantag_enabled = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€¦Ñ™ Animated Clan Tag")
local watermark = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€žÐ‡ Watermark/Board")
local trashtalk = ui.new_checkbox("LUA", "B", "\aFF0A0AFfÐ¾â€žâ€“ Trashtalk/Deadtalk")
local welcome = ui.new_label("LUA", "B", "\aFF0A0AFfÐ¾â€¦â€¡ \rUpdated to Aimsense RESOLVER V14.88")
local welcome2 = ui.new_label("LUA", "B", "\aff0000FFÐ¾â€¡â€ž \rWelcome back, Dolbaeb")
local welcome3 = ui.new_label("LUA", "B", "\aff0000FFÐ¾â€¡Ð \rStatus Server: Poshel naxyi cracko user")
local secure = ui.new_checkbox("LUA", "B", "\aff0000FFÐ¾â€¦Â± \rSecure Mode")

rgba_to_hex = function(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

ui.set_visible(resolver_enabled, false)
ui.set_visible(resolver_mode, false)
ui.set_visible(multibox, false)
ui.set_visible(health, false)
ui.set_visible(multibox2, false)
ui.set_visible(health2, false)
ui.set_visible(missed, false)
ui.set_visible(dormant_beta, false)
ui.set_visible(predict_command, false)
ui.set_visible(forcehead, false)
ui.set_visible(defensive_check_slider1, false)
ui.set_visible(defensive_check_slider2, false)
ui.set_visible(master_switch, false)
ui.set_visible(reset, false)
ui.set_visible(color, true)
ui.set_visible(clantag_enabled, false)

local function updateTabVisibility()
    local selected_tab = ui.get(tab_selector)
    local is_home = selected_tab == "Home"
    local is_resolver = selected_tab == "Resolver"
    local is_misc = selected_tab == "Misc"

    ui.set_visible(color, is_home)
    ui.set_visible(welcome, is_home)
    ui.set_visible(welcome2, is_home)
    ui.set_visible(welcome3, is_home)
    ui.set_visible(secure, is_home)

    ui.set_visible(resolver_enabled, is_resolver)
    ui.set_visible(resolver_mode, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(multibox, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(multibox2, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(dormant_beta, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(predict_command, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(forcehead, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(master_switch, is_resolver and ui.get(resolver_enabled))
    ui.set_visible(reset, is_resolver and ui.get(resolver_enabled))

    ui.set_visible(clantag_enabled, is_misc)
    ui.set_visible(watermark, is_misc)
    ui.set_visible(trashtalk, is_misc)

    local selected_items = ui.get(multibox)
    local show_health = false
    if selected_items and is_resolver and ui.get(resolver_enabled) then
        for _, item in ipairs(selected_items) do
            if item == "hp lower than x value" then
                show_health = true
                break
            end
        end
    end
    ui.set_visible(health, show_health)

    local selected_items2 = ui.get(multibox2)
    local show_missed = false
    local show_health2 = false
    if selected_items2 and is_resolver and ui.get(resolver_enabled) then
        for _, item in ipairs(selected_items2) do
            if item == "hp lower than x value" then
                show_health2 = true
            end
            if item == "after x misses" then
                show_missed = true
            end
        end
    end
    ui.set_visible(health2, show_health2)
    ui.set_visible(missed, show_missed)

    local predict_enabled = ui.get(predict_command) and is_resolver and ui.get(resolver_enabled)
    ui.set_visible(defensive_check_slider1, predict_enabled)
    ui.set_visible(defensive_check_slider2, predict_enabled)
end

ui.set_enabled(dormant_beta, true)
ui.set_enabled(predict_command, true)

local prev_value = nil
local function on_paint()
    if ui.get(forcehead) or ui.get(resolver_mode) == "Headshot Mode" then
        if prev_value == nil then
            prev_value = ui.get(target_hitbox)
        end
        ui.set(target_hitbox, "Head")
    else
        if prev_value ~= nil then
            ui.set(target_hitbox, prev_value)
            prev_value = nil
        end
    end
end

client.set_event_callback("paint", on_paint)


client.color_log(255, 0, 0, "??????????????????????????????????????")
--client.color_log(255, 0, 0, "?         .-""""""""""-.             ?")
client.color_log(255, 0, 0, "?       .'  WARNING!    '.           ?")
client.color_log(255, 0, 0, "?      /  ÑÊÐÈÏÒ ÍÀÏÈÑÀÍ  \\          ?")
client.color_log(255, 0, 0, "?     :   CHAT GPT   :        ?")
client.color_log(255, 226, 243, "?      :  Created by bibizyan!  :         ?")
client.color_log(255, 0, 0, "?       `._            _.'           ?")
client.color_log(255, 0, 0, "?          `._    _.'               ?")
--client.color_log(255, 0, 0, "?             `"'""'"`               ?")


client.delay_call(0.5, function()
    notify.new_bottom(255, 0, 0, { 
        { "[AimSense] ", true }, 
        { "WARNING: ÑÊÐÈÏÒ ÍÀÏÈÑÀÍ CHAT GPT ", true }, 
        { "Ydali PC dayn", false }
    })
end)


local function defensive_check_predict(cmd)
    if not ui.get(predict_command) then return end
    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then return end
    local defensive_system = {
        ticks_count = 0,
        max_tick_base = 0,
        current_command = 0,
        is_defensive = 0
    }
    local current_tick = globals.tickcount()
    local tick_base = entity.get_prop(player, "m_nTickBase") or 0
    local can_exploit = current_tick > tick_base
    if tick_base > defensive_system.max_tick_base then
        defensive_system.max_tick_base = tick_base
    elseif defensive_system.max_tick_base > tick_base then
        defensive_system.ticks_count = can_exploit and math.min(8, math.max(0, defensive_system.max_tick_base - tick_base - 1)) or 0
    end
    defensive_system.is_defensive = defensive_system.ticks_count > ui.get(defensive_check_slider1) and defensive_system.ticks_count < ui.get(defensive_check_slider2) and 1 or 0
end

client.set_event_callback("predict_command", defensive_check_predict)

ui.set_callback(reset, function()
    ui.set(health, 50)
    ui.set(health2, 50)
    ui.set(missed, 0)
    client.color_log(255,226,243, "[AimSense] Anti-Aim data reseted !")
    notify.new_bottom(255, 226, 243, { { "[AimSense]", true }, { 'Anti-Aim data reseted' }, { " !", true } })
end)

local function updateSliderVisibility()
    local selected_tab = ui.get(tab_selector)
    if selected_tab ~= "resolver" or not ui.get(resolver_enabled) then return end
    local selected_items = ui.get(multibox)
    local show_health = false
    if selected_items then
        for _, item in ipairs(selected_items) do
            if item == "hp lower than x value" then
                show_health = true
                break
            end
        end
    end
    ui.set_visible(health, show_health)
end

local function updateSliderVisibility2()
    local selected_tab = ui.get(tab_selector)
    if selected_tab ~= "Resolver" or not ui.get(resolver_enabled) then return end
    local selected_items2 = ui.get(multibox2)
    local show_missed = false
    if selected_items2 then
        for _, item in ipairs(selected_items2) do
            if item == "after x misses" then
                show_missed = true
                break
            end
        end
    end
    ui.set_visible(missed, show_missed)
end

local function updateSliderVisibility3()
    local selected_tab = ui.get(tab_selector)
    if selected_tab ~= "Resolver" or not ui.get(resolver_enabled) then return end
    local selected_items3 = ui.get(multibox2)
    local show_health2 = false
    if selected_items3 then
        for _, item in ipairs(selected_items3) do
            if item == "hp lower than x value" then
                show_health2 = true
                break
            end
        end
    end
    ui.set_visible(health2, show_health2)
end

local function updatePredictVisibility()
    local selected_tab = ui.get(tab_selector)
    if selected_tab ~= "Resolver" or not ui.get(resolver_enabled) then return end
    local predict_enabled = ui.get(predict_command)
    ui.set_visible(defensive_check_slider1, predict_enabled)
    ui.set_visible(defensive_check_slider2, predict_enabled)
end

local GetAnimState = function(ent)
    if not ent or ent == ffi.NULL then
        print("GetAnimState: Invalid entity")
        return false
    end
    local Address = type(ent) == "cdata" and ent or NativeGetClientEntity(ent)
    if not Address or Address == ffi.NULL then
        print("GetAnimState: Failed to get client entity for " .. tostring(ent))
        return false
    end
    local AddressVtable = ffi.cast("void***", Address)
    local anim_state = ffi.cast(animstate_t, ffi.cast("char*", AddressVtable) + 0x9960)[0]
    if not anim_state or anim_state == ffi.NULL then
        print("GetAnimState: Null animation state for entity " .. tostring(ent))
        return false
    end
    return anim_state
end

local GetSimulationTime = function(ent)
    if not ent or not entity.is_alive(ent) then return 0, 0 end
    local pointer = NativeGetClientEntity(ent)
    if pointer and pointer ~= ffi.NULL then
        return entity.get_prop(ent, "m_flSimulationTime") or 0, ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] or 0
    end
    return 0, 0
end

local GetMaxDesync = function(player)
    if not player or not entity.is_alive(player) then return 0 end
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    local speedfactor = Clamp(Animstate.feet_speed_forwards_or_sideways, 0, 1)
    local avg_speedfactor = (Animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = Animstate.duck_amount
    if duck_amount > 0 then avg_speedfactor = avg_speedfactor + ((duck_amount * speedfactor) * (0.5 - avg_speedfactor)) end
    return Clamp(avg_speedfactor, .5, 1)
end

local function toticks(time)
    return math.floor(time / globals.tickinterval() + 0.5)
end

local IsPlayerAnimating = function(player)
    if not player or not entity.is_alive(player) then return false end
    local CurrentSimulationTime, RecordSimulationTime = GetSimulationTime(player)
    CurrentSimulationTime, RecordSimulationTime = toticks(CurrentSimulationTime), toticks(RecordSimulationTime)
    return CurrentSimulationTime ~= nil and RecordSimulationTime ~= nil
end

local GetChokedPackets = function(player)
    if not player or not IsPlayerAnimating(player) then return 0 end
    local CurrentSimulationTime, PreviousSimulationTime = GetSimulationTime(player)
    local SimulationTimeDifference = globals.curtime() - CurrentSimulationTime
    local ChokedCommands = Clamp(toticks(math.max(0.0, SimulationTimeDifference - client.latency())), 0, cvar.sv_maxusrcmdprocessticks:get_int() - 2)
    return ChokedCommands
end

function RebuildServerYaw(player)
    if not player or not entity.is_alive(player) then return 0 end
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    
    local m_flGoalFeetYaw = Animstate.goal_feet_yaw
    local eye_feet_delta = AngleDifference(Animstate.eye_angles_y, Animstate.goal_feet_yaw)
    local flRunningSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
    
    local flYawModifier = (((Animstate.stop_to_full_running_fraction * -0.3) - 0.2) * flRunningSpeed) + 1.0
    if Animstate.duck_amount > 0.0 then
        local flDuckingSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
        flYawModifier = flYawModifier + ((Animstate.duck_amount * flDuckingSpeed) * (0.5 - flYawModifier))
    end
   
    local flMaxYawModifier = flYawModifier * Animstate.max_yaw
    local flMinYawModifier = flYawModifier * Animstate.min_yaw
   
    if eye_feet_delta <= flMaxYawModifier then
        if flMinYawModifier > eye_feet_delta then
            m_flGoalFeetYaw = math.abs(flMinYawModifier) + Animstate.eye_angles_y
        end
    else
        m_flGoalFeetYaw = Animstate.eye_angles_y - math.abs(flMaxYawModifier)
    end

    return NormalizeAngle(m_flGoalFeetYaw)
end

local JitterBuffer = 1
local Resolver = { 
    Jitter = { Jittering = false, JitterTicks = 0, StaticTicks = 0, YawCache = {}, JitterCache = 0, Difference = 0 },
    Main = { Mode = 0, Side = 0, Angles = 0 }
}

local Cache = {}

local function DetectDumbAA(player)
    if not player or not entity.is_alive(player) then return false end
    local Animstate = GetAnimState(player)
    if not Animstate then return false end
    local mode = ui.get(resolver_mode)
    local jitter_threshold = mode == "Headshot Mode" and 5.0 or mode == "Duck Mode" and 4.0 or 8.0
    local desync = math.abs(NormalizeAngle(Animstate.eye_angles_y - Animstate.torso_yaw))
    local velocity = math.sqrt((entity.get_prop(player, "m_vecVelocity[0]") or 0)^2 + (entity.get_prop(player, "m_vecVelocity[1]") or 0)^2)
    local choked_packets = GetChokedPackets(player)
    local is_jittering = Resolver.Jitter.Jittering
    local jitter_difference = Resolver.Jitter.Difference or 0

    return (not is_jittering or jitter_difference < jitter_threshold) and
           desync < 7.0 and
           (velocity < 25 or choked_packets <= 0)
end

local function predictPlayerState(player)
    if not player or not entity.is_alive(player) then return 0, 0 end
    local Animstate = GetAnimState(player)
    if not Animstate then return 0, 0 end
    local current_tick = globals.tickcount()
    local tick_base = entity.get_prop(player, "m_nTickBase") or 0
    local velocity = math.sqrt((entity.get_prop(player, "m_vecVelocity[0]") or 0)^2 + (entity.get_prop(player, "m_vecVelocity[1]") or 0)^2)
    local latency = client.latency() / globals.tickinterval()
    local predicted_yaw = Animstate.eye_angles_y

    if velocity > 10 then
        predicted_yaw = NormalizeAngle(predicted_yaw + (velocity * globals.tickinterval() * 0.2))
    end
    predicted_yaw = NormalizeAngle(predicted_yaw + (latency * 0.3))
    return predicted_yaw, tick_base
end

local CDetectJitter = function(player)
    if not player or not entity.is_alive(player) then return end
    local Data = Resolver.Jitter
    Data.YawCache = Data.YawCache or {}
    local EyeAnglesY = entity.get_prop(player, "m_angEyeAngles[1]") or 0
    local mode = ui.get(resolver_mode)
    local jitter_threshold = mode == "Headshot Mode" and 6.0 or mode == "Duck Mode" and 4.0 or 10.0
    Data.YawCache[Data.JitterCache % JitterBuffer] = EyeAnglesY
    if Data.JitterCache >= JitterBuffer + 1 then
        Data.JitterCache = 0
    else
        Data.JitterCache = Data.JitterCache + 1
    end
    for i = 0, JitterBuffer - 1 do
        local prev = Data.YawCache[(Data.JitterCache - i - 1) % JitterBuffer] or 0
        local curr = Data.YawCache[Data.JitterCache % JitterBuffer] or 0
        if prev ~= 0 and curr ~= 0 then
            local Difference = math.abs(NormalizeAngle(prev - curr))
            Data.Jittering = Difference >= (jitter_threshold * GetMaxDesync(player)) and true or false
            Data.Difference = Difference
        end
    end
end

local CProcessImpact = function(player)
    if not player or not entity.is_alive(player) then return 0 end
    return Resolver.Jitter.Jittering and 1 or 0
end

local CDetectDesyncSide = function(player)
    if not player or not entity.is_alive(player) then return 0 end
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    local mode = ui.get(resolver_mode)
    local choked_threshold = mode == "Headshot Mode" and 0 or mode == "Duck Mode" and 0 or 1

    if Resolver.Jitter.Jittering and GetChokedPackets(player) < choked_threshold then
        Cache.FirstNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 1] or 0)
        Cache.SecondNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 2] or 0)

        Cache.FirstSinAngle = math.sin(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondSinAngle = math.sin(DegToRad(Cache.SecondNormalizedAngle))

        Cache.FirstCosAngle = math.cos(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondCosAngle = math.cos(DegToRad(Cache.SecondNormalizedAngle))

        Cache.AVGYaw = NormalizeAngle(RadToDeg(math.atan2((Cache.FirstSinAngle + Cache.SecondSinAngle) / 2.0, (Cache.FirstCosAngle + Cache.SecondCosAngle) / 2.0)))
        Cache.Difference = NormalizeAngle(Animstate.eye_angles_y - Cache.AVGYaw)
        if Cache.Difference ~= 0.0 then Resolver.Main.Side = Cache.Difference > 0.0 and 1 or -1 else Resolver.Main.Side = 0 end
    end

    return Resolver.Main.Side
end

local miss_count = 0

local function resetResolverData()
    Resolver.Jitter.Jittering = false
    Resolver.Jitter.JitterTicks = 0
    Resolver.Jitter.StaticTicks = 0
    Resolver.Jitter.YawCache = {}
    Resolver.Jitter.JitterCache = 0
    Resolver.Jitter.Difference = 0
    Resolver.Main.Mode = 0
    Resolver.Main.Side = 0
    Resolver.Main.Angles = 0
    miss_count = 0
end

local function aim_miss(player)
    miss_count = miss_count + 1 
end

client.set_event_callback("aim_miss", aim_miss)

local function is_baimable(player)
    if not player or not entity.is_alive(player) then return end
    local lethal = entity.get_prop(player, "m_iHealth") or 0
    local number_lethal = ui.get(health)  
    local selected_items = ui.get(multibox)
    local selected_items2 = ui.get(multibox2)
    local force_head = ui.get(forcehead)
    local mode = ui.get(resolver_mode)
    local Animstate = GetAnimState(player)
    local is_ducking = Animstate and Animstate.duck_amount > 0.5
    local is_dumb_aa = DetectDumbAA(player)

    plist.set(player, "Override prefer body aim", "-")
    plist.set(player, "Override safe point", "On")

    if is_dumb_aa or force_head or mode == "Headshot Mode" then
        return
    end

    if mode == "Duck Mode" and is_ducking then
        if lethal <= 15 then
            plist.set(player, "Override prefer body aim", "Force")
        end
        return
    end

    if selected_items then
        for _, item in ipairs(selected_items) do
            if item == "hp lower than x value" and lethal > 0 and lethal <= number_lethal / 2 then 
                plist.set(player, "Override prefer body aim", "Force")
            end
        end
    end

    local missed_number = ui.get(missed)
    local number_lethal2 = ui.get(health2)
    if selected_items2 then
        for _, item2 in ipairs(selected_items2) do 
            if item2 == "hp lower than x value" and lethal > 0 and lethal <= number_lethal2 then
                plist.set(player, "Override safe point", "On")
            end          
            if item2 == "after x misses" and miss_count >= missed_number and lethal > 0 then
                plist.set(player, "Override safe point", "On")
            end    
        end
    end
end

client.set_event_callback("player_death", function(player)
    miss_count = 0
end)

local CResolverInstance = function(player)
    if not player or not entity.is_alive(player) then
        print("CResolverInstance: Invalid or dead player " .. tostring(player))
        return
    end
    local Animstate = GetAnimState(player)
    if not Animstate then
        print("CResolverInstance: Failed to get Animstate for player " .. tostring(player))
        return
    end

    CProcessImpact(player)
    CDetectJitter(player)
    CDetectDesyncSide(player)

    local predicted_yaw, _ = predictPlayerState(player)
    local force_head = ui.get(forcehead)
    local mode = ui.get(resolver_mode)
    local is_dumb_aa = DetectDumbAA(player)

    if is_dumb_aa or force_head or mode == "Headshot Mode" then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 0
        plist.set(player, "Force body yaw", false)
        plist.set(player, "Override safe point", "On")
        plist.set(player, "Override prefer body aim", "-")
        return
    end

    local ChokedPackets = GetChokedPackets(player)
    local Desync = math.abs(NormalizeAngle(predicted_yaw - Animstate.torso_yaw))
    local Velocity = math.sqrt((entity.get_prop(player, "m_vecVelocity[0]") or 0)^2 + (entity.get_prop(player, "m_vecVelocity[1]") or 0)^2)
    local IsDucking = Animstate.duck_amount > 0.5
    local IsFakeWalking = math.abs(AngleDifference(predicted_yaw, Animstate.last_move_yaw)) < 5 and Velocity > 10
    local desync_threshold = mode == "Duck Mode" and 8 or 12
    local velocity_threshold = mode == "Duck Mode" and 30 or 50
    local duck_desync_threshold = 3
    local jitter_angle = mode == "Duck Mode" and 6.0 or 12.0

    if mode == "Duck Mode" and IsDucking then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - predicted_yaw)
        Resolver.Main.Mode = 1
        return
    end

    if ChokedPackets > 0 then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 0
    elseif Desync >= desync_threshold and Velocity > velocity_threshold then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - predicted_yaw)
        Resolver.Main.Mode = 1
    elseif Desync > duck_desync_threshold and IsDucking then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - predicted_yaw)
        Resolver.Main.Mode = 1
    elseif IsFakeWalking then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 1
    else
        if Resolver.Jitter.Jittering then
            Resolver.Main.Angles = (jitter_angle * GetMaxDesync(player)) * Resolver.Main.Side
            Resolver.Main.Mode = 1
        else
            Resolver.Main.Angles = 0
            Resolver.Main.Mode = 0
        end
    end
end

client.set_event_callback("net_update_end", function()
    if not ui.get(resolver_enabled) then return end
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        Resolver.Main.Mode = 0
        return
    end
    local Players = entity.get_players(true)
    client.update_player_list()
    for _, idx in ipairs(Players) do
        if entity.is_alive(idx) and IsPlayerAnimating(idx) then
            CResolverInstance(idx)
            local is_dumb_aa = DetectDumbAA(idx)
            if is_dumb_aa or ui.get(forcehead) or ui.get(resolver_mode) == "Headshot Mode" then
                plist.set(idx, "Force body yaw", false)
                plist.set(idx, "Override safe point", "On")
                plist.set(idx, "Force body yaw value", 0)
            else
                plist.set(idx, "Force body yaw value", Resolver.Main.Mode ~= 0 and Resolver.Main.Angles or 0)
                plist.set(idx, "Force body yaw", Resolver.Main.Mode ~= 0)
            end
            is_baimable(idx)
            plist.set(idx, "Correction active", true)
        else
            plist.set(idx, "Force body yaw", false)
        end
    end
end)

client.set_event_callback("round_start", function()
    resetResolverData()
end)

client.register_esp_flag("BODY", 200, 200, 200, function(e) return (entity.is_enemy(e) and ui.get(resolver_enabled) and Resolver.Main.Mode == 1) and true or false end)
client.register_esp_flag("BAIM", 161, 73, 47, function(player) return plist.get(player, "Override prefer body aim") == "Force" end)
client.register_esp_flag("EBASH", 131, 153, 50, function(player) return plist.get(player, "Override safe point") == "On" end)

ui.set_callback(tab_selector, updateTabVisibility)
ui.set_callback(resolver_enabled, function()
    updateTabVisibility()
    updateSliderVisibility()
    updateSliderVisibility2()
    updateSliderVisibility3()
end)
ui.set_callback(multibox, updateSliderVisibility)
ui.set_callback(multibox2, function()
    updateSliderVisibility2()
    updateSliderVisibility3()
end)
ui.set_callback(predict_command, updatePredictVisibility)

client.set_event_callback("paint", function()
    rgba_to_hex = function(c,d,e,f)
        return string.format('%02x%02x%02x%02x',c,d,e,f)
    end
end)

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local classes = {
    net_channel = function()
        local this = { }
        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client_create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local netc_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client_set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    aimbot = function(net_channel)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            if not target or not entity.is_alive(target) then return 0 end
            local force_head = ui.get(forcehead)
            local mode = ui.get(resolver_mode)
            local is_dumb_aa = DetectDumbAA(target)
    
            if is_dumb_aa or force_head or mode == "Headshot Mode" then
                return 2
            end
    
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist.get(target, 'Override safe point')
            local ui_safety = { ui.get(prefer_safe_point), ui.get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                    spread_angle = vector(aim-shot):length2d()
                    break
                end
            end
            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity_get_local_player()
            if not p_ent or not me or not entity.is_alive(p_ent) or not entity.is_alive(me) then return end
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
                handle_time = globals_realtime(),
                self_choke = globals_chokedcommands(),
                flags = {
                    boosted = e.boosted
                },
                safety = get_safety(e, p_ent),
                correction = plist.get(p_ent, 'Correction active'),
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client_eye_position()),
                view = vector(client_camera_angles()),
                velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),
                history = globals.tickcount() - e.tick
            }
        end
        
        this.missed = function(e)
            if aim_data[e.id] == nil then return end
        
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            
            local net_data = net_channel:get()
            if not net_data then return end
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string_format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math_abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math_abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick(pre_data, globals_tickcount())
            
            local me = entity_get_local_player()
            if not me or not entity.is_alive(me) then return end
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local target_name = string_lower(entity_get_player_name(e.target) or "unknown")
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
        
            local reasons = {
                ['event_timeout'] = function()
                    print(string_format(
                        'Missed %s shot due to event timeout [%s] [%s]', 
                        shot_id, target_name, net_state
                    ))
                end,

                ['death'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death [dropped: %d | flags: %s | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets, table_concat(pflags), table_concat(uflags)
                    ))
                end,
        
                ['prediction_error'] = function(type)
                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [vel_modifier: %.1f | history(Ðžâ€): %d | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, type, net_state, entity_get_prop(me, 'm_flVelocityModifier') or 0, pre_data.history, table_concat(uflags)
                    ))
                end,
        
                ['spread'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread ( dmg: %d | safety: %d | history(Ðžâ€): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, spread_angle, 
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string_format('unknown [angle: ?Ð’Â° | ?Ð’Â°]')
                    }

                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | safety: %d | history(Ðžâ€): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end
            }
        
            local post_data = {
                event_timeout = (globals_realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= (entity_get_prop(me, 'm_totalHitsOnServer') or 0),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
        
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
            if aim_data[e.id] == nil then return end
        
            local p_ent = e.target
            if not p_ent or not entity.is_alive(p_ent) then return end
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            local me = entity_get_local_player()
            if not me or not entity.is_alive(me) then return end
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'
            local target_name = string_lower(entity_get_player_name(e.target) or "unknown")
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
            local spread_angle = get_inaccuracy_tick(pre_data, globals_tickcount())
            
            local _verification = function()
                local text = ''
                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage
                if hg_diff or dmg_diff then
                    text = string_format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''
                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end
                            return addr
                        end)()
                    )
                end
                return text
            end

            notify.new_bottom(255, 226, 243, { { "", true }, { 'registered ' }, { shot_id }, { ' shot in ' }, { target_name }, {"'s "} , { hgroup }, { " for "}, { e.damage }, { " ( hitchance: "}, { hit_chance}, { " | safety: " }, { pre_data.safety }, { " | history(Ðžâ€): "}, {  pre_data.history }, { " | flags: " }, { table_concat(pflags), _verification() }, { " )" } })
            print(string_format(
                'Registered %s shot in %s\'s %s for %d damage ( hitchance: %d%% | safety: %s | history(Ðžâ€): %d | flags: %s%s )',
                shot_id, target_name, hgroup, e.damage,
                hit_chance, pre_data.safety, pre_data.history, table_concat(pflags), _verification()
            ))
        end
        
        this.bullet_impact = function(e)
            local tick = globals_tickcount()
            local me = entity_get_local_player()
            if not me or not entity.is_alive(me) then return end
            local user = client_userid_to_entindex(e.userid)
            
            if user ~= me then return end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client_eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
            if not net_data then return end

            if not net_data.is_valid_packet then
                for id in pairs(aim_data) do
                    table_insert(aim_data[id].dropped_packets, net_data.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local aimbot = classes.aimbot(net_channel)

local g_player_hurt = function(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
    if not attacker_id or attacker_id ~= entity_get_local_player() then return end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client_userid_to_entindex(e.userid)
        local target_name = entity_get_player_name(target_id) or "unknown"
        print(string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
    end
end

local interface_callback = function(c)
    local addr = not ui_get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']
    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui_set_callback(master_switch, interface_callback)
interface_callback(master_switch)

local Miscellaneous = {}
Miscellaneous.clantag = {}
do
    local build = function(str)
        local tag = {}
        for i = 1, #str do
            tag[#tag + 1] = str:sub(1, i) .. "|"
        end
        tag[#tag + 1] = str .. "|"
        for i = 1, #str do
            tag[#tag + 1] = str:sub(i + 1) .. "|"
        end
        tag[#tag + 1] = " "
        tag[#tag + 1] = "|"
        tag[#tag + 1] = " "
        return tag
    end

    local old_time = 0

    function Miscellaneous.clantag()
        if not ui.get(clantag_enabled) then
            client.set_clan_tag("")
            return
        end

        local tag = build("ididnaxyiense ~ resolver")
        local curtime = math.floor(globals.curtime() * 4.5)

        if old_time ~= curtime then
            client.set_clan_tag(tag[(curtime % #tag) + 1])
            old_time = curtime
        end
    end
end

client.set_event_callback("paint", function()
    Miscellaneous.clantag()
end)

updateTabVisibility()

-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_latency, client_screen_size, client_set_event_callback, entity_get_local_player, entity_get_player_resource, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, globals_chokedcommands, globals_curtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, math_max, math_min, renderer_gradient, renderer_indicator, renderer_load_svg, renderer_measure_text, renderer_rectangle, renderer_text, renderer_texture, table_insert, tonumber, unpack, pairs, type = client.camera_angles, client.latency, client.screen_size, client.set_event_callback, entity.get_local_player, entity.get_player_resource, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, globals.chokedcommands, globals.curtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, math.max, math.min, renderer.gradient, renderer.indicator, renderer.load_svg, renderer.measure_text, renderer.rectangle, renderer.text, renderer.texture, table.insert, tonumber, unpack, pairs, type

local dragging_indicators = dragging.new("indicators", 10, 10)

local bool_items = {
    ["MinDMG"] = {
        references = {({ui_lib.reference("RAGE", "Aimbot", "Minimum damage override")})[1], ({ui_lib.reference("RAGE", "Aimbot", "Minimum damage override")})[2]},
        text = "Ð¾â€¡â€¹ MD",
        color = {255, 255, 255} -- White
    },
    ["Double tap"] = {
        references = {({ui_lib.reference("RAGE", "Aimbot", "Double tap")})[1], ({ui_lib.reference("RAGE", "Aimbot", "Double tap")})[2]},
        text = "Ð¾â€¦â‚¬ DT",
        color = {255, 255, 255} -- White
    },
    ["Ping"] = {
        references = {({ui_lib.reference("MISC", "Miscellaneous", "Ping spike")})[1], ({ui_lib.reference("MISC", "Miscellaneous", "Ping spike")})[2]},
        text = "Ð¾â€¡Â© PING",
        color = {126, 195, 12} -- Green
    },
    ["Freestanding"] = {
        references = {({ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")})[1], ({ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")})[2]},
        text = "Ð¾â€¦â€¹ FS",
        color = {255, 255, 255} -- White
    },
    ["FakeDuck"] = {
        references = {({ui_lib.reference("RAGE", "Other", "Duck peek assist")})[1], ({ui_lib.reference("RAGE", "Other", "Duck peek assist")})[2]},
        text = "Ð¾â€¦Ò DUCK",
        color = {255, 255, 255} -- White
    },
    ["OnShot"] = {
        references = {({ui_lib.reference("AA", "Other", "On shot anti-aim")})[1], ({ui_lib.reference("AA", "Other", "On shot anti-aim")})[2]},
        text = "Ð¾â€žÒ OSAA",
        color = {255, 255, 255} -- White
    },
    ["PreferBody"] = {
        references = {({ui_lib.reference("RAGE", "Aimbot", "Force body aim")})[1], ({ui_lib.reference("RAGE", "Aimbot", "Force body aim")})[2]},
        text = "Ð¾â€ Ðƒ FORCE BODY",
        color = {255, 255, 0} -- White
    },
}

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renderer_rectangle(x, y, w, s, r, g, b, a) -- top
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a) -- bottom
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a) -- left
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a) -- right
end

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function normalize_yaw(angle)
	angle = (angle % 360 + 360) % 360
	return angle > 180 and angle - 360 or angle
end

local bar_min_width = 130

local math_lerp = function(a, b, t) return a + (b - a) * t end

-- Ð Â¦Ð Ð†Ð ÂµÐ¡â€š Double Tap
local dt_r, dt_g, dt_b = 255, 255, 255 -- Ð Ð…Ð Â°Ð¡â€¡Ð Â°Ð Â»Ð¡ÐŠÐ Ð…Ð¡â€¹Ð â„– Ð¡â€ Ð Ð†Ð ÂµÐ¡â€š: Ð Â±Ð ÂµÐ Â»Ð¡â€¹Ð â„–
local dt_alpha = 0

local custom_items = {
	{
		name = "Fake lag",
		title_text = "Fake lag",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			if self.maxusrcmdprocessticks_reference == nil then
				self.maxusrcmdprocessticks_reference = ui_lib.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
			end

			self.chokedcommands_prev = self.chokedcommands
			self.chokedcommands = globals_chokedcommands()
			if self.chokedcommands_max == nil or self.chokedcommands > self.chokedcommands_max then
				self.chokedcommands_max = self.chokedcommands
			elseif self.chokedcommands == 0 and self.chokedcommands_prev ~= 0 then
				self.chokedcommands_max = self.chokedcommands_prev
			elseif self.chokedcommands == 0 and self.chokedcommands_prev_cmd == 0 then
				self.chokedcommands_max = 0
			end

			if self.limit == nil or self.chokedcommands == 0 then
				self.limit = self.maxusrcmdprocessticks_reference:get()-2
			end

			self.tickcount = globals_tickcount()
			if self.tickcount ~= self.tickcount_prev then
				self.last_cmd = globals_curtime()
				self.chokedcommands_prev_cmd = self.chokedcommands_prev
				self.tickcount_prev = self.tickcount
			end

			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local interp = (globals_curtime() - self.last_cmd) / globals_tickinterval()

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7
			local chokedcommands_interpolated = math_max(0, math_min(1, self.chokedcommands + (interp < 1 and interp or 0)))

			-- 4280ECCB
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*math_max(0, math_min(1, self.chokedcommands_max / self.limit)))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, math_max(bar_width-2, 0), bar_h-2, r_top, g_top, b_top, a*0.25, r_bot, g_bot, b_bot, a*0.25, false)
			renderer_gradient(bar_x+1, bar_y+1, math_max(bar_width*math_max(0, math_min(1, chokedcommands_interpolated / self.chokedcommands_max))-2, 0), bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)

			if self.chokedcommands_max > 0 then
				renderer_text(bar_x+math_min(bar_width-4, bar_w-7), y+4, 255, 255, 255, 255, "-", 0, self.chokedcommands_max)
			end
		end
	},
	{
		name = "Body yaw",
		title_text = "Body yaw",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local local_player = entity_get_local_player()
			if local_player ~= nil then
				local body_yaw = math_max(-60, math_min(60, math_floor((entity_get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5)))

				local percentage = (math_max(-60, math_min(60, body_yaw*1.06))+60) / 120

				-- display reversed for backwards AAs
				local _, camera_yaw = client_camera_angles()
				local _, rot_yaw = entity_get_prop(local_player, "m_angAbsRotation")

				if camera_yaw ~= nil and rot_yaw ~= nil and 60 < math_abs(normalize_yaw(camera_yaw-(rot_yaw+body_yaw))) then
					percentage = 1-percentage
				end

				renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
				renderer_gradient(bar_x+1, bar_y+1, bar_w-2, bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

				local center = math_floor(bar_w/2+0.5)
				if percentage > 0.5 then
					renderer_rectangle(bar_x+center+1, bar_y+1, bar_w*(percentage-0.5)-2, bar_h-2, 14, 14, 14, 255)
					renderer_gradient(bar_x+center+1, bar_y+1, bar_w*(percentage-0.5)-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)
				else
					local start = math_floor(bar_w*percentage)
					renderer_rectangle(bar_x+1+start, bar_y+1, center-start, bar_h-2, 14, 14, 14, 255)
					renderer_gradient(bar_x+1+start, bar_y+1, center-start, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)
				end

				renderer_gradient(bar_x+center, bar_y+1, 1, bar_h-2, 255, 255, 255, a, 140, 140, 140, a, false)

				if body_yaw ~= 0 then
					renderer_text(math_max(bar_x+4, math_min(bar_x+bar_w-6, bar_x+bar_w*percentage+0.5-(body_yaw < 0 and 2 or 0))), y+9, 255, 255, 255, 255, "c-", 0, body_yaw) --string.format("%.3f", entity_get_prop(local_player, "m_flPoseParameter", 11)*120-60)
				end
			end
		end
	},
	{
		name = "Head height",
		title_text = "Head height",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			local local_player = entity_get_local_player()
			local _, _, o_z = entity_get_prop(local_player, "m_vecAbsOrigin")
			local _, _, h_z = entity_hitbox_position(local_player, 0)

			if o_z ~= nil and h_z ~= nil then
				if h_z ~= self.h_z_prev then
					self.h_z_prev = self.h_z
					self.duckamount = entity_get_prop(local_player, "m_flDuckAmount") or 0
				end

				local delta = h_z - o_z + (self.duckamount or 0)*12
				local max_height = 70
				local min_height = 55

				local percentage = math_max(0, math_min(1, 1-(delta-min_height)/(max_height-min_height)))

				-- slider bar
				local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
				local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

				local bar_width = math_floor(bar_w*percentage)

				renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
				renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

				renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)
			end
		end
	},
	{
		name = "Ping spike + amount",
		title_text = "Ping spike",
		group = "Ping spike",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference, self.amount_reference = ui_lib.reference("MISC", "Miscellaneous", "Ping spike")
			end
			local draw = self.reference:get() and self.hotkey_reference:get()
			if draw then
				self.ping_extra = tonumber(entity_get_prop(entity_get_player_resource(), "m_iPing", entity_get_local_player()) or 0)-client_latency()*1000-5
				self.percentage = math_min(1, math_max(0, self.ping_extra / self.amount_reference:get()))
			end
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			-- slider bar
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*(self.percentage))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)
		end
	},
	{
		name = "Fake duck + height",
		title_text = "Fake duck",
		group = "Fake duck",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Duck peek assist")
				self.infinite_duck_reference = ui_lib.reference("MISC", "Movement", "Infinite duck")
			end
			local draw = self.reference:get() and self.infinite_duck_reference:get()
			if draw then
				self.tickcount = globals_tickcount()
				if self.tickcount ~= self.tickcount_prev then
					self.duckamount_prev_2 = self.duckamount_prev
					self.duckamount_prev = self.duckamount
					self.duckamount = entity_get_prop(entity_get_local_player(), "m_flDuckAmount") or 0
					self.tickcount_prev = self.tickcount
				end

				if self.duckamount_max == nil or self.duckamount > self.duckamount_max then
					self.duckamount_max = self.duckamount
				elseif self.duckamount_prev ~= nil and self.duckamount_prev_2 ~= nil and self.duckamount_prev > self.duckamount and self.duckamount_prev > self.duckamount_prev_2 then
					self.duckamount_max = self.duckamount_prev
				elseif self.duckamount_prev == 0 and self.duckamount == 0 and self.duckamount_prev_2 == 0 then
					self.duckamount_max = 0
				end
			else
				self.duckamount_prev_2 = nil
				self.duckamount_prev = nil
				self.duckamount_max = nil
			end
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			-- slider bar
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*math_max(0, math_min(1, self.duckamount_max)))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a*0.25, r_bot, g_bot, b_bot, a*0.25, false)
			renderer_gradient(bar_x+1, bar_y+1, bar_w*(self.duckamount)-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)
		end
	},
	{
		name = "Ping spike",
		title_text = "Ping spike",
		group = "Ping spike",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference, self.amount_reference = ui_lib.reference("MISC", "Miscellaneous", "Ping spike")
			end
			local draw = self.reference:get() and self.hotkey_reference:get()
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Fake duck",
		title_text = "Fake duck",
		group = "Fake duck",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Duck peek assist")
				self.infinite_duck_reference = ui_lib.reference("MISC", "Movement", "Infinite duck")
			end
			local draw = self.reference:get() and self.infinite_duck_reference:get()
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Double tap",
		title_text = "Double tap",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("RAGE", "Other", "Double tap")
				self.mode_reference = ui_lib.reference("RAGE", "Other", "Double tap mode")
			end
			return self.reference:get() and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			self.right_text_width = math_max((renderer_measure_text("b", "[Offensive]")+4), (renderer_measure_text("b", "[Defensive]")+4))
			return self.title_text_width+self.right_text_width, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 235, 255, 255, nil, 0, self.title_text)
			local local_player = entity_get_local_player()
			local weapon = entity_get_player_weapon(local_player)

			local next_attack = math_max(entity_get_prop(weapon, "m_flNextPrimaryAttack") or 0, entity_get_prop(local_player, "m_flNextAttack") or 0)
			local r, g, b, a = unpack(globals_curtime() > next_attack and {126, 195, 12} or {230, 230, 39})
			renderer_text(x+w, y, r, g, b, 255, "rb", 0, "[", self.mode_reference:get(), "]")
		end
	},
	{
		name = "On-shot anti-aim",
		title_text = "On-shot AA",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Other", "On shot anti-aim")
				self.dt_reference, self.dt_hotkey_reference = ui_lib.reference("RAGE", "Other", "Double tap")
			end
			return self.reference:get() and self.hotkey_reference:get() and not (self.dt_reference:get() and self.dt_hotkey_reference:get())
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Safe point",
		title_text = "Safe point",
		get_should_draw = function(self)
			if self.reference == nil then
				self.force_reference = ui_lib.reference("RAGE", "Aimbot", "Force safe point")
			end
			return self.force_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Freestanding",
		title_text = "Freestanding",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")
			end
			return #self.reference:get() > 0 and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Slow motion",
		title_text = "Slow motion",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Other", "Slow motion")
			end
			return self.reference:get() and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Anti-aim correction override",
		title_text = "Override",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Anti-aim correction override")
			end
			return self.reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Force body aim",
		title_text = "Force baim",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Force body aim")
			end
			return self.reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	}

}
local svg_patterns = {}

local function table_get_keys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table_insert(keys, key)
	end
	return keys
end

local function gen_pattern(width, height)
	local svg = [[
<svg width="]] .. width .. [[" height="]] .. height .. [[" viewBox="0 0 ]] .. width .. [[ ]] .. height .. [[">
<rect width="]] .. width .. [[" height="]] .. height .. [[" y="0" x="0" fill="#151515"/>
#pattern
</svg>
]]
	for x=0, width, 4 do
		for y=0, height, 4 do
			local pattern = [[
<rect height="3" width="1" x="]] .. x+1 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/>
<rect height="1" width="1" x="]] .. x+3 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/>
<rect height="2" width="1" x="]] .. x+3 .. [[" y="]] .. y+2 .. [[" fill="#0d0d0d"/>
]]
			svg = svg:gsub("#pattern", pattern .. "#pattern")
		end
	end
	svg = svg:gsub("#pattern\n", "")
	return svg
end

local function draw_container(x, y, w, h, a, header, background_pattern)
	a = a or 255
	rectangle_outline(x, y, w, h, 18, 18, 18, a)
	rectangle_outline(x+1, y+1, w-2, h-2, 62, 62, 62, a)
	rectangle_outline(x+2, y+2, w-4, h-4, 44, 44, 44, a, 3)
	rectangle_outline(x+5, y+5, w-10, h-10, 62, 62, 62, a)

	if background_pattern then
		local rw, ph, lxa, pw = w-12, h-12, 0

		for i=6, 2, -1 do
			pw = 2^i
			if rw % pw < 7 then
				break
			end
		end

		for i=1, 2 do
			if svg_patterns[pw] == nil or svg_patterns[pw][ph] == nil then
				svg_patterns[pw] = svg_patterns[pw] or {}
				svg_patterns[pw][ph] = renderer_load_svg(gen_pattern(pw, ph), pw, ph) or -1
			end

			if svg_patterns[pw][ph] ~= -1 then
				for xa=0, rw-pw, pw do
					renderer_texture(svg_patterns[pw][ph], x+6+xa+lxa, y+6, pw, ph, 255, 255, 255, a)
				end
			end

			if rw % pw == 0 then break end
			lxa, pw = rw - (rw % pw), rw % pw
			rw = pw
		end
	else
		renderer_rectangle(x+6, y+6, w-12, h-12, 25, 25, 25, a)
	end

	if header then
		local x, y = x+7, y+7
		local w1, w2 = math_floor((w-14)/2), math_ceil((w-14)/2)

		for i=1, 2 do
			renderer_gradient(x, y, w1, 1, 59, 175, 222, a, 202, 70, 205, a, true)
			renderer_gradient(x+w1, y, w2, 1, 202, 70, 205, a, 201, 227, 58, a, true)
			y, a = y+1, a*0.2
		end
	end
end

-- set up menu
local custom_items_names, custom_items_groups = {}, {}

local j=1
for i=1, #custom_items do
	local item = custom_items[i]
	if item.group == nil then
		table_insert(custom_items_names, item.name)
		j = j + 1
	else
		if custom_items_groups[item.group] == nil then
			custom_items_groups[item.group] = {i=j}
		end
		table_insert(custom_items_groups[item.group], item)
	end
end

for _, group_items in pairs(custom_items_groups) do
	local names = {}
	for i=1,#group_items do
		table_insert(names, group_items[i].name)
	end
	table_insert(custom_items_names, group_items.i, names)
end

local container = ui_lib.new("LUA", "A")
local indicators = container:combobox("Indicators", {"Off", "Built-in"}) {
	{"Built-in",
		additional = container:checkbox("Additional indicators") {
			types = container:multiselect("\nAdditional indicator types", {"MinDMG", "Double tap", "Ping", "FakeDuck", "Freestanding", "OnShot", "PreferBody"}) -- Changed to include OnShot and PreferBody
		},
		move_up = container:slider("Move indicators", 0, 60, 0, true, "", 1, {[0] = "Off"})
	},
	{"Custom",
		custom_types = container:multiselect("Indicator types", custom_items_names),
		custom_color = container:color_picker("Indicator color", 240, 240, 240, 255)
	}
}
indicators:set("Built-in")

local math_lerp = function(a, b, t) return a + (b - a) * t end

-- Ð Â¦Ð Ð†Ð ÂµÐ¡â€š Double Tap
local dt_r, dt_g, dt_b = 255, 255, 255 -- Ð Ð…Ð Â°Ð¡â€¡Ð Â°Ð Â»Ð¡ÐŠÐ Ð…Ð¡â€¹Ð â„– Ð¡â€ Ð Ð†Ð ÂµÐ¡â€š: Ð Â±Ð ÂµÐ Â»Ð¡â€¹Ð â„–
local dt_alpha = 0

client_set_event_callback("paint", function()
    local indicators_value = indicators:get()

    if indicators_value == "Built-in" then
        local value = indicators.move_up:get()
        if value > 0 then
            for i=1, value do
                renderer_indicator(255, 255, 255, 0, "A")
            end
        end
        if indicators.additional:get() and entity_is_alive(entity_get_local_player()) and #indicators.additional.types:get() > 0 then
            local x_start = 10
            local y = renderer_indicator(255, 255, 255, 0, "Additional indicators")
            local active_bool_items = indicators.additional.types:get()
            for i=1, #active_bool_items do
                local item = bool_items[active_bool_items[i]]
                if item then
                    local enabled = true
                    for j=1, #item.references do
                        local value = item.references[j]:get()
                        if not value or (type(value) == "table" and #value == 0) then
                            enabled = false
                            break
                        end
                    end

                    -- Ð Ñ’Ð Ð…Ð Ñ‘Ð Ñ˜Ð Â°Ð¡â€ Ð Ñ‘Ð¡Ð Ð Ñ—Ð Ñ•Ð¡ÐÐ Ð†Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð/Ð Ñ‘Ð¡ÐƒÐ¡â€¡Ð ÂµÐ Â·Ð Ð…Ð Ñ•Ð Ð†Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð
                    local target_alpha = enabled and 255 or 0
                    item.alpha = item.alpha or 0
                    item.alpha = math_floor(math_lerp(item.alpha, target_alpha, 0.1))

                    if item.alpha > 0 then
                        local r, g, b = unpack(item.color)
                        local a = item.alpha
                        if item.width == nil or item.height == nil then
                            item.width, item.height = renderer_measure_text("+", item.text)
                        end
                        renderer_text(x_start, y, r, g, b, a, "+", 0, item.text)
                        y = y + item.height + 2
                    end
                end
            end
        end
    else
        local y = 10
        for i=1, 100 do
            y = renderer_indicator(255, 255, 255, 0, "A")
            if 0 > y then break end
        end
    end

    if indicators_value == "Custom" and entity_is_alive(entity_get_local_player()) then
        local screen_width, screen_height = client_screen_size()
        local x, y = dragging_indicators:get()
        local align_right = x > screen_width / 2
        local margin = 3
        local types = indicators.custom_types:get()
        local items_drawn, text_width = {}, 0

        for i=1, #custom_items do
            local item = custom_items[i]
            if table_contains(types, item.name) then
                if item.get_should_draw == nil or item:get_should_draw() then
                    table_insert(items_drawn, item)
                end
                local w_t = item:get_text_width()
                text_width = math_max(text_width, w_t)
            end
        end

        if #items_drawn == 0 then return end

        local width, height = 120, 10
        local h_item = {}
        for i=1, #items_drawn do
            local item = items_drawn[i]
            local w, h = item:get_size(text_width)
            h_item[item] = h
            width = math_max(width, w)
            height = height + h + ((i == #items_drawn) and 0 or margin)
        end
        height = height + 12
        dragging_indicators:drag(width, height)
        -- Changed alpha from 255 to 150 for transparent black background
        draw_container(x, y, width, height, 150, true, true)

        local r, g, b, a = indicators.custom_color:get()
        local inner_x = x + 10
        local current_y = y + 15

        for i=1, #items_drawn do
            local item = items_drawn[i]

            -- Ð Ñ’Ð Ð…Ð Ñ‘Ð Ñ˜Ð Â°Ð¡â€ Ð Ñ‘Ð¡Ð Ð Ñ—Ð Ñ•Ð¡ÐÐ Ð†Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð/Ð Ñ‘Ð¡ÐƒÐ¡â€¡Ð ÂµÐ Â·Ð Ð…Ð Ñ•Ð Ð†Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð Ð Ò‘Ð Â»Ð¡Ð Ð Ñ”Ð Â°Ð Â¶Ð Ò‘Ð Ñ•Ð Ñ–Ð Ñ• Ð Ñ‘Ð Ð…Ð Ò‘Ð Ñ‘Ð Ñ”Ð Â°Ð¡â€šÐ Ñ•Ð¡Ð‚Ð Â°
            local should_show = item.get_should_draw and item:get_should_draw()
            local target_alpha = should_show and 255 or 0
            a = math_floor(math_lerp(a, target_alpha, 0.1))

            -- Ð â€ºÐ Ñ•Ð Ñ–Ð Ñ‘Ð Ñ”Ð Â° Ð Ò‘Ð Â»Ð¡Ð Double Tap Ð²Ð‚â€ Ð Ñ‘Ð Â·Ð Ñ˜Ð ÂµÐ Ð…Ð ÂµÐ Ð…Ð Ñ‘Ð Âµ Ð¡â€ Ð Ð†Ð ÂµÐ¡â€šÐ Â°
            if item.name == "Double tap" then
                local enabled = item.get_should_draw and item:get_should_draw()

                if enabled then
                    dt_r = math_floor(math_lerp(dt_r, 255, 0.1))
                    dt_g = math_floor(math_lerp(dt_g, 255, 0.1))
                    dt_b = math_floor(math_lerp(dt_b, 255, 0.1))
                else
                    dt_r = math_floor(math_lerp(dt_r, 255, 0.1))
                    dt_g = math_floor(math_lerp(dt_g, 0, 0.1))
                    dt_b = math_floor(math_lerp(dt_b, 0, 0.1))
                end

                r, g, b = dt_r, dt_g, dt_b
            end

            item:draw(inner_x, current_y, width - 20, h_item[item], align_right, text_width, r, g, b, a)
            current_y = current_y + h_item[item] + margin
        end
    end
end)

-- ===============================================
-- Ð â€™Ð¡ÐƒÐ Ñ—Ð Ñ•Ð Ñ˜Ð Ñ•Ð Ñ–Ð Â°Ð¡â€šÐ ÂµÐ Â»Ð¡ÐŠÐ Ð…Ð¡â€¹Ð Âµ Ð¡â€žÐ¡Ñ“Ð Ð…Ð Ñ”Ð¡â€ Ð Ñ‘Ð Ñ‘ (Ð Ò‘Ð Ñ•Ð Â±Ð Â°Ð Ð†Ð¡ÐŠÐ¡â€šÐ Âµ Ð Ñ‘Ð¡â€¦, Ð ÂµÐ¡ÐƒÐ Â»Ð Ñ‘ Ð¡Ñ“ Ð Ð†Ð Â°Ð¡Ðƒ Ð Ñ‘Ð¡â€¦ Ð Ð…Ð ÂµÐ¡â€š)
-- ===============================================

local screen_w, screen_h = client.screen_size()
local steam_name = panorama.open().MyPersonaAPI.GetName() or "player"
local font = "b"
local font_size = 0
local horizontal_padding = 12
local vertical_padding = 6
local item_spacing = 2
local border_radius = 3
local stripe_height = 2
local icon_spacing = 4
local text_height = 13
local screen_margin_x = 12

-- Items table defined globally
local items = {
    {text = "AimSense ~ resolver", icon = nil},
    {text = "Build: Debug", icon = "Ð¾â€žÑ–", r = 255, g = 60, b = 60},
    {text = "User: " .. steam_name, icon = "Ð¾â€žÐ…", r = 255, g = 60, b = 60},
    {text = "", icon = "Ð¾â€¦Â˜", r = 255, g = 60, b = 60}, -- FPS updated dynamically
    {text = "", icon = "Ð¾â€¡Â©", r = 255, g = 60, b = 60}, -- Ping updated dynamically
    {text = "", icon = "Ð¾â€žÐŽ", r = 255, g = 60, b = 60}  -- Time updated dynamically
}

function draw_rounded_rectangle(x, y, width, height, radius)
    renderer.rectangle(x + radius, y, width - radius * 2, height, 25, 25, 25, 200)
    renderer.rectangle(x, y + radius, radius, height - radius * 2, 25, 25, 25, 200)
    renderer.rectangle(x + width - radius, y + radius, radius, height - radius * 2, 25, 25, 25, 200)
    for i = 0, radius do
        local offset = math.floor(radius - math.sqrt(radius * radius - i * i))
        if offset < radius then
            renderer.rectangle(x + offset, y + i, radius - offset, 1, 25, 25, 25, 200)
            renderer.rectangle(x + offset, y + height - i - 1, radius - offset, 1, 25, 25, 25, 200)
            renderer.rectangle(x + width - radius + offset, y + i, radius - offset, 1, 25, 25, 25, 200)
            renderer.rectangle(x + width - radius + offset, y + height - i - 1, radius - offset, 1, 25, 25, 25, 200)
        end
    end
end

function get_gradient_color(progress, time_offset)
    local cycle = math.sin((globals.realtime() + time_offset) * 2) * 0.5 + 0.5
    return math.floor(255 - (195 * (progress + cycle) % 1)), 
           math.floor(60 + (195 * (progress + cycle) % 1)), 
           math.floor(60 + (195 * (progress + cycle) % 1)), 
           255
end

function draw_gradient_text(x, y, text)
    local current_x = x
    for j = 1, #text do
        local char = text:sub(j, j)
        local r, g, b, a = get_gradient_color((j - 1) / (#text - 1), j * 0.1)
        renderer.text(current_x, y, r, g, b, a, font, font_size, char)
        current_x = current_x + renderer.measure_text(font, char) + 1
    end
end

function draw_item(x, y, item, is_first)
    local current_x = x
    if item.icon then
        renderer.text(current_x, y, item.r, item.g, item.b, 255, font, font_size, item.icon)
        current_x = current_x + renderer.measure_text(font, item.icon) + icon_spacing
    end
    if is_first then
        draw_gradient_text(current_x, y, item.text)
    else
        renderer.text(current_x, y, 255, 255, 255, 255, font, font_size, item.text)
    end
end

function draw_forced_watermark()
    if not ui.get(watermark) then return end

    -- Update dynamic items
    items[4].text = math.floor(1 / globals.frametime()) .. " fps"
    items[5].text = math.floor(client.latency() * 1000) .. " ms"
    items[6].text = string.format("%02d:%02d", client.system_time())

    -- Calculate max width
    local max_width = 0
    for i = 1, #items do
        local text_w = renderer.measure_text(font, items[i].text)
        max_width = math.max(max_width, text_w + (items[i].icon and (renderer.measure_text(font, items[i].icon) + icon_spacing) or 0))
    end

    local block_width = max_width + (horizontal_padding * 2)
    local block_height = (text_height + item_spacing) * #items - item_spacing + (vertical_padding * 2)
    local block_x = screen_margin_x
    local block_y = (screen_h - block_height) / 2

    -- Draw background
    draw_rounded_rectangle(block_x, block_y, block_width, block_height, border_radius)

    -- Draw gradient stripe
    for i = 0, block_width - 1 do
        renderer.rectangle(block_x + i, block_y, 1, stripe_height, get_gradient_color(i / block_width, 0))
    end

    -- Draw items
    local current_y = block_y + vertical_padding
    for i = 1, #items do
        draw_item(block_x + horizontal_padding, current_y, items[i], i == 1)
        current_y = current_y + text_height + item_spacing
    end
end

draw_forced_watermark = draw_forced_watermark
client.set_event_callback("paint_ui", draw_forced_watermark)
client.set_event_callback("paint", draw_forced_watermark)

local client = client
local ui_lib = ui_lib

local feature_indicators_ref = nil
local bomb_ref = nil 

feature_indicators_ref = ({ui_lib.reference("VISUALS", "Other ESP", "Feature indicators")})[1]

if type(feature_indicators_ref) == "table" or type(feature_indicators_ref) == "userdata" then

    ui_lib.set(feature_indicators_ref, {})


    ui_lib.set(feature_indicators_ref, true) 
    if type(feature_indicators_ref.disable) == "function" then
        feature_indicators_ref:disable()
    elseif type(feature_indicators_ref.set_enabled) == "function" then
        feature_indicators_ref:set_enabled(true)
    elseif type(feature_indicators_ref.set_active) == "function" then
        feature_indicators_ref:set_active(true)
    end
    if type(feature_indicators_ref.hide) == "function" then
        feature_indicators_ref:hide()
    elseif type(feature_indicators_ref.set_visible) == "function" then
        feature_indicators_ref:set_visible(true)
    end
end


bomb_ref = ({ui_lib.reference("VISUALS", "Other ESP", "Bomb")})[1]

if type(bomb_ref) == "table" or type(bomb_ref) == "userdata" then

    ui_lib.set(bomb_ref, false) 


    if type(bomb_ref.disable) == "function" then
        bomb_ref:disable()
    elseif type(bomb_ref.set_enabled) == "function" then
        bomb_ref:set_enabled(false)
    elseif type(bomb_ref.set_active) == "function" then
        bomb_ref:set_active(false)
    end
    if type(bomb_ref.hide) == "function" then
        bomb_ref:hide()
    elseif type(bomb_ref.set_visible) == "function" then
        bomb_ref:set_visible(false)
    end
end

client.set_event_callback("unload", function()

    if type(feature_indicators_ref) == "table" or type(feature_indicators_ref) == "userdata" then
        ui_lib.set(bomb_ref, true)

        if type(feature_indicators_ref.enable) == "function" then
            feature_indicators_ref:enable()
        elseif type(feature_indicators_ref.set_enabled) == "function" then
            feature_indicators_ref:set_enabled(true)
        elseif type(feature_indicators_ref.set_active) == "function" then
            feature_indicators_ref:set_active(true)
        end
        if type(feature_indicators_ref.show) == "function" then
            feature_indicators_ref:show()
        elseif type(feature_indicators_ref.set_visible) == "function" then
            feature_indicators_ref:set_visible(true)
        end
    end


    if type(bomb_ref) == "table" or type(bomb_ref) == "userdata" then
        ui_lib.set(bomb_ref, true) 

        if type(bomb_ref.enable) == "function" then
            bomb_ref:enable()
        elseif type(bomb_ref.set_enabled) == "function" then
            bomb_ref:set_enabled(true)
        elseif type(bomb_ref.set_active) == "function" then
            bomb_ref:set_active(true)
        end
        if type(bomb_ref.show) == "function" then
            bomb_ref:show()
        elseif type(bomb_ref.set_visible) == "function" then
            bomb_ref:set_visible(true)
        end
    end
end)

local notify = (function()
    local vector = vector
    local lerp = function(a, b, t) return a + (b - a) * t end
    local screen_size = function() return vector(client.screen_size()) end
    local measure_text = function(font, text_to_measure) 
        return vector(renderer.measure_text(font, text_to_measure)) 
    end

    local NotificationSystem = {
        notifications = { bottom = {} },
        max = { bottom = 6 }
    }
    NotificationSystem.__index = NotificationSystem

    function NotificationSystem.new_bottom(r, g, b, ...)
        local screen = screen_size()
        table.insert(NotificationSystem.notifications.bottom, {
            started = false,
            instance = setmetatable({
                active = false,
                timeout = 5,
                color = { r = r, g = g, b = b, a = 0 }, 
                x = screen.x / 2,
                y = screen.y,
                text = {...}
            }, NotificationSystem)
        })
    end

    function NotificationSystem:handler()
        for i = #NotificationSystem.notifications.bottom, 1, -1 do 
            local notification = NotificationSystem.notifications.bottom[i]
            if notification and not notification.instance.active and notification.started then
                table.remove(NotificationSystem.notifications.bottom, i)
            end
        end

        local active_count = 0
        for i = 1, #NotificationSystem.notifications.bottom do
            if NotificationSystem.notifications.bottom[i].instance.active then
                active_count = active_count + 1
            end
        end

        for idx, notification in pairs(NotificationSystem.notifications.bottom) do
            if idx > NotificationSystem.max.bottom then break end 

            if notification.instance.active then
                notification.instance:render_bottom(idx, active_count)
            end
            
            if not notification.started then
                notification.instance:start()
                notification.started = true
            end
        end
    end

    function NotificationSystem:start()
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end

    function NotificationSystem:get_text()
        local result = ""
        local text_parts_container = self.text[1] 
        
        if type(text_parts_container) == "table" then
            for i, part in pairs(text_parts_container) do
                local current_text_part = ""

                if part and part[1] ~= nil then
                    local p1_type = type(part[1])
                    if p1_type == "string" or p1_type == "number" or p1_type == "boolean" then
                        current_text_part = tostring(part[1])
                    else
                        current_text_part = "" 
                    end
                end

                local width = measure_text("", current_text_part).x 
                local r, g, b = 255, 255, 255
                if part and part[2] then 
                    r, g, b = 255, 255, 255 
                end

                result = result .. ("\a%02x%02x%02x%02x%s"):format(r, g, b, self.color.a, current_text_part)
            end
        end
        return result
    end

    local render_utils = (function()
        local utils = {}
        
        function utils.rounded_rect(x, y, w, h, radius, r, g, b, a)
            radius = math.min(w/2, h/2, radius)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end
        
        function utils.rounded_rect_outline(x, y, w, h, radius, thickness, r, g, b, a)
            radius = math.min(w/2, h/2, radius)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w, thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end
        
        function utils.glow_notification(x, y, w, h, width, rounding, r, g, b, a, has_inner)
            local thickness = 1
            local offset = 1

            if has_inner then
                utils.rounded_rect(x, y, w, h, rounding, 25, 25, 25, a) 
            end
            
            for i = 0, width do
                local alpha_mul = a/2 * (i/width)^3
                utils.rounded_rect_outline(
                    x - i, y - i, 
                    w + i*2, h + i*2, 
                    rounding + i, 1, 
                    r, g, b, alpha_mul/1.5
                )
            end
        end

        -- Ð ÑœÐ Ñ›Ð â€™Ð Ñ’Ð Ð‡ Ð Â¤Ð ÐˆÐ ÑœÐ Ñ™Ð Â¦Ð Â˜Ð Ð‡ Ð â€Ð â€ºÐ Ð‡ Ð Ñ›Ð ÑžÐ  Ð Â˜Ð ÐŽÐ Ñ›Ð â€™Ð Ñ™Ð Â˜ Ð Ñ’Ð ÑœÐ Â˜Ð ÑšÐ Â˜Ð  Ð Ñ›Ð â€™Ð Ñ’Ð ÑœÐ ÑœÐ Â«Ð Ò Ð ÐŽÐ Ñ™Ð Ñ’Ð Ñœ-Ð â€ºÐ Â˜Ð ÑœÐ Â˜Ð â„¢
        function utils.draw_animated_scanlines(x, y, w, h, base_alpha, speed)
            local line_height = 1 -- Ð â€™Ð¡â€¹Ð¡ÐƒÐ Ñ•Ð¡â€šÐ Â° Ð Ñ•Ð Ò‘Ð Ð…Ð Ñ•Ð â„– Ð Â»Ð Ñ‘Ð Ð…Ð Ñ‘Ð Ñ‘
            local line_spacing = 3 -- Ð  Ð Â°Ð¡ÐƒÐ¡ÐƒÐ¡â€šÐ Ñ•Ð¡ÐÐ Ð…Ð Ñ‘Ð Âµ Ð Ñ˜Ð ÂµÐ Â¶Ð Ò‘Ð¡Ñ“ Ð Â»Ð Ñ‘Ð Ð…Ð Ñ‘Ð¡ÐÐ Ñ˜Ð Ñ‘
            local line_color_r, line_color_g, line_color_b = 50, 255, 50 -- Ð â€”Ð ÂµÐ Â»Ð ÂµÐ Ð…Ð¡â€¹Ð â„– Ð¡â€ Ð Ð†Ð ÂµÐ¡â€š Ð Ò‘Ð Â»Ð¡Ð "Ð¡â€¦Ð Â°Ð Ñ”Ð ÂµÐ¡Ð‚Ð¡ÐƒÐ Ñ”Ð Ñ•Ð Ñ–Ð Ñ•" Ð¡ÐƒÐ¡â€šÐ Ñ‘Ð Â»Ð¡Ð

            -- Ð ÐŽÐ Ñ˜Ð ÂµÐ¡â€°Ð ÂµÐ Ð…Ð Ñ‘Ð Âµ Ð Â»Ð Ñ‘Ð Ð…Ð Ñ‘Ð â„– Ð¡ÐƒÐ Ñ• Ð Ð†Ð¡Ð‚Ð ÂµÐ Ñ˜Ð ÂµÐ Ð…Ð ÂµÐ Ñ˜
            local offset_y = (globals.realtime() * speed) % (line_height + line_spacing)

            for current_y_offset = 0, h + line_spacing, line_height + line_spacing do
                local draw_y = y + current_y_offset - offset_y
                
                -- Ð â€”Ð Â°Ð¡â€ Ð Ñ‘Ð Ñ”Ð Â»Ð Ñ‘Ð Ð†Ð Â°Ð ÂµÐ Ñ˜ Ð Â»Ð Ñ‘Ð Ð…Ð Ñ‘Ð Ñ‘ Ð Ð†Ð Ð…Ð¡Ñ“Ð¡â€šÐ¡Ð‚Ð Ñ‘ Ð Ð†Ð¡â€¹Ð¡ÐƒÐ Ñ•Ð¡â€šÐ¡â€¹ Ð¡Ñ“Ð Ð†Ð ÂµÐ Ò‘Ð Ñ•Ð Ñ˜Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð
                if draw_y < y then
                    draw_y = draw_y + h + line_spacing
                elseif draw_y > y + h + line_spacing then
                    draw_y = draw_y - (h + line_spacing)
                end

                -- Ð ÐˆÐ Â±Ð ÂµÐ Ò‘Ð Ñ‘Ð Ñ˜Ð¡ÐƒÐ¡Ð, Ð¡â€¡Ð¡â€šÐ Ñ• Ð¡Ð‚Ð Ñ‘Ð¡ÐƒÐ¡Ñ“Ð ÂµÐ Ñ˜ Ð¡â€šÐ Ñ•Ð Â»Ð¡ÐŠÐ Ñ”Ð Ñ• Ð Ð†Ð Ð…Ð¡Ñ“Ð¡â€šÐ¡Ð‚Ð Ñ‘ Ð Ñ–Ð¡Ð‚Ð Â°Ð Ð…Ð Ñ‘Ð¡â€  Ð¡Ñ“Ð Ð†Ð ÂµÐ Ò‘Ð Ñ•Ð Ñ˜Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð
                if draw_y + line_height > y and draw_y < y + h then
                    -- Ð Ñ’Ð Â»Ð¡ÐŠÐ¡â€žÐ Â°-Ð Ñ”Ð Â°Ð Ð…Ð Â°Ð Â» Ð Â·Ð Â°Ð Ð†Ð Ñ‘Ð¡ÐƒÐ Ñ‘Ð¡â€š Ð Ñ•Ð¡â€š Ð Â±Ð Â°Ð Â·Ð Ñ•Ð Ð†Ð Ñ•Ð â„– Ð Â°Ð Â»Ð¡ÐŠÐ¡â€žÐ¡â€¹ Ð¡Ñ“Ð Ð†Ð ÂµÐ Ò‘Ð Ñ•Ð Ñ˜Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð
                    local line_alpha = math.min(base_alpha, 255) * 0.15 -- Ð Ñ›Ð¡â€¡Ð ÂµÐ Ð…Ð¡ÐŠ Ð¡â€šÐ Ñ•Ð Ð…Ð Ñ”Ð Ñ‘Ð â„– Ð¡ÐŒÐ¡â€žÐ¡â€žÐ ÂµÐ Ñ”Ð¡â€š
                    renderer.rectangle(x, draw_y, w, line_height, line_color_r, line_color_g, line_color_b, line_alpha)
                end
            end
        end
        
        return utils
    end)()

    function NotificationSystem:render_bottom(index, active_count)
        local screen = screen_size()
        local padding = 6
        local text_render_offset_x = -5 -- Ð ÐŽÐ Ñ˜Ð ÂµÐ¡â€°Ð ÂµÐ Ð…Ð Ñ‘Ð Âµ Ð¡â€šÐ ÂµÐ Ñ”Ð¡ÐƒÐ¡â€šÐ Â° Ð Ð†Ð Â»Ð ÂµÐ Ð†Ð Ñ• Ð Ð…Ð Â° 5 Ð Ñ—Ð Ñ‘Ð Ñ”Ð¡ÐƒÐ ÂµÐ Â»Ð ÂµÐ â„–
        local text = "      " .. self:get_text()
        local text_size = measure_text("", text)
        local rounding = 8
        local spacing = 5
        
        local width = padding + text_size.x + spacing*2
        local height = 12 + 10 + 1 
        
        local x = self.x - width/2
        local y = math.ceil(self.y - 40 + 0.4)

        local frame_time = globals.frametime()
        
        if globals.realtime() < self.delay then
            self.y = lerp(self.y, screen.y - 45 - (active_count - index) * (height + 15), frame_time * 7) 
            self.color.a = lerp(self.color.a, 255, frame_time * 2) 
        else
            self.y = lerp(self.y, self.y - 10, frame_time * 15)
            self.color.a = lerp(self.color.a, 0, frame_time * 20) 
            if self.color.a <= 1 then
                self.active = false
            end
        end
        
        if self.color.a > 0 then
            -- Ð Ñ›Ð¡â€šÐ¡Ð‚Ð Ñ‘Ð¡ÐƒÐ Ñ•Ð Ð†Ð¡â€¹Ð Ð†Ð Â°Ð ÂµÐ Ñ˜ Ð¡â€žÐ Ñ•Ð Ð… Ð¡Ñ“Ð Ð†Ð ÂµÐ Ò‘Ð Ñ•Ð Ñ˜Ð Â»Ð ÂµÐ Ð…Ð Ñ‘Ð¡Ð
            render_utils.glow_notification(
                x, y, width, height, 15, rounding,
                25, 25, 25, self.color.a, 
                true
            )

            -- Ð Ñ›Ð ÑžÐ  Ð Â˜Ð ÐŽÐ Ñ›Ð â€™Ð Ñ™Ð Ñ’ Ð Ñ’Ð ÑœÐ Â˜Ð ÑšÐ Â˜Ð  Ð Ñ›Ð â€™Ð Ñ’Ð ÑœÐ ÑœÐ Â«Ð Ò Ð ÐŽÐ Ñ™Ð Ñ’Ð Ñœ-Ð â€ºÐ Â˜Ð ÑœÐ Â˜Ð â„¢ Ð ÑŸÐ Ñ›Ð â€™Ð â€¢Ð  Ð Ò Ð Â¤Ð Ñ›Ð ÑœÐ Ñ’
            render_utils.draw_animated_scanlines(x, y, width, height, self.color.a, 20) -- Ð ÐŽÐ Ñ”Ð Ñ•Ð¡Ð‚Ð Ñ•Ð¡ÐƒÐ¡â€šÐ¡ÐŠ 20, Ð Ñ˜Ð Ñ•Ð Â¶Ð Ð…Ð Ñ• Ð Ð…Ð Â°Ð¡ÐƒÐ¡â€šÐ¡Ð‚Ð Ñ•Ð Ñ‘Ð¡â€šÐ¡ÐŠ

            local text_x = x + spacing + 2 + padding + text_render_offset_x -- Ð ÑŸÐ  Ð Â˜Ð ÑšÐ â€¢Ð ÑœÐ â€¢Ð ÑœÐ Ñ› Ð ÐŽÐ ÑšÐ â€¢Ð Â©Ð â€¢Ð ÑœÐ Â˜Ð â€¢ Ð ÑžÐ â€¢Ð Ñ™Ð ÐŽÐ ÑžÐ Ñ’
            renderer.text(
                text_x, y + height/2 - text_size.y/2,
                self.color.r, self.color.g, self.color.b, self.color.a, 
                "M", nil, text
            )
        end
    end

    client.set_event_callback("paint_ui", function()
        NotificationSystem:handler()
    end)

    return NotificationSystem
end)()

    client.delay_call(0.5, function()
        notify.new_bottom(0, 180, 255, { { 'Created by bibizyan |' }, { " Aimsense resolver" } })
end)


local ui = {
    new_checkbox = ui.new_checkbox,
    get = ui.get
}

local client = {
    set_event_callback = client.set_event_callback,
    userid_to_entindex = client.userid_to_entindex,
    exec = client.exec,
    log = client.log
}

local entity = {
    get_local_player = entity.get_local_player,
    get_player_name = entity.get_player_name
}

local last_killer = nil

local function on_player_death(event)
    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)

    if not (local_player and attacker and victim) then return end

    if ui.get(trashtalk) then
        if attacker == local_player and victim ~= local_player then
            local killsay = "say " .. sentences[math.random(#sentences)]
            killsay = string.gsub(killsay, "$name", entity.get_player_name(victim))
            client.log(killsay)
            client.exec(killsay)
        end
    end

    if ui.get(trashtalk) then
        if victim == local_player and attacker ~= local_player then
            last_killer = attacker
            local deadtalk_messages = {
                "say Ð Ð…Ð Âµ Ð Ñ—Ð Ñ•Ð Ð…Ð Ñ‘Ð Ñ˜Ð Â°Ð¡Ð‹ Ð Ñ”Ð Â°Ð Ñ” Ð ÂµÐ Ñ˜Ð¡Ñ“ Ð Ð†Ð ÂµÐ Â·Ð ÂµÐ¡â€š",
                "say Ð Â°Ð Â° Ð¡Ð Ð Ñ—Ð¡Ð‚Ð Ñ•Ð¡ÐƒÐ¡â€šÐ Ñ• Ð Â·Ð Â°Ð Â±Ð¡â€¹Ð Â» Ð¡Ð‚Ð ÂµÐ Â·Ð Ñ‘Ð Ñ” Ð¡Ð‚Ð ÂµÐ¡ÐƒÐ Ð…Ð¡Ñ“Ð¡â€šÐ¡ÐŠ",
                "say Ð Ð…Ð¡Ñ“ Ð¡â€°Ð¡Ð Ð¡Ð‚Ð ÂµÐ¡ÐƒÐ Ð…Ð¡Ñ“ Ð Ñ‘ Ð Ñ—Ð Ñ‘Ð Â·Ð Ò‘Ð Â° Ð ÂµÐ Ñ˜Ð¡Ñ“"
            }
            for _, msg in ipairs(deadtalk_messages) do
                client.log(msg)
                client.exec(msg)
            end
        end
    end

    if ui.get(trashtalk) and last_killer and victim == last_killer and victim ~= local_player then
        local taunt = "say 1, Ð ÂµÐ Â±Ð Â°Ð¡â€šÐ¡ÐŠ Ð¡ÐƒÐ Â»Ð Ñ‘Ð Â»Ð¡ÐƒÐ¡Ð"
        client.log(taunt)
        client.exec(taunt)
        last_killer = nil
    end
end

math.random(); math.random(); math.random()

client.set_event_callback("player_death", on_player_death)

function string.trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function load_and_fade_image()
    local image_url = "https://i.postimg.cc/hP8xtmW3/OIP.png"

    http.get(image_url, function(success, response)
        if not success or response.status ~= 200 then return end

        local js_code = [[
            let image_panel = $.CreatePanel('Panel', $.GetContextPanel(), 'ImagePanel');
            image_panel.style.width = '100%';
            image_panel.style.height = '100%';
            image_panel.style.backgroundColor = 'rgba(0, 0, 0, 0)';
            image_panel.style.align = 'center center';
            image_panel.style.verticalAlign = 'center';
            image_panel.style.flowChildren = 'down';
            image_panel.SetDraggable(true);

            let top_label = $.CreatePanel('Label', image_panel, 'TopText');
            top_label.text = 'powered by kocmoc';
            top_label.style.fontSize = '18px';
            top_label.style.fontWeight = 'bold';
            top_label.style.fontFamily = 'Arial, sans-serif';
            top_label.style.color = 'red';
            top_label.style.align = 'center center';
            top_label.style.marginBottom = '8px';
            top_label.style.opacity = '0';

            let image = $.CreatePanel('Image', image_panel, 'MyImage');
            image.SetImage(']] .. image_url .. [[');
            image.style.width = '600px';
            image.style.height = '850px';
            image.style.align = 'center center';
            image.style.verticalAlign = 'center';
            image.style.opacity = '0';
            image.style.marginBottom = '12px';

            let spinner_container = $.CreatePanel('Panel', image_panel, 'SpinnerContainer');
            spinner_container.style.width = '40px';
            spinner_container.style.height = '40px';
            spinner_container.style.borderRadius = '50%';
            spinner_container.style.align = 'center center';
            spinner_container.style.opacity = '0';
            spinner_container.style.overflow = 'noclip';
            spinner_container.rotation = 0;

            let dot = $.CreatePanel('Panel', spinner_container, 'RedDot');
            dot.style.width = '6px';
            dot.style.height = '16px';
            dot.style.borderRadius = '3px';
            dot.style.backgroundColor = 'red';
            dot.style.position = '0px 12px 0px';

            let bottom_label = $.CreatePanel('Label', image_panel, 'BottomText');
            bottom_label.text = 'AimSense Resolver Cracked by Kha0sK1ng';
            bottom_label.style.fontSize = '24px';
            bottom_label.style.fontWeight = 'bold';
            bottom_label.style.fontFamily = 'Arial, sans-serif';
            bottom_label.style.color = 'red';
            bottom_label.style.align = 'center center';
            bottom_label.style.marginTop = '10px';
            bottom_label.style.opacity = '0';

            let discord_label = $.CreatePanel('Label', image_panel, 'DiscordText');
            discord_label.text = 'discord.gg/aimsense / crack discord.gg/Kha0sK1ng';
            discord_label.style.fontSize = '16px';
            discord_label.style.fontWeight = 'normal';
            discord_label.style.fontFamily = 'Arial, sans-serif';
            discord_label.style.color = '#CCCCCC';
            discord_label.style.align = 'center center';
            discord_label.style.marginTop = '4px';
            discord_label.style.opacity = '0';

            function rotate_spinner() {
                if (!spinner_container || !spinner_container.IsValid()) return;
                spinner_container.rotation += 6;
                if (spinner_container.rotation >= 360) spinner_container.rotation = 0;
                spinner_container.style.transform = 'rotateZ(' + spinner_container.rotation + 'deg)';
                $.Schedule(0.03, rotate_spinner);
            }

            function animate_label_color() {
                if (!bottom_label || !bottom_label.IsValid()) return;
                let colors = ['red', 'white'];
                let index = 0;
                function loop() {
                    if (!bottom_label || !bottom_label.IsValid()) return;
                    bottom_label.style.color = colors[index];
                    index = (index + 1) % colors.length;
                    $.Schedule(0.6, loop);
                }
                loop();
            }

            function spawn_snowflake() {
                let flake = $.CreatePanel('Panel', image_panel, '');
                flake.style.width = '4px';
                flake.style.height = '4px';
                flake.style.borderRadius = '50%';
                flake.style.backgroundColor = 'white';
                flake.style.position = Math.floor(Math.random() * 100) + '% -10px 0';
                flake.style.zIndex = '1000';
                let x = Math.floor(Math.random() * 100);
                let y = -10;
                let speed = 1 + Math.random() * 2;

                function fall() {
                    if (!flake || !flake.IsValid()) return;
                    y += speed;
                    flake.style.position = x + '% ' + y + 'px 0';
                    if (y < 1000) {
                        $.Schedule(0.03, fall);
                    } else {
                        flake.DeleteAsync(0.0);
                    }
                }
                fall();
            }

            function snow_loop() {
                spawn_snowflake();
                $.Schedule(0.1, snow_loop);
            }

            function fade_in() {
                let steps = 20;
                let duration = 0.5;
                let interval = duration / steps;
                let step = 0;
                function update() {
                    if (step <= steps && image.IsValid()) {
                        let opacity = step / steps;
                        image.style.opacity = opacity.toString();
                        top_label.style.opacity = opacity.toString();
                        spinner_container.style.opacity = opacity.toString();
                        bottom_label.style.opacity = opacity.toString();
                        discord_label.style.opacity = opacity.toString();
                        image_panel.style.backgroundColor = 'rgba(0, 0, 0, ' + (opacity * 0.7).toFixed(2) + ')';
                        step++;
                        if (step <= steps) {
                            $.Schedule(interval, update);
                        }
                    }
                }
                update();
                rotate_spinner();
                animate_label_color();
                snow_loop();
            }

            function fade_out() {
                let steps = 20;
                let duration = 0.5;
                let interval = duration / steps;
                let step = 0;
                function update() {
                    if (step <= steps && image.IsValid()) {
                        let opacity = 1 - (step / steps);
                        image.style.opacity = opacity.toString();
                        top_label.style.opacity = opacity.toString();
                        spinner_container.style.opacity = opacity.toString();
                        bottom_label.style.opacity = opacity.toString();
                        discord_label.style.opacity = opacity.toString();
                        image_panel.style.backgroundColor = 'rgba(0, 0, 0, ' + (opacity * 0.7).toFixed(2) + ')';
                        step++;
                        if (step <= steps) {
                            $.Schedule(interval, update);
                        } else {
                            if (image_panel.IsValid()) {
                                image_panel.DeleteAsync(0.0);
                            }
                        }
                    }
                }
                update();
            }

            fade_in();
            $.Schedule(6.0, function() {
                if (image_panel.IsValid()) {
                    fade_out();
                }
            });
        ]]

        panorama.loadstring(js_code, "CSGOMainMenu")()
    end)
end

load_and_fade_image()

