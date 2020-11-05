-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

number_cards_X = 4
number_cards_Y = 4
card_sizeX = 79
card_sizeY = 123

card_init_X = 20
card_init_Y = 20

-- Define tus variables globales
currentCardSelected = nil
currentSuit = nil
currentCards = {}
currentCardsSuit = {}
currentCardsNumber = {}
numCurrentSuitCards = 0
-- Termina tu definicion de variables

-- Escribe código para funciones necesarias
function chooseSuit()
    result = math.random(1, 4)
    if result == 1 then
        return "C"
    elseif result == 2 then
        return "D"
    elseif result == 3 then
        return "T"
    else
        return "P"
    end
end

function chooseRandomCard()
    selectedNum = nil
    selectedSuit = nil
    
    -- select a card until it 
    repeat
        previouslySelected = false
        
        num = math.random(2, 12)
        if num >= 2 and num <= 9 then
            selectedNum = tostring(num)
        elseif num == 10 then
            selectedNum = "J"
        elseif num == 11 then
            selectedNum = "Q"
        else
            selectedNum = "K"
        end
        selectedSuit = chooseSuit()
        
        -- check if previously selected
        idx = 1
        while idx <= #currentCards do
            if selectedNum == currentCardsNumber[idx] and selectedSuit == currentCardsSuit[idx] then
                previouslySelected = true
                break
            else
                idx = idx + 1
            end
        end
        
    until not previouslySelected
    
    return selectedNum, selectedSuit
end

function removeCards()
    removeImage(currentCardSelected)
    currentCardSelected = nil
    currentSuit = nil
    for idx=1, #currentCards do
        if currentCards[idx] then
            removeImage(currentCards[idx])
        end
    end
    currentCards = {}
    currentCardsSuit = {}
    currentCardsNumber = {}
    numCurrentSuitCards = 0
end
-- Termina tu código

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        
        -- Delete last game
        if currentCardSelected then
            removeCards()
        end
        
        -- Select cards for new game
        currentSuit = chooseSuit()
        currentCardSelected = addImage("cards\\A_"..currentSuit..".png", 1024 - card_sizeX, 0)
        
        for row=0, number_cards_X-1 do
            for col=0, number_cards_Y-1 do
                num, suit = chooseRandomCard()
                image_file = addImage("cards\\"..num.."_"..suit..".png", card_init_X + col * card_sizeX, card_init_Y + row * card_sizeY)
                table.insert(currentCards, #currentCards + 1, image_file)
                table.insert(currentCardsSuit, #currentCardsSuit + 1, suit)
                table.insert(currentCardsNumber, #currentCardsNumber + 1, num)
                if suit == currentSuit then
                    numCurrentSuitCards = numCurrentSuitCards + 1
                end
            end
        end
        
        -- Termina tu código
        resetGame()
    end
end



function onClickRight(down)
    print("Clicked Right")
    if not down then
        -- Escribe tu código para el botón derecho
        if (mousePositionX >= card_init_X and mousePositionX <= card_init_X + card_sizeX * number_cards_X) and (mousePositionY >= card_init_Y  and mousePositionY <= card_init_Y + card_sizeY * number_cards_Y) then
            col = math.floor((mousePositionX - card_init_X) / card_sizeX)
            row = math.floor((mousePositionY - card_init_Y) / card_sizeY)
            idx = (row * number_cards_Y + col) + 1
            
            if currentCardsSuit[idx] then
                if currentCardsSuit[idx] == currentSuit then
                    removeImage(currentCards[idx])
                    currentCards[idx] = nil
                    currentCardsSuit[idx] = nil
                    currentCardsNumber[idx] = nil
                    numCurrentSuitCards = numCurrentSuitCards - 1
                    if numCurrentSuitCards == 0 then
                        won()
                        removeCards()
                    end
                else
                    lost()
                    removeCards()
                end
            end
        else
            if currentCardSelected then
                if numCurrentSuitCards == 0 then
                    won()
                    removeCards()
                else
                    lost()
                    removeCards()
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

