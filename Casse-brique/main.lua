
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution

io.stdout:setvbuf('no')


status={}
fond={}
fond[1]= love.graphics.newImage("sprite/fond.png")
fond[2]= love.graphics.newImage("sprite/start.png")
fond[3]= love.graphics.newImage("sprite/gameover.png")
pal= love.graphics.newImage("sprite/raquette.png")
bal= love.graphics.newImage("sprite/balle.png")
bonusl = love.graphics.newImage("sprite/bonusL.png")
score= love.graphics.newImage("sprite/score.png")
lives= love.graphics.newImage("sprite/lives.png")
brouge= love.graphics.newImage("sprite/brouge.png")
music = love.audio.newSource("Ephemeral.mp3","stream")
intro = love.audio.newSource("intro.mp3","stream")
musicgo = love.audio.newSource("Erratic.mp3","stream")
hit = love.audio.newSource("Hit.wav","static")
lost = love.audio.newSource("lost.wav","static")
touch = love.audio.newSource("touch.wav","static")
font = love.graphics.newFont("consola.ttf",30)
love.graphics.setFont(font)
local pad = {}
pad.x = 0
pad.y = 0
pad.taille = 1
pad.largeur = 80 * pad.taille
pad.hauteur = 20
pad.score = 0
local balle={}
balle.lives = 0
balle.x = 0
balle.y = 0
balle.rayon = 10
balle.colle = false
balle.vx = 0
balle.vy = 0

local brique = {}
local niveau = {}



-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio

if arg[#arg] == "-debug" then require("mobdebug").start() end


function Demarre()
  status=0
  
end

function Demarre_jeu()

 -- music:play()
  
  balle.colle = true
  balle.lives = 3
  niveau = {}
  local l,c
  
  for l = 4,8 do
    niveau[l]= {}
    for c = 1,15 do
      niveau[l][c] = 1
    end
  end

end

function love.load()


  love.window.setTitle("My Breakout")

  love.mouse.setVisible(false)


  largeur = love.graphics.getWidth()

  hauteur = love.graphics.getHeight()

  brique.hauteur = 25
  
  brique.largeur = largeur / 15

  pad.y = hauteur - (pad.hauteur)
  
  Demarre()
  
end


function update_menu()
  pad.score = 0
  musicgo:stop()
  intro:play()
end

function update_go()
  music:stop()
  musicgo:play()
end

function update_lvl1(dt)
pad.x = love.mouse.getX() 
intro:stop()
--music:play()

if balle.colle == true then
  balle.x = pad.x
  balle.y = pad.y - balle.rayon - pad.hauteur / 2
else
  balle.x = balle.x + balle.vx*dt
  balle.y = balle.y + balle.vy*dt
end

local c = math.floor(balle.x / brique.largeur) +1
local l = math.floor(balle.y / brique.hauteur) +1

if l >= 4 and l <= #niveau and c >=1 and c <=15 then
  if niveau[l][c] == 1 then
    pad.score = pad.score + 5
    balle.vy = 0- balle.vy
    niveau[l][c]= 0
    touch:play()
    -- lvl =fakse
    for l2 = 4,8 do
     
      for c2 = 1,15 do
        if niveau[l2][c2] == 1 then
          --lvl = ture
        end  
      end
    end
    --if lvl = ture status = 2
    balle.vy = balle.vy*1.1
    balle.vx = balle.vx*1.1
    
  end
end
if balle.x > largeur then
    balle.vx = 0 - balle.vx
    balle.x = largeur
    hit:play()
end
if balle.x < 0 then
    balle.vx = 0 - balle.vx
    balle.x = 0
    hit:play()
end
if balle.y < 0 then
    balle.vy = 0 - balle.vy
    balle.y = 0
    hit:play()
end

if balle.y > hauteur then
    -- balle perdue
    lost:play()
    balle.colle = true
    balle.lives= balle.lives - 1
    if balle.lives == 0 then
      status = 100
    end
end

-- tester collision avec le pad

local posCollisionPad = pad.y  -(pad.hauteur/2) - balle.rayon
if balle.y > posCollisionPad then
  local dist = math.abs(pad.x - balle.x)
  local dist2 = (pad.x - balle.x)
  if dist < pad.largeur/2 then
    
    balle.vy = 0 - balle.vy
    if dist2 < 0 then
      balle.vx = math.abs(balle.vy ) * (dist/pad.largeur*2) 
    else
      balle.vx = math.abs(balle.vy) *  (dist/pad.largeur*2) * -1
    end
    balle.y = posCollisionPad
    hit:play()
      
  
  end
end  
end 

function love.update(dt)
  if status==0 then
    update_menu(dt)
  end
  if status==1 then
    update_lvl1(dt)
  end
  if status==100 then
    update_go(dt)
  end
  
  
end


function draw_menu()
  love.graphics.draw(fond[2],0,0)
end

function draw_lvl1()
  love.graphics.draw(fond[1],0,0)
  love.graphics.draw(score,20,20)
  love.graphics.setColor(102,234,255,255)
  love.graphics.print(pad.score,150,20)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(lives,550,20)
  for e = 1,balle.lives do
    love.graphics.draw(bal,620+e*40,30)
  end
  local bx,by = 0,0
  local l,c
  for l = 4,8 do
    bx=0
    for c=1,15 do
          if niveau[l][c] == 1 then
            love.graphics.draw(brouge,bx,by+(brique.hauteur*3))
          end
          bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end

  --love.graphics.draw(pal,pad.x - (pad.largeur/2),pad.y- (pad.hauteur/2),pad.largeur,pad.hauteur)  
  love.graphics.draw(pal,pad.x-(pad.largeur/2) ,pad.y-(pad.hauteur/2),0,pad.taille)  
  love.graphics.draw(bal,balle.x-10,balle.y-(pad.hauteur/2))
end

function draw_lvl2()
  love.graphics.draw(fond[1],0,0)
  love.graphics.draw(score,20,20)
  love.graphics.setColor(102,234,255,255)
  love.graphics.print(pad.score,150,20)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(lives,550,20)
  for e = 1,balle.lives do
    love.graphics.draw(bal,620+e*40,30)
  end
  local bx,by = 0,0
  local l,c
  for l = 4,8 do
    bx=0
    for c=1,15 do
          if niveau[l][c] == 1 then
            love.graphics.draw(brouge,bx,by+(brique.hauteur*3))
          end
          bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end

  --love.graphics.draw(pal,pad.x - (pad.largeur/2),pad.y- (pad.hauteur/2),pad.largeur,pad.hauteur)  
  love.graphics.draw(pal,pad.x-(pad.largeur/2) ,pad.y-(pad.hauteur/2))  
  love.graphics.draw(bal,balle.x-10,balle.y-(pad.hauteur/2))
end

function draw_go()
  love.graphics.draw(fond[3],0,0)
end

function love.draw()
  if status == 0 then
    draw_menu()
  end
  if status == 1 then
    draw_lvl1()
  end
  if status == 100 then
    draw_go()
  end
end


function love.mousepressed(x,y,n)
  if status == 1 then
    if balle.colle == true then
      balle.colle = false
      balle.vx = 200
      balle.vy = -200
    end
  end
  if status == 0 then
    status = 1
    Demarre_jeu()
  end
  if status == 100 then 
    status = 0
  end  
end