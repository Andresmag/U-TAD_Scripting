-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil


----------- Clase Enemigo ------------
Enemigo = {}
-- Constructor
function Enemigo:new(tex, siz, pos, hp)
    local enemigo = { 
            texture = tex, 
            size = siz, 
            position = pos,
            totalLife = hp, 
            currentLife = hp,
            image = nil
    }
    setmetatable(enemigo, self)
    self.__index = self
    return enemigo
end

function Enemigo:draw()
    self.image = addImage(self.texture, self.position.x, self.position.y, self.size.x, self.size.y)
end

function Enemigo:delete()
    removeImage(self.image)
    self.image = nil
end

function Enemigo:damage(hp)
    if self.currentLife > 0 then
        self.currentLife = self.currentLife - hp
        self:checkDeath()
    end  
end

function Enemigo:checkDeath()
    if self.currentLife <= 0 then
        self.currentLife = 0
        self.size.x = self.size.x / 2
        self.size.y = self.size.y / 2
        self:delete()
        self:draw()
        return true
    end
    return false
end
---------------------------------------
-------- Clase Enemigo Huiduzo --------
EnemigoHuidizo = Enemigo:new()

function EnemigoHuidizo:damage(hp)
    if self.currentLife > 0 then
        self.currentLife = self.currentLife - hp
        if not self:checkDeath() then
            self:checkHalfLife()
        end
    end  
end

function EnemigoHuidizo:checkHalfLife()
    if self.currentLife < (self.totalLife / 2) then
        self.position.x = math.random(0, 1024 - self.size.x)
        self.position.y = math.random(0, 768 - self.size.y)
        self:delete()
        self:draw()
        return true
    end
    return false
end
---------------------------------------

enemigos = {
    Enemigo:new("creatures/gryphon.png", {x=100, y=100}, {x=200, y=200}, 50),
    Enemigo:new("creatures/mage.png", {x=50, y=50}, {x=600, y=200}, 20),
    EnemigoHuidizo:new("creatures/dragon.png", {x=150, y=150}, {x=700, y=500}, 100)
}

function drawEnemigos()
    for idx = 1, #enemigos do
        enemigos[idx]:draw()
    end
end

drawEnemigos()

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
        for idx = 1, #enemigos do
            if enemigos[idx] then
                if (mousePositionX >= enemigos[idx].position.x and mousePositionX <= enemigos[idx].position.x + enemigos[idx].size.x) and (mousePositionY >= enemigos[idx].position.y and mousePositionY <= enemigos[idx].position.y + enemigos[idx].size.y) then
                    enemigos[idx]:damage(10)
                    print("Enemy current life: "..enemigos[idx].currentLife)
                end
            end            
        end
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

