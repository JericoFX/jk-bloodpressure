local Config = require "config.sv_init"
local max,min = math.max,math.min
--[[

. Factores que afectan la presión arterial:
Baja presión (Hipotensión):

Causas posibles:
Consumo de alcohol.
Heridas graves o pérdida de sangre.
Fatiga extrema o deshidratación.
Efectos:
El jugador puede experimentar visión borrosa (efecto visual de pantalla).
Pérdida de control momentáneo del personaje (animación de tropiezo/desmayo).
Alta presión (Hipertensión):

Causas posibles:
Consumo excesivo de sal, azúcar, cafeína.
Estrés (por ejemplo, si hay enemigos cerca o el jugador está bajo fuego).
Uso de ciertas drogas (anfetaminas, etc.).
Efectos:
Latidos cardíacos audibles (efecto de sonido).
Pérdida de visión periférica (oscurecimiento en los bordes de la pantalla).
Riesgo de desmayo si la presión es muy alta.

]]
--[[
QB
RegisterNetEvent('qb-inventory:server:useItem', function(item)
    local isHigh = Config.hiItems[item.name] or false
    local isLow = Config.lowItems[item.name] or false

    if not isHigh and not isLow then return end

    local player = Player(playerId)
    local bloodPressure = player.state.?bloodPressure

    if not bloodPressure then
        bloodPressure = {
            systolic = Config.systolic,  -- Initial Value
            diastolic = Config.diastolic -- Initial Value
        }
        player.state:set('bloodPressure', bloodPressure, true)
    end

    -- Ajusta la presión arterial según el ítem
    if isHigh then
        bloodPressure.systolic = math.min(bloodPressure.systolic + isHigh, 200)
        bloodPressure.diastolic = math.min(bloodPressure.diastolic + isHigh, 120)
    elseif isLow then
        bloodPressure.systolic = math.max(bloodPressure.systolic - isLow, 50)
        bloodPressure.diastolic = math.max(bloodPressure.diastolic - isLow, 30)
    end
    player.state:set("bloodPressure",{systolic = bloodPressure.systolicc,diastolic = bloodPressure.diastolic},true)
end)

]]

-- Use any event here, i use OX because is more easy to do but you can use any event from any inventory
AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    -- Verifica si el ítem afecta la presión
    local isHigh = Config.hiItems[name] or 0
    local isLow = Config.lowItems[name] or 0

    if  isHigh == 0 and isLow == 0 then return end

    local player = Player(playerId)
    local bloodPressure = player.state.?bloodPressure

    if not bloodPressure then
        bloodPressure = {
            systolic = Config.systolic,
            diastolic = Config.diastolic
        }
        player.state:set('bloodPressure', bloodPressure, true)
    end

    if isHigh then
        bloodPressure.systolic = min(bloodPressure.systolic + isHigh, 200)
        bloodPressure.diastolic = min(bloodPressure.diastolic + isHigh, 120)
    elseif isLow then
        bloodPressure.systolic = max(bloodPressure.systolic - isLow, 50) 
        bloodPressure.diastolic = max(bloodPressure.diastolic - isLow, 30)
    end
    player.state:set("bloodPressure",{systolic = bloodPressure.systolicc,diastolic = bloodPressure.diastolic}) 
end)

lib.addCommand('quitBloodPressure', {
    help = 'Return blood Pressure to normal',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        }
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if args.target then
            local  bloodPressure = {
            systolic = Config.systolic,
            diastolic = Config.diastolic
        }
        Player(args.target).state:set("bloodPressure",bloodPressure,true)
    end
end)
