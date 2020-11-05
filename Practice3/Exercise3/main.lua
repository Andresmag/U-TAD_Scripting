-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
creatures = {
    grifo = "creatures/gryphon.png",
    mago = "creatures/mage.png",
    grunt = "creatures/grunt.png",
    peon = "creatures/peon.png",
    dragon = "creatures/dragon.png"
}

creaturesMap = {
    {name="grifo", x=10, y=10},
    {name="dragon", x=700, y=30},
    {name="mago", x=200, y=400},
    {name="peon", x=500, y=600},
    {name="grunt", x=450, y=100}
} 
-- Fin de tus variables globales

-- Define tus funciones y llamadas
function addCreature(name, posX, posY)
    addImage(creatures[name], posX, posY)
end

function drawCreaturesMap(map)
    for idx=1, #creaturesMap do
        addCreature(creaturesMap[idx].name, creaturesMap[idx].x, creaturesMap[idx].y)
    end
end

drawCreaturesMap(creaturesMap)
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

