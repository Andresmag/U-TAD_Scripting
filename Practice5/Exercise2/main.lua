-- Escribe codigo
require "library"
seq = require "sequence"
window_layer, debug_layer = prepareWindow()

worldSizeX = 1024
worldSizeY = 768

mousePositionX = nil
mousePositionY = nil


-- Para usar la clase Sequence
seq.Sequence:new()

-- Define tus variables globales

-- Fin de tus variables globales

-- Define tus funciones
function getCreature()
    local creatures = {
        {name = "dragon", texture = "creatures/dragon.png", size = {x=100, y=100}, hp = 100},
        {name = "grunt", texture = "creatures/grunt.png", size = {x=50, y=50}, hp = 60},
        {name = "mage", texture = "creatures/mage.png", size = {x=50, y=50}, hp = 40},
        {name = "gryphon", texture = "creatures/gryphon.png", size = {x=80, y=80}, hp = 80},
        {name = "peon", texture = "creatures/peon.png", size = {x=30, y=30}, hp = 25}
    }
    for i=1, #creatures do
        coroutine.yield(creatures[i])
    end
end

function filterCreatures()
    local creature = coroutine.create(getCreature)
    local success = true
    local currentCreature = nil
    while coroutine.status(creature) ~= "dead" do
        success, currentCreature = coroutine.resume(creature)
        if coroutine.status(creature) ~= "dead" then
            if currentCreature.hp > 50 then
                coroutine.yield(currentCreature)
            end
        end
    end
end

function creatures()
    return coroutine.wrap(filterCreatures)
end
-- Fin de tus funciones

for creature in creatures() do
    print("Creature = "..creature.name.." hp = "..creature.hp)
end

function onDraw()
    -- Escribe tu código para pintar pixel a pixel
    
    -- Fin de tu código
end

function onUpdate(seconds)
    -- Escribe tu código para ejecutar cada frame
    -- Fin del código
end

function onClickLeft(down)
    -- Escribe tu código para el click del ratón izquierdo (down será true si se ha pulsado, false si se ha soltado)
    if down then

    end
    -- Fin del código
end

function onClickRight(down)
    -- Escribe tu código para el click del ratón derecho (down será true si se ha pulsado, false si se ha soltado)
    if down then
    
    end
    -- Fin del código
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    -- Escribe tu código cuando el ratón se mueve
    
    -- Fin del código
end

function onKeyPress(key, down)
    -- Escribe tu código para tecla pulsada (down será true si la tecla se ha pulsado, false si se ha soltado)
    
    -- Fin del código
end

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, debug_layer)
mainLoop()

