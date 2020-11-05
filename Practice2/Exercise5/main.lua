-- Escribe codigo
require "library"
prepareWindow()

creature = drawCreature(layer, "griphon", 256, 256)
mousePositionX = 0
mousePositionY = 0

directionX = 1
directionY = 0
inside = false

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Empieza tu c�digo para mover a la criatura
    creaturePositionX = creaturePositionX + directionX * 10 * seconds
    creaturePositionY = creaturePositionY + directionY * 10 * seconds
    -- Termina tu c�digo
    setPropPosition(creature, creaturePositionX, creaturePositionY)
end

function onClickLeft(down)
    print("Clicked Left")
end

function onClickRight(down)
    print("Clicked Right")
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    creatureSizeX, creatureSizeY = getCreatureSize("griphon")
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Escribe tu c�digo aqui para el movimiento del rat�n
    if (mousePositionX >= creaturePositionX and mousePositionX <= creaturePositionX + creatureSizeX) and (mousePositionY >= creaturePositionY and mousePositionY <= creaturePositionY + creatureSizeY) then
        if not inside then
            inside = true
            if directionX > 0 and directionY == 0 then
                directionX = -1
            elseif directionX < 0 and directionY == 0 then
                directionX = 0
                directionY = -1
            elseif directionX == 0 and directionY < 0 then
                directionY = 1
            elseif directionX == 0 and directionY > 0 then
                directionX = 1
                directionY = 0
            end
        end
    else
        inside = false
    end
    -- Termina tu c�digo
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

