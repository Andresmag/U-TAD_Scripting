-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
creaturesOnScreen = {}
creaturesCurrentHP = {}
-- Termina tu definicion de variables

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        currentCreature = addCreature("griphon", mousePositionX, mousePositionY)
        table.insert(creaturesOnScreen, #creaturesOnScreen, currentCreature)
        table.insert(creaturesCurrentHP, #creaturesCurrentHP, 25)
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    creatureSizeX, creatureSizeY = getCreatureSize("griphon")
    if not down then
        -- Escribe tu código para el botón derecho
        for idx = 0, #creaturesOnScreen do
            if creaturesOnScreen[idx] then
                creaturePosX, creaturePosY = getPropPosition(creaturesOnScreen[idx])
                if (mousePositionX >= creaturePosX and mousePositionX <= creaturePosX + creatureSizeX) and (mousePositionY >= creaturePosY and mousePositionY <= creaturePosY + creatureSizeY) then
                    creaturesCurrentHP[idx] = creaturesCurrentHP[idx] - 5
                    if creaturesCurrentHP[idx] <= 0 then
                        removeCreature(creaturesOnScreen[idx])
                        table.remove(creaturesOnScreen, idx)
                        table.remove(creaturesCurrentHP, idx)
                    end
                end
            end            
        end
        -- Termina tu código
    end
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

