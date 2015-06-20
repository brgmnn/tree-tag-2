--require('lib.statcollection')



--[[



replace fortify

-- http://hastebin.com/henocemifa.php    fishing for murfle







]]






Testing = false --Useful for turning off stat-collection when developing

--if not Testing then --Only send stats when not testing
--  statcollection.addStats({
--    modID = 'f2bd64d63f4cebf6cf1dae7f345ce7f6' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
--  })
--end



if CTreeTagGameMode == nil then
	CTreeTagGameMode = class({})
	--CTreeTagGameMode = {}
	--CTreeTagGameMode.szEntityClassName = "treetag"
	--CTreeTagGameMode.szNativeClassName = "dota_base_game_mode"
	--CTreeTagGameMode.__index = CTreeTagGameMode
end


function Precache( context )


	PrecacheResource("model_folder", "models/items/furion", context)
	PrecacheResource("particle_folder", "econ/items/natures_prophet", context)

	PrecacheResource("model_folder", "models/items/shredder", context)
	PrecacheResource("particle_folder", "econ/items/timbersaw", context)

	PrecacheResource("model_folder", "models/items/batrider", context)
	PrecacheResource("particle_folder", "econ/items/batrider", context)

	-- required for cosmetic shit
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )


	-- building helper
	PrecacheResource("particle_folder", "particles/buildinghelper", context)




	PrecacheResource("model_folder", "particles/units/heroes/hero_techies", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_techies", context)
	


    PrecacheUnitByNameSync("npc_dota_goodguys_tower1_top", context)

    PrecacheUnitByNameSync("npc_dota_hero_treant", context)
    PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
    PrecacheUnitByNameSync("npc_dota_hero_techies", context)
    PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
    PrecacheUnitByNameSync("npc_dota_hero_furion", context)
    PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
    PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
    PrecacheUnitByNameSync("npc_dota_hero_axe", context)
    PrecacheUnitByNameSync("npc_dota_hero_lina", context)
    PrecacheUnitByNameSync("npc_dota_hero_venomancer", context)
    PrecacheUnitByNameSync("npc_dota_hero_riki", context)

    PrecacheUnitByNameSync("npc_dota_hero_rattletrap", context)

    PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
    PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)

    PrecacheUnitByNameSync("npc_dota_hero_beastmaster", context)
    PrecacheUnitByNameSync("npc_dota_beastmaster_hawk", context)

    PrecacheUnitByNameSync("npc_dota_hero_warlock", context)

    PrecacheResource( "sound", "sounds/items/item_handofmidas.vsnd", context )
    PrecacheResource( "sound", "sound/items/item_handofmidas.vsnd", context )
    PrecacheResource( "sound", "sound/items/item_handofmidas.wav", context )
    PrecacheResource( "sound", "item_handofmidas", context )

    PrecacheResource( "model", "models/buildings/building_plain_reference.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_statue010.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_ancient_lightbeams.vmdl", context )
    PrecacheResource( "model", "models/props_structures/tower_good_dest_lvl1.vmdl", context )


    PrecacheResource( "model", "models/items/furion/treant/primeval_treant/primeval_treant.vmdl", context )
    PrecacheResource( "model", "models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl", context )
    

    PrecacheResource( "model", "models/props_structures/good_base_wall006.vmdl", context )


    PrecacheResource( "model", "models/items/furion/treant/father_treant/father_treant.vmdl", context )
    PrecacheResource( "model", "models/items/furion/treant/treant_cis/treant_cis.vmdl", context )




    PrecacheResource( "model", "models/props_rock/riveredge_rock006a.vmdl", context )

    -- chronoboost effect
    PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_primal_split_fire_trail.vpcf", context )

    -- riki summon spirit effect
    PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_primal_split_storm_trail_b.vpcf", context )


    -- timber explode effect
    PrecacheResource( "particle", "particles/econ/events/coal/coal_projectile_explosion.vpcf", context )


    PrecacheResource( "model", "models/props_structures/good_barracks_melee002_lvl2.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_barracks_melee002_lvl1.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_barracks_melee001.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_barracks_melee002.vmdl", context )

    -- flying camera for scan
    PrecacheResource( "model", "models/courier/f2p_courier/f2p_courier_flying.vmdl", context )

    PrecacheResource( "particle", "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_heal_wispb.vpcf", context )

    PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_suicide.vpcf", context )


    PrecacheResource( "model", "models/props_structures/good_ancient_fountain001_water.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_ancient_fountain001.vmdl", context )

    PrecacheResource( "model", "models/items/courier/tinkbot/tinkbot.vmdl", context )
    PrecacheResource( "model", "models/items/courier/shagbark/shagbark.vmdl", context )
    PrecacheResource( "model", "models/heroes/furion/treant.vmdl", context )
    

    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_ambient_mane_blue.vpcf", context )


    PrecacheResource( "particle", "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_orbit/courier_trail_orbit_d.vpcf", context )



    PrecacheResource( "particle", "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf", context )


    PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_firefly_head.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_firefly_path.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_firefly.vpcf", context )

    
    PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_enchant_slow_grass_long.vpcf", context )


    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context )


    PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_static_link_beam.vpcf", context )


    PrecacheResource( "particle", "particles/econ/courier/courier_trail_04/courier_trail_04.vpcf", context )


    PrecacheResource( "particle", "particles/items2_fx/true_sight_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/items2_fx/smoke_of_deceit_buff.vpcf", context )

    PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/dire_fx/tower_bad_face_end_explode.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion_trail.vpcf", context )

    PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_battle_hunger_b.vpcf", context )

end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CTreeTagGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CTreeTagGameMode:InitGameMode()
	print( "Tree Tag is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
	
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( CTreeTagGameMode, 'OnEntityKilled' ), self )

	--ListenToGameEvent('player_fullyjoined', Dynamic_Wrap(CTreeTagGameMode, 'OnPlayerLoaded'), self)
	--ListenToGameEvent("player_connect_full", Dynamic_Wrap(CTreeTagGameMode, "OnPlayerLoaded"), self)  -- THIS ONE

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseUniversalShopMode( false )

    GameRules:SetHeroSelectionTime( 20.0 ) -- hero selection is not skipped unless this is set to 0 it seems
	GameRules:SetPreGameTime( 35.0 )
	GameRules:SetPostGameTime( 30.0 )
	GameRules:SetTreeRegrowTime( 5.0 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )


    GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")

	--GameRules:SetHeroMinimapIconSize( 400 )
	--GameRules:SetCreepMinimapIconScale( 0.7 )
	--GameRules:SetRuneMinimapIconScale( 0.7 )



	--GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	--GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	--GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	--GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)

	--GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(20)

	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)

	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	-- gamerules:getgamemodeentity = gamemod okioki
    --GameMode:SetTopBarTeamValuesOverride ( true )    -- Override the top bar values to show your own settings instead of total deaths
    --GameMode:SetCameraDistanceOverride( 1404.0 )

    GameRules:SetRuneSpawnTime(30)

    GameRules:SetFirstBloodActive(false)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)

end

needshero = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
needshero[0] = true

starttime = -1


--nonstatsgame = false;
nonstatsgame = true;



function objectivereached(keys)
    --tprint(keys);
    --print("---------")


    print("high scores temporarily disabled")



    if nonstatsgame then
    	print("Stats not recorded this game. Only 5v2 games are recorded for high scores")
        return nil;
    end

    local rad = 0;
    local dir = 0;

    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 2 then
            rad = rad + 1;
        elseif hero:GetTeam() == 3 then
        	dir = dir + 1;
        end
    end

    if rad==5 and dir==2 then
    else
    	nonstatsgame = true;
    	print("nonstatsgame: high score not recorded")
    	return nil;
    end


    local pid = keys.caster:GetPlayerOwnerID();
    local objective = keys.objectivename;

    local newscore = GameRules:GetDOTATime(false,false);

    --local newscore = 91987


            --tt_mine10
            --tt_turret10
            --tt_mineandturret10
            --tt_level5set


    if objective=="mine10" then
        print("Player "..pid.." reached "..objective.." after "..newscore.." secs");
        FireGameEvent( 'tt_mine10', { player_ID = pid, score = newscore } );
		keys.caster:GetOwner().mine10=true;
        -- check for turret 10 and then fire tt_mineandturret10
        if keys.caster:GetOwner().turret10 then
        	FireGameEvent( 'tt_mineandturret10', { player_ID = pid, score = newscore } );
        	print("Player "..pid.." reached mineandturret after "..newscore.." secs");
        end

    elseif objective=="turret10" then
        print("Player "..pid.." reached "..objective.." after "..newscore.." secs");
        FireGameEvent( 'tt_turret10', { player_ID = pid, score = newscore } );
		keys.caster:GetOwner().turret10=true;
        -- check for mine 10 and then fire tt_mineandturret10
        if keys.caster:GetOwner().mine10 then
        	FireGameEvent( 'tt_mineandturret10', { player_ID = pid, score = newscore } );
        	print("Player "..pid.." reached mineandturret after "..newscore.." secs");
        end


    end

    -- do the item check bullshit on some item acquired event for dire level5set

end

--  have players 8 and 9 been swapped to radiant?
notswapped8 = true
notswapped9 = true
notswapped8a = true
notswapped9a = true



function CTreeTagGameMode:OnEntityKilled( event )
    local killedUnit = EntIndexToHScript( event.entindex_killed )

    if killedUnit and killedUnit:IsRealHero() then
        local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
        newItem:SetPurchaseTime( 0 )
        newItem:SetPurchaser( killedUnit )
        local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
        tombstone:SetContainedItem( newItem )
        tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
        FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true ) 
    end
end


-- Evaluate the state of the game
function CTreeTagGameMode:OnThink()


	--print(GameRules:GetDOTATime(false,false))


	--[[if notswapped8a then
        local owner = PlayerResource:GetPlayer(8);
        if owner then
	        owner:SetTeam(2);
        	notswapped8a=false;
    	end
	end
	if notswapped9a then
        local owner = PlayerResource:GetPlayer(9);
        if owner then
	        owner:SetTeam(2);
        	notswapped9a=false;
    	end
	end]]


	-- temporarily disabled
    --[[if GameRules:State_Get() >= DOTA_GAMERULES_STATE_HERO_SELECTION then
		j = {}
		for i=0,9 do
		j[tostring(i)] = PlayerResource:GetSteamAccountID(i)
		end
		FireGameEvent("stat_collection_steamID", j)
	end]]


	local currentGameTime = GameRules:GetDOTATime(false,false);

	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_wisp")) do

        if not hero:IsAlive() then
            print("pre-A");
            hero:Destroy();
        elseif hero==nil then
            print("a");
        elseif hero:GetPlayerOwner()==nil then
            --print("b");
        elseif hero:GetPlayerOwner():GetPlayerID()==nil then
            print("c");
        else
            --print("d");

            local id = hero:GetPlayerOwner():GetPlayerID()
            if id ~= -1 then

           		hero:SetGold(0, false)
               	if hero:GetTeamNumber() == 2 then
                	if starttime>-1 and currentGameTime >= 60 then
                        local powner = hero:GetPlayerOwner();
                		local zxc = PlayerResource:ReplaceHeroWith(id,"npc_dota_hero_treant",15,0)
                        zxc:SetOwner(powner)

    				    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities 1 through 5, dont level ulti at level '1'
    				    zxc:GetAbilityByIndex(1):SetLevel(1)
    				    zxc:GetAbilityByIndex(2):SetLevel(1)
    				    zxc:GetAbilityByIndex(3):SetLevel(1)

    				    zxc:GetAbilityByIndex(4):SetLevel(1)
    				    zxc:GetAbilityByIndex(4):ToggleAutoCast()

    				    zxc:GetAbilityByIndex(5):SetLevel(1)    -- hidden tree cutter


    				    zxc:SetAbilityPoints(0)

    				    itz = CreateItem("item_place_mine", zxc, zxc)
    				    itz:SetPurchaseTime(itz:GetPurchaseTime()-12)
    				    zxc:AddItem(itz)

    				    itz2 = CreateItem("item_place_wall", zxc, zxc)
    				    itz2:SetPurchaseTime(itz2:GetPurchaseTime()-12)
    				    zxc:AddItem(itz2)

    				    itz3 = CreateItem("item_place_turret", zxc, zxc)
    				    itz3:SetPurchaseTime(itz3:GetPurchaseTime()-12)
    				    zxc:AddItem(itz3)

    				    itz4 = CreateItem("item_place_well", zxc, zxc)
    				    itz4:SetPurchaseTime(itz4:GetPurchaseTime()-12)
    				    zxc:AddItem(itz4)

    					needshero[id] = false
    				elseif needshero[id] then
    					hero:AddAbility("picktree")
    					abzx = hero:FindAbilityByName("picktree")
    					abzx:SetAbilityIndex(0)
    					abzx:SetLevel(1)
    					abzx:StartCooldown(5)

    					hero:AddAbility("pickfurion")
    					abzx2 = hero:FindAbilityByName("pickfurion")
    					abzx2:SetAbilityIndex(1)
    					abzx2:SetLevel(1)
    					abzx2:StartCooldown(5)

                        hero:AddAbility("pickveno")
                        abzx3 = hero:FindAbilityByName("pickveno")
                        abzx3:SetAbilityIndex(1)
                        abzx3:SetLevel(1)
                        abzx3:StartCooldown(5)

    					hero:AddAbility("pickriki")
    					abzx4 = hero:FindAbilityByName("pickriki")
    					abzx4:SetAbilityIndex(1)
    					abzx4:SetLevel(1)
    					abzx4:StartCooldown(5)
    					--hero:GetAbilityByIndex(1):SetLevel(1)


    					--hero:GetAbilityByIndex(0):SetHidden(true)
       					hero:SetAbilityPoints(0)
    					needshero[id] = false
    					--print("azpp: "..hero:GetTeamNumber())
       				end

                --elseif id<7 then
               	elseif hero:GetTeamNumber() == 3 then

                	if starttime>-1 and currentGameTime >= 60 then
    					local zxc = PlayerResource:ReplaceHeroWith(id,"npc_dota_hero_shredder",0,0)

    				    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities exclude ulti on lvl '1',  treerape
    				    zxc:GetAbilityByIndex(1):SetLevel(1)    -- gold hit
    				    zxc:GetAbilityByIndex(2):SetLevel(1)    -- scan
    				    zxc:GetAbilityByIndex(3):SetLevel(1)    -- invis
    				    zxc:GetAbilityByIndex(4):SetLevel(1)    -- true sight
    				    zxc:GetAbilityByIndex(5):SetLevel(1)    -- chakram

    					--zxc:GetAbilityByIndex(4):SetLevel(1)	-- attribute bonus (ability6 on timbersav)

    					itz = CreateItem("item_travel_boots", zxc, zxc)
    					itz:SetPurchaseTime(itz:GetPurchaseTime()-12)
    					zxc:AddItem(itz)



    					itz2 = CreateItem("item_chop_tree", zxc, zxc)
    					itz2:SetPurchaseTime(itz2:GetPurchaseTime()-12)
    					zxc:AddItem(itz2)
    					

    					
    					
    					zxc:SetAbilityPoints(0)
    					needshero[id] = false
    				elseif needshero[id] then


    					--[[if notswapped8 and id==8 then
    	        			local owner = hero:GetOwner();
    				        if owner then
    					        owner:SetTeam(2);
    					        hero:SetTeam(2);
    				        	notswapped8=false;
    				    	end
    						hero:AddAbility("picktree")
    						abzx = hero:FindAbilityByName("picktree")
    						abzx:SetAbilityIndex(0)
    						abzx:SetLevel(1)
    						abzx:StartCooldown(5)

    						hero:AddAbility("pickfurion")
    						abzx2 = hero:FindAbilityByName("pickfurion")
    						abzx2:SetAbilityIndex(1)
    						abzx2:SetLevel(1)
    						abzx2:StartCooldown(5)

    	   					hero:SetAbilityPoints(0)
    						needshero[id] = false
    					elseif notswapped9 and id==9 then
    	        			local owner = hero:GetOwner();
    				        if owner then
    					        owner:SetTeam(2);
    					        hero:SetTeam(2);
    				        	notswapped9=false;
    				    	end
    						hero:AddAbility("picktree")
    						abzx = hero:FindAbilityByName("picktree")
    						abzx:SetAbilityIndex(0)
    						abzx:SetLevel(1)
    						abzx:StartCooldown(5)

    						hero:AddAbility("pickfurion")
    						abzx2 = hero:FindAbilityByName("pickfurion")
    						abzx2:SetAbilityIndex(1)
    						abzx2:SetLevel(1)
    						abzx2:StartCooldown(5)

    	   					hero:SetAbilityPoints(0)
    						needshero[id] = false
    					else]]
    						hero:AddAbility("picktimber")
    						abzx = hero:FindAbilityByName("picktimber")
    						abzx:SetAbilityIndex(0)
    						abzx:SetLevel(1)
    						abzx:StartCooldown(35)

    						hero:AddAbility("pickbatrider")
    						abzx2 = hero:FindAbilityByName("pickbatrider")
    						abzx2:SetAbilityIndex(1)
    						abzx2:SetLevel(1)
    						abzx2:StartCooldown(35)


    						--hero:GetAbilityByIndex(1):SetLevel(1)

    						--hero:GetAbilityByIndex(1):SetHidden(true)
    	   					hero:SetAbilityPoints(0)
    						needshero[id] = false
    						print("azpp: "..hero:GetTeamNumber())
    					--end
    				end
                end
            end

        end
    end



	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if starttime == -1 then
			starttime = GameRules:GetGameTime()
		end

		--for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_treant")) do
	    --    hero:AddExperience(2,false)
	    --end
		--for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_shredder")) do
	    --    hero:AddExperience(2,false)
	    --end
		--for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_abaddon")) do
	    --    hero:AddExperience(2,false)
	    --end



		--print( "Template addon script is running." )
		
		self:_CheckForDefeat()


	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end


local gameending = "not now"

function ending()
	return gameending
end

ended=false
warnA=false
warnB=false
warnC=false

function CTreeTagGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end
	local currentGameTime = GameRules:GetDOTATime(false,false);

	local bAllPlayersDead = true
	local bHasPlayers = false

	local aAllPlayersDead = true
	local aHasPlayers = false

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				bAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero then
					bHasPlayers = true;
					if hero:IsAlive() then
						bAllPlayersDead = false
					end
				end
			end
		elseif PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				aAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero then
					aHasPlayers = true;
					if hero:IsAlive() then
						aAllPlayersDead = false
					end
				end
			end
		end
	end

	--fb only end if everyone is dead or gametime = X
	--if bAllPlayersDead or not self._entAncient or self._entAncient:GetHealth() <= 0 then
	if starttime > -1 then
		if currentGameTime >= 39 then
			if bAllPlayersDead and bHasPlayers then
				print("Dire lose: all dead")
				--GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				return
			end
			if aAllPlayersDead and aHasPlayers then
				print("Rad lose: all dead")
				--GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				return
			end
		end
	

		-- auto 2 min win for testing
		--if GameRules:GetGameTime()-starttime >= 120 then
		--	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
		--end


		if currentGameTime >= 1159 then
			if not warnB then
				local messageinfo = {message = "Dire, prepare to kill the World Tree!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnB=true
			end
		end
		if currentGameTime >= 1164 then
			if not warnC then
				local messageinfo = {message = "Radiant, prepare to heal the World Tree!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnC=true
			end
		end
		if currentGameTime >= 1169 then
			if not warnA then
				local messageinfo = {message = "Tree Active in 30s!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnA=true
			end
		end

		if currentGameTime >= 1199 then
			if not ended then
					print("check tree")
				for _,bigtree in pairs( Entities:FindAllByName("bigtree")) do
					bigtree:RemoveModifierByName("waitingforend")
					print("tree1")
				end
				ended=true
				local messageinfo = {message = "Save the tree!", duration = 10}
				FireGameEvent("show_center_message",messageinfo) 
			end
			return
		end
	end
end