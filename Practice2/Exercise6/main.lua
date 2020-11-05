-- Escribe codigo
require "library"
prepareWindow()

creature = drawCreature(layer, "griphon", 256, 256)
creatureSizeX, creatureSizeY = getCreatureSize("griphon")
mousePositionX = 0
mousePositionY = 0
gameOver = false

directionX = 1
directionY = 0

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    creatureSizeX, creatureSizeY = getCreatureSize("griphon")
    -- Empieza tu código para mover a la criatura
    creaturePositionX = creaturePositionX + directionX * 350 * seconds
    creaturePositionY = creaturePositionY + directionY * 350 * seconds
    
    if (creaturePositionX >= 1024) or (creaturePositionX + creatureSizeX <= 0) or (creaturePositionY >= 768) or (creaturePositionY + creatureSizeY <= 0) then
        gameOver = true
    end
    -- Termina tu código
    setPropPosition(creature, creaturePositionX, creaturePositionY)
    
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
        creaturePositionX, creaturePositionY = getPropPosition(creature)
        -- Escribe tu código aqui para botón izquierdo ratón
        resultado = math.random(1, 4)
        if resultado == 1 then
            directionX = 1
            directionY = 0
        elseif resultado == 2 then
            directionX = -1
            directionY = 0
        elseif resultado == 3 then
            directionX = 0
            directionY = -1
        else
            directionX = 0
            directionY = 1
        end
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
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

