-- Escribe codigo
require "library"
prepareWindow()

pointA_X = 0
pointA_Y = 0
pointB_X = 0
pointB_Y = 0

creature = drawCreature(layer, "griphon", 256, 256)
pointA = drawCreature(layer, "blue_pin", pointA_X, pointA_Y)
pointB = drawCreature(layer, "green_pin", pointB_X, pointB_Y)

mousePositionX = nil
mousePositionY = nil

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Empieza tu código
    dirVectorX = pointB_X - pointA_X
    dirVectorY = pointB_Y - pointA_Y
    dirVectorX, dirVectorY = normalizeVector(dirVectorX, dirVectorY)
    creaturePositionX = creaturePositionX + 50*dirVectorX*seconds
    creaturePositionY = creaturePositionY + 50*dirVectorY*seconds
    -- Termina tu código
    setPropPosition(creature, creaturePositionX, creaturePositionY)
    setPropPosition(pointA, pointA_X, pointA_Y)
    setPropPosition(pointB, pointB_X, pointB_Y)
end

function onClickLeft(down)
    print("Clicked Left")
    if down then
        -- Escribe tu código para el botón izquierdo
        pointA_X, pointA_Y = mousePositionX, mousePositionY
        -- Termina tu código
        setPropPosition(creature, pointA_X, pointA_Y)
    end
end

function onClickRight(down)
    print("Clicked Right")
    if down then
        -- Escribe tu código para el botón derecho
        pointB_X, pointB_Y = mousePositionX, mousePositionY
        -- Termina tu código
        setPropPosition(creature, pointA_X, pointA_Y)
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

-- Normalize vector function
function normalizeVector(x, y)
    len = math.sqrt(x*x + y*y)
    return x/len, y/len
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

