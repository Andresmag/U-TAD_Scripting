-- Escribe codigo
require "library"
prepareWindow()

carta, carta_image = drawImage(layer, "cards\\A_C.png", 256, 256, 79, 123)
mousePositionX = 0
mousePositionY = 0
palo = nil

function onUpdate(seconds)
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
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
    image_file = nil
    key_pressed = string.upper(convertKeyToChar(key))
    print("Key pressed: ", key_pressed)
    -- Escribe tu código para gestion de teclado
    if down then
        if palo then
            if (key >= 50 and key <= 57) or key_pressed == "J" or key_pressed == "Q" or key_pressed == "K" then
                image_file = "cards\\"..key_pressed.."_"..palo..".png"
            end
        else
            if key_pressed == "C" or key_pressed == "D" or key_pressed == "T" or key_pressed == "P" then
                palo = key_pressed
            end
        end
    else
        if key_pressed == palo then
            palo = nil
        end
    end
    -- Termina tu código
    
    if image_file then
        setImage(carta_image, image_file)
    end
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

