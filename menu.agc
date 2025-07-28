//Load menu images
loade_images:
backdropme=LoadImage("Noite.png")
logo_image=loadimage("logo.png")
start_image=loadimage("start.png")
backdrop_image=loadimage("Background.png")


return


return

//Load backdrop
Load_titles:
backspritem=CreateSprite(backdropme)
SetSpritePosition(backspritem,0,0)
SetSpriteDepth(backspritem,200)


backsprite=CreateSprite(backdrop_image)
SetSpritePosition(backsprite,0,0)
SetSpriteDepth(backsprite,200)
SetSpriteVisible(backsprite,0)




//Load Logo
logosprite=CreateSprite(logo_image)
SetSpritePosition(logosprite,0,0)
SetSpriteScale(logosprite,1,1)
SetSpriteDepth(logosprite,199)



return

//Load Font
Load_menu:
LoadFont(1,"fonte.otf")
CreateText(1,"  Start Game")
SetTextSize(1,40)
SetTextFont(1,1)
SetTextPosition(1,360,480)
SetTextColor(1,255,171,64,255)

CreateText(3,"  Exit")
SetTextSize(3,40)
SetTextFont(3,1)
SetTextPosition(3,450,580)
SetTextColor(3,255,171,64,255)

CreateText(4,"Score: ")
SetTextSize(4,30)
SetTextFont(4,1)
SetTextPosition(4,20,10)
SetTextColor(4,0,0,0,255)
SetTextVisible(4,0)




return
