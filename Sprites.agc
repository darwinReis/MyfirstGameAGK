id_imagem_base = LoadImage("Abelhadireita1.png")
id_sprite_abelha = CreateSprite(id_imagem_base)

AddSpriteAnimationFrame(id_sprite_abelha, LoadImage("Abelhadireita2.png"))
AddSpriteAnimationFrame(id_sprite_abelha, LoadImage("Abelhadireita3.png"))
AddSpriteAnimationFrame(id_sprite_abelha, LoadImage("AbelhaDireita4.png"))
SetSpritePosition(id_sprite_abelha, GetVirtualWidth()/2, GetVirtualHeight()/2)

PlaySprite(id_sprite_abelha, 10.0, 1)

