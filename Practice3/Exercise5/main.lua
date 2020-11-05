-- Escribe codigo
require "library"
require "xml"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
creatures = {}
creaturesMap = {}
---- Fin de tus variables globales

-- Define tus funciones y llamadas
function addCreature(creature_name, posX, posY)
    idx=1
    while idx <= #creatures do
        if creatures[idx][1][1] == creature_name then
            texture_name = creatures[idx][2][1]
            sizeX = tonumber(creatures[idx][3][1][1])
            sizeY = tonumber(creatures[idx][3][2][1])
            break;
        else
            idx = idx + 1
        end
    end
    addImage(texture_name, posX, posY, sizeX, sizeY)
end

function drawMap(map)
    for idx = 1, #map do
        addCreature(map[idx][1][1], tonumber(map[idx][2][1][1]), tonumber(map[idx][2][2][1]))
    end
end

function loadAndDraw(creaturesFile, mapFile)
    creatures = readXML("criaturas.xml")
    creaturesMap = readXML("map.xml")
    drawMap(creaturesMap)
end

loadAndDraw("criaturas.xml", "map.xml")

-- Fin de tus funciones

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    if not down then
        -- Escribe tu código para el botón derecho
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

