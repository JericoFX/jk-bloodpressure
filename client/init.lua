local Config = require "config.cl_init"
local activeCallbacks = {}

local function startRepeatingCallback(identifier, interval, callback)
    if activeCallbacks[identifier] then return end
    activeCallbacks[identifier] = true
    CreateThread(function()
        while activeCallbacks[identifier] do
            callback()
            Wait(interval)
        end
    end)
end

local function stopRepeatingCallback(identifier)
    activeCallbacks[identifier] = nil
end

local function hyperTensionEffectStart()
    startRepeatingCallback("blur",math.random(2000,5000),function() 
        AnimpostfxPlay("RampageOut", 0, true)
        TriggerScreenblurFadeIn(1000.0)
        SetPedMotionBlur(cache.ped, true)
        Wait(math.random(1500,3000))
        SetPedMotionBlur(cache.ped, false)
        TriggerScreenblurFadeOut(1000.0)
       
    end)
    startRepeatingCallback("ragdoll",math.random(2000,5000),function() 
         -- Thanks for this commit for the code https://github.com/Qbox-project/qbx_playerstates/pull/1/commits/4b37847a02dac02d3007ab0a0b1e97e91671a50b
        local fallRepeat = math.random(2, 4)
        local ragdollTimeout = fallRepeat * 1750
        Wait(math.random(1500,3000))
        if not IsPedRagdoll(cache.ped) and IsPedOnFoot(cache.ped) and not IsPedSwimming(cache.ped) then
            local forwardVector = GetEntityForwardVector(cache.ped)
            SetPedToRagdollWithFall(cache.ped, ragdollTimeout, ragdollTimeout, 1, forwardVector.x, forwardVector.y, forwardVector.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    end)
    startRepeatingCallback("vehicle",math.random(2000,5000),function()
        Wait(math.random(1500,5000)) 
        DoScreenFadeOut(200)
        if cache.vehicle  and cache.seat == -1 then
            SetVehicleSteerBias(cache.vehicle, math.random(-1.0,1.0))
        end
        Wait(500)
        DoScreenFadeIn(200)
    end)
end

local function hyperTensionEffectStop()
    DoScreenFadeIn(200)
    SetPedMotionBlur(cache.ped, false)
    AnimpostfxStop("RampageOut")
    TriggerScreenblurFadeOut(1000.0)
    stopRepeatingCallback("blur")
    stopRepeatingCallback("ragdoll")
    stopRepeatingCallback("vehicle")
end

local function hypotensionEffectsStart()
    startRepeatingCallback("blur",math.random(2000,5000),function() 
        TriggerScreenblurFadeIn(1000.0)
        SetPedMotionBlur(cache.ped, true)
        Wait(math.random(1500,3000))
        SetPedMotionBlur(cache.ped, false)
        TriggerScreenblurFadeOut(1000.0)
    end)
    startRepeatingCallback("vehicle",math.random(2000,5000),function()
        TriggerScreenblurFadeIn(1000.0)
        Wait(math.random(1500,2000)) 
        if cache.vehicle and cache.seat == -1 then
            SetVehicleSteerBias(cache.vehicle, math.random(-1.0,1.0))
        end
        TriggerScreenblurFadeOut(1000.0)
    end)
end

local function hypotensionEffectsStop()
    SetPedMotionBlur(cache.ped, false)
    TriggerScreenblurFadeOut(1000.0)
    stopRepeatingCallback("blur")
end
AddStateBagChangeHandler("bloodPressure", ("player:%s"):format(cache.serverId), function(bagName, key, value) 
    if not value then return end
    local pressure = value
    if pressure.systolic > Config.hiSystolic or pressure.diastolic > Config.hiDiastolic then
        hyperTensionEffectStart()
    else
        hyperTensionEffectStop()
    end
    if pressure.systolic < Config.lowSystolic or pressure.diastolic < Config.lowDiastolic then
        hypotensionEffectsStart()
    else
        hypotensionEffectsStop()
    end
end)
