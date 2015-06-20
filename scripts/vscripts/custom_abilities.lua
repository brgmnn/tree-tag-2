require("addon_game_mode")
require("CosmeticLib")

moditem = nil

function placeGhost(keys)

    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;
    blocking_counter = 0;
    groundclickpos = GetGroundPosition(keys.target_points[1], nil);
    xpos = GridNav:WorldToGridPosX(groundclickpos.x);
    ypos = GridNav:WorldToGridPosY(groundclickpos.y);
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos);
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos);

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Cannot build there" } )
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        return nil
    end





    local player = keys.caster:GetPlayerOwner()

    if player == nil then
        return nil
    end


    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)




    if player.modelGhostDummy ~= nil then
        player.modelGhostDummy:RemoveSelf()
        player.modelGhostDummy = nil
    end


    local OutOfWorldVector = Vector(11000,11000,0)


    player.modelGhostDummy = CreateUnitByName(keys.unitname, OutOfWorldVector, false, nil, nil, keys.caster:GetTeam())
    local mgd = player.modelGhostDummy -- alias
    mgd.isBuildingDummy = true -- store this for later use

    local modelParticle = ParticleManager:CreateParticleForPlayer("particles/buildinghelper/ghost_model.vpcf", PATTACH_ABSORIGIN, mgd, player)

    player.ghostParticle = modelParticle;

    if modelParticle ~= nil then
        ParticleManager:SetParticleControlEnt(modelParticle, 1, mgd, 1, "follow_origin", mgd:GetAbsOrigin(), true)                      
        ParticleManager:SetParticleControl(modelParticle, 3, Vector(40,0,0))   -- alpha 0-100
        ParticleManager:SetParticleControl(modelParticle, 4, Vector(keys.unitscale,0,0))  -- scale 0-1
    end

    local centerX = groundclickpos.x;
    local centerY = groundclickpos.y;
    local z = groundclickpos.z;

    local vBuildingCenter = Vector(centerX,centerY,z)


    if modelParticle ~= nil then
        -- move model ghost particle
        ParticleManager:SetParticleControl(modelParticle, 0, vBuildingCenter)

        -- this stuff is not done yet. Recolor model green probably best
        if RECOLOR_GHOST_MODEL then
            if areaBlocked then
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,0,0))   
            else
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(0,255,0))
            end
        else
            ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,255,255)) -- Draws the ghost with the original colors
        end
    end


end

function removeGhost(keys)
    local player = keys.caster:GetPlayerOwner()

    if player ~= nil then

        if player.ghostParticle ~= nil then
            ParticleManager:DestroyParticle(player.ghostParticle, true)
            player.ghostParticle = nil
        end
        if player.modelGhostDummy ~= nil then
            player.modelGhostDummy:RemoveSelf()
            player.modelGhostDummy = nil
        end
    
    end
end


function placeBuilding(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end

    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then

        --tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, keys.caster, keys.caster, keys.caster:GetPlayerOwner():GetTeam() ) 

        --tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, nil, nil, keys.caster:GetTeam() ) 
        --tower:SetContext("tagtype", "npc_treetag_building_mine", 0)
        --tower:SetContext("tagtypelevel", "1", 0)
        --tower:SetAngles(0.0,90.0,0.0)
        --tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());

        tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_mine", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetAngles(0.0,90.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end

        --tower:SetControllableByPlayer(keys.caster:GetPlayerOwner():GetPlayerID(), true);
        keys.caster:GetItemInSlot(0):SetActivated(false)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Cannot build there" } )
        keys.caster:GetItemInSlot(0):StartCooldown(0.5)
    end
end

function makeuncontrollable(unit)
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
        if PlayerResource:IsValidPlayer(nPlayerID) then 
            unit:SetControllableByPlayer(nPlayerID, true);
        end
    end
end

function spawnghost(keys)
    print("spawning ghost");
    if keys.caster:GetClassname() == "npc_dota_hero_furion" then
        --helper = CreateUnitByName("npc_treetag_radiant_ghost_furion", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster,keys.caster:GetTeam() ) 


        helper = CreateUnitByName("npc_treetag_radiant_ghost_furion", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    else 
        helper = CreateUnitByName("npc_treetag_radiant_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    end
end

function spawnghostdire(keys)
    print("spawning ghost");
    helper = CreateUnitByName("npc_treetag_dire_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
    
    if helper ~= nil then
        helper:SetAngles(0.0,90.0,0.0)
        helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
        helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
    end
end

function placeWall(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    --PLACED_BUILDING_RADIUS = 70.0;
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    --print("LALALALA  yes: " .. groundclickpos.x .. "," .. groundclickpos.y)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    --keys.target_points[1].x = GridNav:GridPosToWorldCenterX(xpos)
    --keys.target_points[1].y = GridNav:GridPosToWorldCenterY(ypos)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
        --print("LALALALA  yes: " .. xpos .. "," .. ypos)
    else
        --print("LALALALA  no: " .. xpos .. "," .. ypos)
        blocking_counter = blocking_counter + 1
    end


    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_wall_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        print("AA: "..keys.caster:GetPlayerID())

        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_wall", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            learnabilities(tower)
        end


        --treething = CreateUnitByName("npc_treetag_faggot", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        --if treething ~= nil then
        --    treething:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
        --    treething:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
        --end

    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Cannot build there" } )
    end
end

function replaceunit(keys)
    local unitclassname = keys.UnitName;
    local pos = keys.caster:GetAbsOrigin()

    local ahero = keys.caster:GetPlayerOwner():GetAssignedHero()
    local uowner = keys.caster:GetOwner()
    local teamnum = keys.caster:GetTeamNumber()
    local pid = keys.caster:GetPlayerOwnerID()

    keys.caster:Destroy()

    local newunit = CreateUnitByName(unitclassname, pos, false, ahero, uowner, teamnum ) 

    if newunit ~= nil then
        newunit:SetOwner(ahero);
        newunit:SetControllableByPlayer(pid, true);
        learnabilities(newunit)
    end
end

function learnyourfuckingspells(keys)
    tprint(keys)
    local nunit = EntIndexToHScript(keys.caster_entindex)
    for aaaai=0, nunit:GetAbilityCount()-1 do
        local aab = nunit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            aab:SetLevel(1)
        end
    end
end

function learnabilities(unit)
    for aaaai=0, unit:GetAbilityCount()-1 do
        local aab = unit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            aab:SetLevel(1)
        end
    end
end

function placeTurret(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    groundclickpos = GetGroundPosition(attempt_place_location, nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then

    else
        blocking_counter = blocking_counter + 1
    end


    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        --tower = CreateUnitByName("npc_treetag_building_turret_1", groundclickpos, false, nil, nil, keys.caster:GetTeam() ) 
        
        --tower:SetContext("tagtype", "npc_treetag_building_turret", 0)
        --tower:SetContext("tagtypelevel", "1", 0)
        --tower:SetAngles(0.0,90.0,0.0)
        --tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
        --tower:SetControllableByPlayer(keys.caster:GetPlayerOwner():GetPlayerID(), true);

        tower = CreateUnitByName("npc_treetag_building_turret_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_turret", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Cannot build there" } )
    end
end

function placewell(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    groundclickpos = GetGroundPosition(attempt_place_location, nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end


    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        --tower = CreateUnitByName("npc_treetag_building_well_1", groundclickpos, false, nil, nil, keys.caster:GetTeam() ) 
        
        --tower:SetContext("tagtype", "npc_treetag_building_well", 0)
        --tower:SetContext("tagtypelevel", "1", 0)
        --tower:SetAngles(0.0,90.0,0.0)
        --tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
        --tower:SetControllableByPlayer(keys.caster:GetPlayerOwner():GetPlayerID(), true);


        tower = CreateUnitByName("npc_treetag_building_well_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_well", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetAngles(0.0,90.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Cannot build there" } )
    end
end




function placeTree(keys)
    if keys.caster:HasModifier("ManyTrees") then
    else
        keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "ManyTrees", {})
        return nil;
    end

    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    groundclickpos = GetGroundPosition(attempt_place_location, nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end


    --if GridNav:IsNearbyTree(groundclickpos, 65, false) then
    --    blocking_counter = blocking_counter + 1
    --end



    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        --newtree = CreateUnitByName("npc_treetag_blocktree", groundclickpos, false, keys.caster, keys.caster,keys.caster:GetPlayerOwner():GetTeam() ) 
        --newtree:SetContext("tagtype", "npc_treetag_building_turret", 0)
        --newtree:SetAngles(0.0,90.0,0.0)
        --newtree:SetOwner(keys.caster);
        --newtree:SetControllableByPlayer(keys.caster:GetPlayerID(), false);
    else
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end
end

function endManyTreesSetCooldown(keys)
    keys.ability:StartCooldown(60)
end


watchingtree=false

function manageancients(keys)
    if keys.caster:HasModifier("waitingforend") then
        return      -- end buff has not been added: main game still in progress
    end

    -- give radiant stun ability
    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 2 then
            hero:AddAbility("drainstun")
            hero:SwapAbilities("drainstun", hero:GetAbilityByIndex(0):GetAbilityName(), true, false)
            hero:GetAbilityByIndex(0):SetLevel(1)
        end
    end

    -- remove ancbuff (buff hiding healthbars etc)
    keys.caster:RemoveModifierByName("ancbuff")

    -- set tree hp to half
    if keys.caster:GetUnitName() == "npc_treetag_bigtree" then
        keys.caster:SetHealth(math.floor(keys.caster:GetMaxHealth()*0.5))
        watchingtree=true
    end
end



ancientphasedone = false



function createmoditem(caster)
    --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )
    if not moditem then
        moditem = CreateItem( "item_apply_modifiers", caster, caster )
    end
end






function managebigtree(keys)
    if ancientphasedone then
        keys.caster:SetModel("models/props_tree/dire_tree006.vmdl")
        while keys.caster:HasModifier("healerer") do
            keys.caster:RemoveModifierByName("healerer")
        end
        return
    end
    if watchingtree then
        if keys.caster:GetHealth()>=keys.caster:GetMaxHealth() then

            --print("TREE MAX HP NOW. DO THINGS PLS")

            --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )

            createmoditem(keys.caster)

            moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "ancientdone", {duration=-1})

            GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

            for _,hero in pairs(HeroList:GetAllHeroes()) do
                if hero:GetTeam() == 2 then
                    --local itx = CreateItem( "item_apply_modifiers", hero, hero )

                    createmoditem(hero)

                    moditem:ApplyDataDrivenModifier(hero, hero, "megatree", {duration=-1})
                    hero:SetModelScale(2.2)
                end
            end


            ancientphasedone = true

        end
    end
end

function radiantinvisthink(keys)
    if ancientphasedone then
        return 1
    end
    if watchingtree then
        if keys.caster:HasAbility("drainstun") then
            return 10
        else
            keys.caster:AddAbility("drainstun")
            keys.caster:SwapAbilities("drainstun", keys.caster:GetAbilityByIndex(0):GetAbilityName(), true, false)
            keys.caster:GetAbilityByIndex(0):SetLevel(1)
            return 10
        end
    end
    return 10
end


function treedied(keys)
    if ancientphasedone then
        return
    end

    --print("TREE DIED. DO THINGS PLS")
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 3 then
            --local itx = CreateItem( "item_apply_modifiers", hero, hero )
            createmoditem(hero)
            moditem:ApplyDataDrivenModifier(hero, hero, "megatree", {duration=-1})
            hero:SetModelScale(2.2)
            -- SET HERO TO PHOENIX PLX
        end
    end

    -- todo:  keys.caster:SetModel(blabla) ?


    ancientphasedone = true

end

function suicidefarm(keys)
    -- farm refund amounts
    if keys.caster:GetUnitName() == "npc_treetag_building_mine_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(400+200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(3200+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(256+128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(12800+6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(512+256+128+64+32)
    end

    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
    keys.caster:Destroy()   -- must come after refunds

end

function resetfarm(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
end

function swapteam(keys)
    print("Current team of player "..keys.caster:GetPlayerOwnerID()..": "..keys.caster:GetTeam())
    if keys.caster:GetTeam()==2 then
        local newteam = 3;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        --keys.caster:GetOwnerEntity():SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        --keys.caster:RespawnUnit();
        print("new team: "..newteam);
    elseif keys.caster:GetTeam()==3 then
        local newteam = 2;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        --keys.caster:GetOwnerEntity():SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        --keys.caster:RespawnUnit();
        print("new team: "..newteam);
    end
end

function suicide(keys)
    local refundwallmod = 0.75
    local refundwallmodmana = 0.75

    if keys.caster:GetUnitName() == "npc_treetag_building_wall_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(128+64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(256+128+64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(512+256+128+64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(1024+512+256+128+64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(2048+1024+512+256+128+64+32+16+8+4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(8192+4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(64+32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(16384+8192+4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(128+64+32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_14" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(32768+16384+8192+4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(256+128+64+32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_15" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(65536+32768+16384+8192+4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(512+256+128+64+32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_16" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(131072+65536+32768+16384+8192+4096+2048+1024+512+256+128+64+32+16+8+4)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(1024+512+256+128+64+32)))

    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64,true,0)

    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(24+8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(32+24+8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64+32+24+8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(128+64+32+24+8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(256+128+64+32+24+8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(512+256+128+64+32+24+8,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1024+512+256+128+64+32+24+8,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(32+16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(2048+1024+512+256+128+64+32+24+8,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+32+16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(4096+2048+1024+512+256+128+64+32+24+8,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+32+16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(2000+128+64+32+16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(3000+2000+128+64+32+16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(4000+3000+2000+128+64+32+16)
    end

    keys.caster:Destroy()   -- must come after refunds because checking info of unit
end

function destroy_aoe(keys)
    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    for _,sudoku in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep", groundclickpos, tonumber(keys.Radius))) do
        if keys.caster:GetPlayerOwnerID() == sudoku:GetPlayerOwnerID() then
            if sudoku:HasAbility("destroy_unit") then
                sudoku:Interrupt()
                sudoku:InterruptChannel()
                sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_unit"), sudoku:GetPlayerOwnerID())
            elseif sudoku:HasAbility("destroy_farm") then
                sudoku:Interrupt()
                sudoku:InterruptChannel()
                sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_farm"), sudoku:GetPlayerOwnerID())
            end
        end
    end
end

function maketargetsudoku(keys)
    tprint(keys)
    local sudoku = keys.target;
    if keys.caster:GetPlayerOwnerID() == sudoku:GetPlayerOwnerID() then
        if sudoku:HasAbility("destroy_unit") then
            sudoku:Interrupt()
            sudoku:InterruptChannel()
            sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_unit"), sudoku:GetPlayerOwnerID())
        elseif sudoku:HasAbility("destroy_farm") then
            sudoku:Interrupt()
            sudoku:InterruptChannel()
            sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_farm"), sudoku:GetPlayerOwnerID())
        end
    else
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end
end

function ownermana(keys)
    local ownermana = keys.caster:GetPlayerOwner():GetAssignedHero():GetMana();
    local maxmana = keys.caster:GetMaxMana();

    if ownermana > maxmana then
        keys.caster:SetMana(maxmana);
    else
        keys.caster:SetMana(ownermana);
    end
end

function collectmanafromspirits(keys)

    for _,spirit in pairs(Entities:FindAllByClassname("npc_dota_creep") )  do
        if keys.caster:GetPlayerOwnerID() == spirit:GetPlayerOwnerID() then
            if string.find(spirit:GetUnitName(),"npc_treetag_spirit") then

                if keys.caster:GetMana()>=keys.caster:GetMaxMana() then
                    --print("well full")
                elseif spirit:GetMana()<=0 then
                    --print("spirit not full yet: "..keys.caster:GetMana().."/"..keys.caster:GetMaxMana())
                else
                    keys.caster:GiveMana(spirit:GetMana())
                    spirit:SpendMana(spirit:GetMana(), nil)
                end

                --if keys.caster:GetMana()>=keys.caster:GetMaxMana() then
                    --print("well full")
                --elseif spirit:GetMana()<spirit:GetMaxMana() then
                    --print("spirit not full yet: "..keys.caster:GetMana().."/"..keys.caster:GetMaxMana())
                --else
                --    keys.caster:GiveMana(spirit:GetMaxMana())
                --    spirit:SpendMana(spirit:GetMaxMana(), nil)
                --end
            end
        end
    end

end

function acquiremana(keys)
    if keys.Mana == "max" then
        -- if spirit is in gold zone give full mana otherwise give half of full mana;   Go and double the max mana of spirits to compensate for this


        -- round up most of the time kkkkkkk
        local mana = math.floor( 0.01 * keys.caster:GetMaxMana() );

        if keys.caster:HasModifier("fastmine") then
            mana = math.floor( 0.01 * keys.caster:GetMaxMana() * 1.2 + 0.9 )
        end

        keys.caster:GiveMana(mana)
    else
        keys.caster:GiveMana(tonumber(keys.Mana))
    end
end

function toggleautocast(keys)
    keys.ability:ToggleAutoCast()
end


function manacollectautocast(keys)
    if not keys.ability:GetAutoCastState() then
        return
    end
    if not keys.caster:IsIdle() then
        return
    end
    if not keys.ability:IsCooldownReady() then
        return
    end



    --for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 75) )  do
    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 75, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    --for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 150) )  do
    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 150, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    --for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 280) )  do
    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 280, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end
end

function recastcollectmana(keys)

    if keys.target:IsStanding() then
        local inuse = false
        for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.target:GetOrigin(),nil), 15) )  do
            if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                if annoyingcunt ~= keys.caster then
                    inuse=true
                        break
                end
            end
        end
        if not inuse then
            keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
            return
        end
    end

    for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 75) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 150) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(Entities:FindAllByClassnameWithin("ent_dota_tree",GetGroundPosition(keys.target:GetOrigin(),nil), 280) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,annoyingcunt in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(annoyingcunt:GetUnitName(),"npc_treetag_spirit") then
                    if annoyingcunt ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end
    
end

function emptymana(keys)
    keys.caster:SetMana(0)
end

function takemanafromwell(keys)
    if keys.caster:GetMana() >= keys.caster:GetMaxMana() then
        return
    end
    for _,well in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.caster:GetOrigin(),nil), 600) )  do
        if keys.caster:GetPlayerOwnerID() == well:GetPlayerOwnerID() then
            --if (well:GetUnitName() == "npc_treetag_building_well_1") then
            if string.find(well:GetUnitName(), "npc_treetag_building_well") then
                manaamt = 10 + math.floor(0.3*well:GetMana())
                if manaamt>=well:GetMana() then
                    manaamt = well:GetMana()-1
                end

                well:SpendMana(manaamt, nil)
                keys.target:GiveMana(manaamt)

                if manaamt > 0 then
                    --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )
                    createmoditem(keys.caster)
                    --moditem:ApplyDataDrivenModifier(keys.caster, well, "beamtarget", {duration=0.1})
                end
            end
        end
    end

end

function spiritthink(keys)
    -- todo: globally check for spirits
    -- if too many then fuck right off please


    for _,thing in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.target:GetOrigin(),nil), 350) )  do
        if keys.caster:GetPlayerOwnerID() == thing:GetPlayerOwnerID() then
            --if (thing:GetUnitName() == "npc_treetag_building_well_1") then
            if string.find(thing:GetUnitName(), "npc_treetag_building_well") then
                keys.caster:RemoveModifierByName(keys.Buff) -- remove spirit from hero
                --spiritus = CreateUnitByName("npc_treetag_spirit", thing:GetOrigin(), false, nil, nil,keys.caster:GetTeam() ) 
        
                --spiritus:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero())
                --spiritus:SetControllableByPlayer(keys.caster:GetPlayerOwner():GetAssignedHero():GetPlayerID(), true)



                spiritus = CreateUnitByName("npc_treetag_spirit", thing:GetOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
                
                if spiritus ~= nil then
                    spiritus:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
                    spiritus:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
                    learnabilities(spiritus)
                end


                --print("spawning spirit")
                return 5
            end
        elseif (thing:GetUnitName() == "npc_treetag_bigtree") then
            if watchingtree then
                --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )
                createmoditem(keys.caster)
                moditem:ApplyDataDrivenModifier(thing, thing, "bigtreespirit", {duration=120})
                keys.caster:RemoveModifierByName(keys.Buff) -- remove spirit from hero
            end
        end
    end

end

gemitem = nil

function givetruesight(keys)
    --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )
    --item:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_necronomicon_warrior_sight", {duration=keys.Duration})

    --keys.caster:AddNewModifier(keys.caster, nil, keys.modname, {duration=keys.Duration})
    --keys.caster:AddNewModifier(keys.caster, nil, "modifier_necronomicon_warrior_sight", {duration=keys.Duration,IsHidden="0"})
    --keys.caster:AddNewModifier(keys.caster, nil, "modifier_invisible", {duration=keys.Duration})

    --local item = CreateItem( "item_gem", keys.caster, keys.caster )

    if not gemitem then
        gemitem = CreateItem("item_gem", keys.caster, keys.caster)
    end

    keys.caster:AddNewModifier(keys.caster, gemitem, "modifier_item_gem_of_true_sight", {duration=keys.Duration})
end

log_item = nil;

function choptree(keys)


    abzx = keys.caster:FindAbilityByName("goldattack")
    if abzx:GetCooldownTimeRemaining() <= 0 then

        keys.target:CutDownRegrowAfter(20, keys.caster:GetTeam())


        StartSoundEvent("DOTA_Item.Hand_Of_Midas", keys.caster:GetPlayerOwner():GetAssignedHero())

        if not log_item then
            --local item = CreateItem( "item_apply_logs", keys.caster, keys.caster )
            log_item = CreateItem( "item_apply_logs", keys.caster, keys.caster )
        end

        
        log_item:ApplyDataDrivenModifier(keys.caster, keys.caster, "holding_log", {duration=240})


        local attacktime = keys.caster:GetBaseAttackTime() / keys.caster:GetAttackSpeed()



        keys.ability:EndCooldown();
        keys.ability:StartCooldown(attacktime * 3.4);
        abzx:StartCooldown(attacktime * 3.4);
    else
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "That ability is still on cooldown" } )
    end





    --local gold = math.floor(  1 * keys.attacker:GetAverageTrueAttackDamage()  )
    --PopupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    --keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold,true,0)
end



function logthink(keys)

    for _,thing in pairs(Entities:FindAllByClassnameWithin("ent_dota_fountain",GetGroundPosition(keys.target:GetOrigin(),nil), 450) )  do

        keys.caster:RemoveModifierByName("holding_log")

        local gold = math.floor(  1 * keys.caster:GetAverageTrueAttackDamage()  )
        PopupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold,true,0)


        StartSoundEvent("DOTA_Item.Hand_Of_Midas", keys.caster:GetPlayerOwner():GetAssignedHero())


        return 1.0
    end

end



function givespirit(keys)

    --spiritus = CreateUnitByName("npc_treetag_spirit", keys.target:GetOrigin(), false, nil, nil, keys.target:GetTeam() ) 
        
    --spiritus:SetOwner(keys.target:GetPlayerOwner():GetAssignedHero())
    --spiritus:SetControllableByPlayer(keys.target:GetPlayerOwner():GetAssignedHero():GetPlayerID(), true)

    spiritus = CreateUnitByName("npc_treetag_spirit", keys.target:GetOrigin(), false, keys.target, keys.target:GetOwner(), keys.target:GetTeamNumber() ) 
    
    if spiritus ~= nil then
        spiritus:SetControllableByPlayer(keys.target:GetPlayerID(), true);
        spiritus:SetOwner(keys.target:GetPlayerOwner():GetAssignedHero());
        learnabilities(spiritus)
    end

end



function eatspirit(keys)

    if keys.target:GetClassname()=="ent_dota_tree" then
        if not keys.caster:HasModifier("holding_spirit") then
            --print("standing: "..keys.target:IsStanding())
            if keys.target:IsStanding() then
                for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(keys.target:GetOrigin(),nil), 15) )  do
                    -- add another if for gold trees (decid)
                    if (thing:GetName() == "treesaver") then
                        --print("found tree saver")
                        --local item = CreateItem( "item_apply_modifiers", keys.caster, keys.caster )
                        createmoditem(keys.caster)
                        moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "holding_spirit", {duration=90})
                        keys.target:CutDownRegrowAfter(60, keys.caster:GetTeam())
                        keys.caster:Interrupt()
                        keys.caster:InterruptChannel()
                        return -- found treesaver
                    end
                end
            end
        else
            FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "You can only hold 1 spirit at a time" } )
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()
            return  -- already holding spirit
        end

        -- finding a treesaver results in return
        -- can only reach this point if tree is not in treesaver trigger
        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "You can only rescue a spirit from a dying tree" } )

        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif keys.target:GetClassname()=="npc_dota_creature" then
        local uname = keys.target:GetUnitName()
        if uname == "npc_treetag_bigtree" then
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()
            FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "You must fetch spirits from dying trees to heal the World Tree!" } )
        end
    end
    --tprint(keys)
end
 
function stopiffull(keys)
    -- DISABLED BECAUSE AUTO HEAL TARGET SWITCHING IS FUCKING OP BRUV

    --if keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):IsCooldownReady() then
    --    if keys.target:GetHealth()>=keys.target:GetMaxHealth() then
    --        --print(keys.target:GetMostRecentDamageTime())
    --        keys.caster:Interrupt()
    --    end
    --end

    -- stop if dead code:
    if keys.target == nil then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif not keys.target:IsAlive() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end

end



function autocastspell(keys)
    --local targetstring = "npc_treetag_building_mine";
    --local spelltocast = "chronoboost";
    --local range = 750;
    --local avoidbuff = "fastmine";

    local targetstring = keys.targetstring;
    local spelltocast = keys.spelltocast;
    local range = keys.range;
    local avoidbuff = keys.avoidbuff;
    local castonfullhp = keys.castonfullhp;
    local ignoreidle = keys.ignoreidle;
    if ignoreidle == "false" then
        if not keys.caster:IsIdle() then
            return 0.5
        end
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName(spelltocast):IsCooldownReady() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName(spelltocast):GetAutoCastState() then
        return 0.5
    end

    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), range)) do
        --if unit:IsCreature() then
            if unit:GetTeam() == keys.caster:GetTeam() then
                --print(castonfullhp..", "..unit:GetHealth() ..", ".. unit:GetMaxHealth())
                if castonfullhp=="true" or unit:GetHealth() < unit:GetMaxHealth() then
                    if not unit:HasModifier(avoidbuff) then
                        if string.find(unit:GetUnitName(), targetstring) then
                            keys.caster:CastAbilityOnTarget(unit, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())
                            return 0.5
                        end
                    end
                end
            end
        --end
    end

    keys.caster:CastAbilityOnTarget(healtarget, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())
end


function autorepair(keys)
    if not keys.caster:IsIdle() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):IsCooldownReady() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):GetAutoCastState() then
        return 0.5
    end

    local healtarget = nil

    --for _,unit in pairs( Entities:FindAllInSphere(GetGroundPosition(keys.caster:GetAbsOrigin(), nil), 300 )) do
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 350)) do
        --if unit:IsCreature() then
            if unit:GetTeam() == keys.caster:GetTeam() then
                if unit:GetHealth() < unit:GetMaxHealth() then
                    if string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                        keys.caster:CastAbilityOnTarget(unit, keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"), keys.caster:GetPlayerOwnerID())
                        return 0.5
                    elseif string.find(unit:GetUnitName(), "npc_treetag_building_") then
                        healtarget = unit;
                    end
                end
            end
        --end
    end

    if healtarget == nil then
        return 0.5
    end


    keys.caster:CastAbilityOnTarget(healtarget, keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"), keys.caster:GetPlayerOwnerID())
end

function clearmodel(keys)
    keys.caster:SetModelScale(0.01)
end

function eatmana(keys)
    mana = keys.ability:GetCaster():GetMana()
    if mana<20 then
        keys.ability:ToggleAbility()
    else
        keys.ability:GetCaster():ReduceMana(20)
    end
end

function incrementlevel(keys)
    keys.caster:CreatureLevelUp(1)
end

function zxca(keys)
    print("zxcAAAAAAAAAAAAAAAAAAAAAAAAAA")
end

function zxcb(keys)
    print("zxcBbbBbB")
end

function zxcc(keys)
    print("zxcCCCCCCC")
end










function picktree(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_treant",0,0)


    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities 1 through 5, dont level ulti at level '1'
    zxc:GetAbilityByIndex(0):ToggleAutoCast()

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

    --needshero[id] = false
end


function pickriki(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_riki",0,0)

    CosmeticLib:RemoveAll( zxc )

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

    --needshero[id] = false
end


function pickveno(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_venomancer",0,0)

    CosmeticLib:RemoveAll( zxc )

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

    --needshero[id] = false
end


function picktechies(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_techies",0,0)

    CosmeticLib:RemoveAll( zxc )

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

    --needshero[id] = false
end

function pickfurion(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_furion",0,0)


    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities 1 through 5, dont level ulti at level '1'
    zxc:GetAbilityByIndex(0):ToggleAutoCast()

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

    --needshero[id] = false
end


function picktimber(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_shredder",0,0)

    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities exclude ulti on lvl '1',  treerape
    zxc:GetAbilityByIndex(1):SetLevel(1)    -- gold hit
    zxc:GetAbilityByIndex(2):SetLevel(1)    -- scan
    zxc:GetAbilityByIndex(3):SetLevel(1)    -- invis
    zxc:GetAbilityByIndex(4):SetLevel(1)    -- true sight
    zxc:GetAbilityByIndex(5):SetLevel(1)    -- chakram

    --zxc:GetAbilityByIndex(4):SetLevel(1)  -- attribute bonus (ability6 on timbersav)

    itz = CreateItem("item_travel_boots", zxc, zxc)
    itz:SetPurchaseTime(itz:GetPurchaseTime()-12)
    zxc:AddItem(itz)


    itz2 = CreateItem("item_chop_tree", zxc, zxc)
    itz2:SetPurchaseTime(itz2:GetPurchaseTime()-12)
    zxc:AddItem(itz2)
    

    zxc:SetAbilityPoints(0)
    --needshero[id] = false
end

function pickbatrider(keys)
    local zxc = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(),"npc_dota_hero_batrider",0,0)

    zxc:GetAbilityByIndex(0):SetLevel(1)    -- normal abilities exclude ulti on lvl '1',  treerape
    zxc:GetAbilityByIndex(1):SetLevel(1)    -- gold hit
    zxc:GetAbilityByIndex(2):SetLevel(1)    -- scan
    zxc:GetAbilityByIndex(3):SetLevel(1)    -- invis
    zxc:GetAbilityByIndex(4):SetLevel(1)    -- true sight
    zxc:GetAbilityByIndex(5):SetLevel(1)    -- chakram

    itz = CreateItem("item_travel_boots", zxc, zxc)
    itz:SetPurchaseTime(itz:GetPurchaseTime()-12)
    zxc:AddItem(itz)


    itz2 = CreateItem("item_chop_tree", zxc, zxc)
    itz2:SetPurchaseTime(itz2:GetPurchaseTime()-12)
    zxc:AddItem(itz2)

    zxc:SetAbilityPoints(0)
end


function goldattack(keys)
    local armor = keys.target:GetPhysicalArmorValue();
    local armormod = 1

    if armor>0 then
        armormod = 1-((0.06 * armor) / (1 + 0.06 * armor));
    elseif armor<0 then
        armormod = 1+((0.06 * (0-armor)) / (1 + 0.06 * (0-armor)));
    end
    
    local gold = math.floor(  armormod * keys.attacker:GetAverageTrueAttackDamage()  )
    

    PopupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)

    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold,true,0)
end

function interruptifnotech(keys)
    local techrange = 1000

    if keys.techrange==nil then
    elseif keys.techrange == "" then
    else
        techrange=keys.techrange
    end

    if keys.techunit==nil then

    elseif keys.techunit=="" then

    else
        if techinrange(keys.caster,keys.techunit,tonumber(keys.techunitlevel),techrange) then

        else
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()

            keys.ability:GetCaster():GetAbilityByIndex(0):EndCooldown() -- upgrade ability is in first slot

            --print("notech")

            if keys.techunit=="npc_treetag_building_wall" then
                FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Requires nearby wall "..keys.techunitlevel } )
            elseif keys.techunit=="npc_treetag_building_well" then
                FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Requires nearby well "..keys.techunitlevel } )
            end

            return                      -- return if tech not found
        end
    end


    local manaprice = keys.ability:GetManaCost(0)

    if manaprice==0 then
        return                      -- return if no mana cost
    end

    if keys.caster:GetPlayerOwner():GetAssignedHero():GetMana()<manaprice then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()

        keys.ability:EndCooldown() -- upgrade ability is in first slot

        FireGameEvent( 'custom_error_show', { player_ID = keys.caster:GetPlayerOwnerID(), _error = "Not enough mana on hero" } )
        StartSoundEvent("treant_treant_nomana_01", keys.caster:GetPlayerOwner():GetAssignedHero())
        
        --print("nomana")
    else
        keys.caster:GetPlayerOwner():GetAssignedHero():SpendMana(manaprice, nil)
    end

end

function techinrange(caster, targetunit, targetunitlevel, techrange)
    tech1found = false
    for _,unit in pairs( Entities:FindAllInSphere(GetGroundPosition(caster:GetAbsOrigin(), nil), techrange )) do
        if unit:GetClassname() == "npc_dota_creep" then
            local uname = unit:GetUnitName()
            if string.find(unit:GetUnitName(), targetunit) then
                local uul = string.gsub(unit:GetUnitName(), "("..targetunit.."_)", "")
                local ulevel = tonumber(uul)
                --if tonumber(unit:GetContext("tagtypelevel")) >= techlevel then
                if ulevel >= targetunitlevel then
                    local id = unit:GetPlayerOwnerID()
                    if id ~= -1 then
                        if caster:GetPlayerOwnerID() == id then
                            --print("tech unit found for ID: " .. id)
                            tech1found=true
                            break
                        end
                    else
                        --print("unit has no ownerino")
                    end
                end
            end
        end
    end

    if tech1found then
        --print(":)")
        return true
    else
        return false
    end
end

function refundcost(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(keys.ability:GetGoldCost(1), true, 0)
end

function passivegold(keys)
    if keys.caster == nil then
        return nil
    end

    local uul = string.gsub(keys.caster:GetUnitName(), "(npc_treetag_building_mine_)", "")

    local gold = 2^(uul-1);

    if keys.caster:GetPlayerOwner() == nil then
        return
    end

    --textcenter = keys.caster:GetCenter() + RandomVector(35.0);


    if keys.caster:HasModifier("slowmine") then
        gold = math.floor(gold*0.5+0.5)
    end

    -- round up most of the time kkkkkkkk
    if keys.caster:HasModifier("fastmine") then
        gold = math.floor(gold*1.2+0.9)
    end

    PopupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold,true,0)

    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        --if unit:IsCreature() then
            if unit:GetTeam() == keys.caster:GetTeam() then
                if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                    if string.find(unit:GetUnitName(), "npc_treetag_building_mine") then
                        -- apply slow mine debuff
                        local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                        item:ApplyDataDrivenModifier(unit, unit, "slowmine", {duration=1.5})    -- overlap important or code below doesnt detect the modifier
                    end
                end
            end
        --end
    end

end


function turretreducedamage(keys)
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        --if unit:IsCreature() then
            if unit:GetTeam() == keys.caster:GetTeam() then
                if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                    if string.find(unit:GetUnitName(), "npc_treetag_building_turret") then
                        -- apply reduced damage to turret
                        local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                        item:ApplyDataDrivenModifier(unit, unit, "reduceddamage", {duration=1.5})
                    elseif string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                        -- reduce armor of wall
                        local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                        item:ApplyDataDrivenModifier(unit, unit, "reducedarmor", {duration=1.5})
                    end
                end
            end
        --end
    end
end



function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end





function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        print(formatting)
    end
end