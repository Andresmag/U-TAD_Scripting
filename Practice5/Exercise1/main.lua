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
        {texture = "creatures/dragon.png", size = {x=100, y=100}},
        {texture = "creatures/grunt.png", size = {x=50, y=50}},
        {texture = "creatures/mage.png", size = {x=50, y=50}},
        {texture = "creatures/gryphon.png", size = {x=80, y=80}},
        {texture = "creatures/peon.png", size = {x=30, y=30}}
    }
    local index=1
    while index <= #creatures do
        local x = creatures[index]
        coroutine.yield(x)
        if index >= #creatures then
            index = 1
        else 
            index = index + 1
        end
    end
end
-- Fin de tus funciones

creature = coroutine.create(getCreature)

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
        local success = true
        local currentCreature = nil
        if coroutine.status(creature) ~= "dead" then
            success, currentCreature = coroutine.resume(creature)
            if success then
                addImage(currentCreature.texture, mousePositionX, mousePositionY, currentCreature.size.x, currentCreature.size.y)
            end
        end
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

