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
SequenceInGame = seq.Sequence:new()

-- Define tus variables globales
drakeSeq = SequenceInGame:new()
-- Fin de tus variables globales

-- Define tus funciones
function SequenceInGame:run(seconds)
    local dragon = addEntity("creatures/dragon.png", 100, 100, 100, 100, 50, 50)
    setEntityRotation(dragon, -90) -- look right
    
    -- dragon looking around
    lookingAround(self, dragon, 180, 5)
    lookingAround(self, dragon, -180, 5)
    lookingAround(self, dragon, 180, 5)
    
    -- mage appear
    local mage = addEntity("creatures/mage.png", 600, 500, 50, 50, 25, 25)
    
    -- dragon turn to face the mage and move to catch him
    local DMvec = {x = 600 - 100, y = 500 - 100}
    local Dvec = {x = -50, y = 0} -- we know dragon is looking to the left
    local alpha = getAngle(Dvec, DMvec)
    lookingAround(self, dragon, -alpha, 5)
    self:sleep(2)
    moveEntity(dragon, DMvec.x, DMvec.y, 6)
    self:sleep(3)
    
    -- mage surprise
    scaleSurprise(self, mage, 2, 2, 0.2)
    scaleSurprise(self, mage, -2, -2, 0.2)
    
    -- mage run away
    moveEntity(mage, 200, -400, 1)
    self:sleep(1)
    
    -- dragon chase
    lookingAround(self, dragon, -20, 0.5)
    lookingAround(self, dragon, 20, 0.5)
    local dragonRot = getEntityRotation(dragon)
    Dvec = DMvec
    DMvec = {x = 800 - 600, y = 100 - 500} -- we know where the dragon is -> getEntityPosition(dragon) 
    alpha = getAngle(Dvec, DMvec)
    lookingAround(self, dragon, -alpha, 2)
    moveEntity(dragon, DMvec.x, DMvec.y, 6)
    self:sleep(2)
    
    -- scale mage and shoot
    scaleEntity(mage, 3, 3, 1)
    self:sleep(1)
    local fireball = addEntity("creatures/fireball.png", 750, 60, 50 ,50, 25, 25)
    local Fvec = {x = 50, y = 0}
    local FDvec = {x = -150, y = 440} -- we know the fireball position
    alpha = getAngle(FDvec, Fvec)
    setEntityRotation(fireball, alpha)
    local dragonX, dragonY = getEntityPosition(dragon)
    moveEntity(fireball, dragonX - 750, dragonY - 60, 0.5)
    self:sleep(0.25)
    
    -- Remove dragon and fireball
    removeEntity(dragon)
    removeEntity(fireball)
    
end

function lookingAround(sequen, entity, grades, time)
    rotateEntity(entity, grades, time)
    sequen:sleep(time)
end

function scaleSurprise(sequen, entity, x, y, time)
    scaleEntity(entity, x, y, time)
    sequen:sleep(time)
end

function getAngle(v1, v2)
    local dot = v1.x * v2.x + v1.y * v2.y
    local v1Length = math.sqrt(v1.x * v1.x + v1.y * v1.y)
    local v2Length = math.sqrt(v2.x * v2.x + v2.y * v2.y)
    local angle = math.acos(dot / (v1Length * v2Length)) * 180 / math.pi
    return angle
end
-- Fin de tus funciones


drakeSeq:start()

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

