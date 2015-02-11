--[[

	Different functions relating to Meddler powers.

]]


local function Bless( tile , meddler )
	if not tile then
		dialogue( "lack_target" )
		return false

	elseif meddler.eminence <= 0 then
		dialogue( "lack_emi")
		return false

	else
		tile.rate = math.ceil( tile.rate * 1.5 )
		tile.timer = 4
		return true
	end
end


local function create_race( meddler , race_creation_flags )
	local rcf = race_creation_flags

	if meddler.eminence <= 0 then
		dialogue( "lack_emi" )
		return false

	else
		dialogue( meddler.name.." is creating a race!" )
		rcf._status = true
		rcf._toplevel = true
		rcf.race = { name = "None" , mental = "None" , culture = "None" , phys = {} }
		rcf.race.phys.head = { value=1 , build=Normal , mod=None }
		rcf.race.phys.torso = { value=1 , base="Skin" , build="Medium" , mod="None" }
		rcf.race.phys.upper_limbs = { value=1 , build="Normal" , mod="None" , base="Sapien" }
		rcf.race.phys.lower_limbs = { value=1 , build="Normal" , mod="None" , base="Sapien" }


		return true
	end
end


local function Sacrifice( tile , meddler )
	if not tile then
		dialogue( "lack_target" )
	else
		local unit = tile:get_resident()
		if not unit then
			dialogue( "lack_target")
			return false
		else
			tile:set_ocpied()
			meddler:change_emi( 5 )
			return true
		end
	end
end


local function Curse( tile )
	if not tile then
		dialogue( "lack_target")
		return false
	else
		tile.rate = 0
		tile.timer = 4
		return true
	end
end

local function Change_land( tile )
	--stuff
end




powers = {}

function powers:resolve( key , tile , meddler , race_creation_flags )
	local is_player_done = false

	if give_tree then
		if key == 'l' then 
			is_player_done = create_race( meddler , race_creation_flags )

		elseif key == 'b' then 
			is_player_done = Bless( tile , meddler )
		end

	elseif take_tree then		
		if key == 'l' then
			is_player_done = Sacrifice( tile , meddler )

		elseif key == 'b' then
			is_player_done = Curse( tile )
		end

	elseif alter_tree then
		is_player_done = true
		--if key == 'l' then change_life()
		--if key == 'g' then Change_land() end
		--elseif key == 'a' then change_law()
		--end
	end
	return is_player_done
end


--[[
	'Bright'	--0,4,0
	,'Free'		--1,3,0
	,'Weary'	--2,2,0
	,'Feared'	--3,1,0
	,'Dark'		--4,0,0
	,'Tortured'	--3,0,1
	,'Mad'		--2,0,2
	,'Cosmic'	--1,0,3
	,'Unknowable'--0,0,4
	,'Old'		--0,1,3
	,'Primal'	--0,2,2
	,'Benevolent'--0,3,1
	,'Grey'		--1,2,1
	,'Chained'	--2,1,1
	,'Knowing'	--1,1,2
	]]





--[[
function powers.Harvest( city , atlas.world , med )
	local x , y = city.location
	powers.inf( 10 , med )

	for i=0,2 do
		for j=0,2 do
			if atlas.world[ i+x ][ j+y ].type == 'farm' then
				city.wealth = city.wealth + 50
			end
		end
	end
end

function powers.Observe()
	stuff
end


function powers.Wander()
	--all races created by this Meddler are granted +1 activity for the turn
end


function powers.Warp( med , world , loc_a , loc_b ) --switches any two tiles of the world map
	powers.inf( 10 , med )

	local temp = world[ loc_a.x ][ loc_a.y ]
	world[ loc_a.x ][ loc_a.y ] = world[ loc_b.x ][ loc_b.y ]
	world[ loc_b.x ][ loc_b.y ] = temp
end



function powers.inf( cost , med )
	med.influence = med.influence - cost
end
--]]


return powers