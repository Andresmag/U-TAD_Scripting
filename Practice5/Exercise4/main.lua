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
    
    -- Create initial units
    local mage1 = addEntity("creatures/mage.png", 150, 600, 50, 50, 25, 25)
    local mage2 = addEntity("creatures/mage.png", 100, 550, 50, 50, 25, 25)
    local mage3 = addEntity("creatures/mage.png", 100, 650, 50, 50, 25, 25)
    
    local grunt1 = addEntity("creatures/grunt.png", 1000, 610, 50, 50, 25, 25)
    local grunt2 = addEntity("creatures/grunt.png", 1000, 510, 50, 50, 25, 25)
    local grunt3 = addEntity("creatures/grunt.png", 1000, 560, 50, 50, 25, 25)
    local grunt4 = addEntity("creatures/grunt.png", 1000, 660, 50, 50, 25, 25)
    
    -- Move grunts
    moveEntity(grunt1, -650, 0, 20)
    moveEntity(grunt2, -700, 0, 20)
    moveEntity(grunt3, -600, 0, 20)
    moveEntity(grunt4, -550, 0, 20)
    self:sleep(8)
    
    -- Mages start shooting grunts
    local fireball1 = addEntity("creatures/fireball.png", 180, 600, 20, 20, 10, 10)
    moveEntity(fireball1, 500, 0, 3)
    self:sleep(2)
    removeEntity(grunt1)
    removeEntity(fireball1)
    
    fireball1 = addEntity("creatures/fireball.png", 130, 550, 20, 20, 10, 10)
    moveEntity(fireball1, 500, 0, 3)
    self:sleep(1)
    
    local fireball2 = addEntity("creatures/fireball.png", 130, 650, 20, 20, 10, 10)
    moveEntity(fireball2, 500, 0, 3)
    
    self:sleep(0.75)
    removeEntity(grunt3)
    removeEntity(fireball1)
    
    self:sleep(1)
    removeEntity(grunt4)
    removeEntity(fireball2)
    
    -- Gryphon hunt last grunt
    local gryphon = addEntity("creatures/gryphon.png", 0, 200, 100, 100, 50, 50)
    moveEntity(gryphon, 330, 300, 2)
    self:sleep(1.4)
    removeEntity(grunt2)
    
    -- Dragon fires gryphon and gryphon look at the fireball
    local dragon = addEntity("creatures/dragon.png", 800, 0, 100, 100, 50, 50)
    gryphonX, gryphonY = getEntityPosition(gryphon)
    local Dvec = {x=0, y=100}
    local DGvec = {x = gryphonX + 40 - 800, y = gryphonY - 0} -- +40 because of the shape of the gryphon sprite
    local alpha = getAngle(Dvec, DGvec)
    setEntityRotation(dragon, alpha)
    fireball1 = addEntity("creatures/fireball.png", 750, 50, 50, 50, 25, 25)
    local Fvec = {x = 100, y = 0}
    local FGvec = {x = gryphonX + 40 - 750, y = gryphonY - 50}
    alpha = getAngle(Fvec, FGvec)
    setEntityRotation(fireball1, alpha)
    moveEntity(fireball1, FGvec.x, FGvec.y, 2)
    local Gvec = {x = gryphonX + 100, y = gryphonY}
    alpha = getAngle(Gvec, FGvec)
    self:sleep(0.5)
    rotateEntity(gryphon, -alpha, 1)
    self:sleep(0.95)
    removeEntity(gryphon)
    removeEntity(fireball1)
    
    -- Dragon move to the middle and mages too
    local DPvec = {x = 512 - 800, y = 100 - 0}
    alpha = getAngle(DGvec, DPvec)
    rotateEntity(dragon, alpha, 0.1)
    moveEntity(dragon, -288, 100, 2)
    moveEntity(mage1, 362, 0, 2)
    moveEntity(mage2, 362, 0, 2)
    moveEntity(mage3, 462, 0, 2)
    self:sleep(2)
    local DMvec = {x = 0, y = 600 - 100}
    alpha = getAngle(DPvec, DMvec)
    rotateEntity(dragon, -alpha, 1)
    moveEntity(mage2, 0, 50, 0.5)
    moveEntity(mage3, 0, -50, 0.5)
    self:sleep(1)


    -- Mages create mega fireball
    fireball1 = addEntity("creatures/fireball.png", 512, 580, 20, 20, 10, 10)
    setEntityRotation(fireball1, -90)
    moveEntity(fireball1, 0, -50, 0.5)
    self:sleep(1)
    
    local F2vec = {x = 100, y = 0}
    local F2F1vec = {x = -50, y = -30}
    alpha = getAngle(F2vec, F2F1vec)
    fireball2 = addEntity("creatures/fireball.png", 562, 560, 20, 20, 10, 10)
    setEntityRotation(fireball2, -alpha)
    
    local F3vec = {x = 100, y = 0}
    local F3F1vec = {x = 50, y = -30}
    alpha = getAngle(F3vec, F3F1vec)
    local fireball3 = addEntity("creatures/fireball.png", 462, 560, 20, 20, 10, 10)
    setEntityRotation(fireball3, -alpha)
    
    moveEntity(fireball2, F2F1vec.x, F2F1vec.y, 0.5)
    self:sleep(0.5)
    removeEntity(fireball2)
    scaleEntity(fireball1, 2, 2, 0.1)
    
    moveEntity(fireball3, F3F1vec.x, F3F1vec.y, 0.5)
    self:sleep(0.5)
    removeEntity(fireball3)
    scaleEntity(fireball1, 2, 2, 0.1)
    
    -- Dragon fireball
    fireball2 = addEntity("creatures/fireball.png", 512, 180, 50, 50, 25, 25)
    setEntityRotation(fireball2, 90)
    
    -- Fireball move and remove dragon
    moveEntity(fireball1, 0, -430, 2)
    moveEntity(fireball2, 0, 420, 2)
    self:sleep(0.9)
    removeEntity(fireball2)
    self:sleep(0.5)
    removeEntity(dragon)
    removeEntity(fireball1)
    -- the end
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

