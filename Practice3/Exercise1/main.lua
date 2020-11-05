-- Escribe codigo
require "library"
require "prepare"

-- Define tus variables globales
square = {
    topLeft = {x=10, y=10},
    size = {w=50, h=50}   -- para que los diseniadores no se quejen
}
-- Termina tu definicion de variables

function pintarPunto(punto)
    -- Rellenar código para pintar un punto en la pantalla
    drawPoint(punto.x, punto.y)
    -- Fin de código
end

function onUpdate(seconds)
end

function onDraw()
    -- Empieza tu código, que debe emplear la funcion pintarPunto
    for row=square.topLeft.y, square.size.h do
        for col=square.topLeft.x, square.size.w do
            pintarPunto({ x=col, y=row })
        end
    end
    -- Termina tu código
end

function onClickLeft(down)
    print("Clicked Left")
    if down then
    end
end

function onClickRight(down)
    print("Clicked Right")
    if down then
    end
end


function onMouseMove(posX, posY)
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, window_layer)
mainLoop()

