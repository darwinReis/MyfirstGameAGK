// Mostra todos os erros para facilitar a depuração
SetErrorMode(2)

// Propriedades da janela
SetWindowTitle( "Girassol Defensor" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 0 )

// Propriedades de tela
SetVirtualResolution( 1024, 768 )
SetSyncRate( 60, 0 )
SetScissor( 0,0,0,0 )
UseNewDefaultFonts( 1 )

// abelhas
type Bee
    id as integer
    active as integer
endtype

// projétil da semente
type Semente
    id as integer
    active as integer
    vx as float // Velocidade no eixo X
    vy as float // Velocidade no eixo Y
endtype

// arrays das abelhas e tiros pra n lotar a tela
	global dim all_bees[15] as Bee
	global dim all_sementes[25] as Semente

// Variáveis de controle do jogo
	global score as integer = 0
	global high_score as integer = 0
	global game_state as integer = 0 // 0 = Menu, 1 = Jogando, 2 = Game Over

// ID das sprites, textos e assets
	global id_background
	global id_girassol
	global id_logo_titulo
	global id_texto_jogar, id_texto_sair, id_texto_score_label, id_texto_score_value, id_texto_gameover
	global id_texto_continuar, id_texto_score_final
	global id_fonte_jogo
	global id_musica_fundo, id_som_tiro, id_som_acerto

// Carrega tudo que o jogo precisa antes de começar
gosub load_assets

// Inicia a música de fundo em loop
	PlayMusic(id_musica_fundo, 1)

do
//loop principal
    
    if game_state = 0 //MENU
        gosub logic_menu
    endif
    
    if game_state = 1 //JOGANDO
        gosub logic_gameplay
    endif
    
    if game_state = 2 //tela de GAME OVER
        gosub logic_gameover
    endif

// Atualiza a tela para desenhar todas as mudanças
    Sync()
loop

// --- ROTINAS ---
load_assets:
//fonte e os arquivos de áudio
    id_fonte_jogo = LoadFont("fonte.otf")
    id_musica_fundo = LoadMusic("trilhasonora.mp3")
    id_som_tiro = LoadSound("som_tiro.wav")
    id_som_acerto = LoadSound("som_acerto.wav")

//volume para a música e os sons
    SetMusicFileVolume(id_musica_fundo, 20)
    
//imagem de fundo
    id_background = CreateSprite(LoadImage("background.png"))
    SetSpritePosition(id_background, 0, 0)
    SetSpriteDepth(id_background, 100) // Coloca o fundo bem atrás

//imagem do girassol
    id_girassol = CreateSprite(LoadImage("girassol.png"))
    SetSpriteVisible(id_girassol, 0) // Começa invisível

//imagens da abelha e cria os sprites
    frame1 = LoadImage("Abelhadireita1.png")
    frame2 = LoadImage("Abelhadireita2.png")
    frame3 = LoadImage("Abelhadireita3.png")
    frame4 = LoadImage("AbelhaDireita4.png")

    for i = 0 to 14
        all_bees[i].id = CreateSprite(frame1)
        AddSpriteAnimationFrame(all_bees[i].id, frame2)
        AddSpriteAnimationFrame(all_bees[i].id, frame3)
        AddSpriteAnimationFrame(all_bees[i].id, frame4)
        PlaySprite(all_bees[i].id, 10.0, 1)
        SetSpriteVisible(all_bees[i].id, 0)
        all_bees[i].active = 0
    next i

//sprites das sementes
    id_imagem_semente = LoadImage("semente.png")
    for i = 0 to 24
        all_sementes[i].id = CreateSprite(id_imagem_semente)
        SetSpriteVisible(all_sementes[i].id, 0)
        all_sementes[i].active = 0
    next i

//logo
    id_logo_titulo = CreateSprite(LoadImage("titulo.png"))
    SetSpritePosition(id_logo_titulo, GetVirtualWidth()/2 - GetSpriteWidth(id_logo_titulo)/2, 0)

//textos da interface ,fonte e cores
    id_texto_jogar = CreateText("Jogar")
    SetTextFont(id_texto_jogar, id_fonte_jogo)
    SetTextSize(id_texto_jogar, 40)
    SetTextColor(id_texto_jogar, 255, 171, 64, 255)
    SetTextPosition(id_texto_jogar, GetVirtualWidth()/2 - GetTextTotalWidth(id_texto_jogar)/2, 400)

    id_texto_sair = CreateText("Sair")
    SetTextFont(id_texto_sair, id_fonte_jogo)
    SetTextSize(id_texto_sair, 30)
    SetTextColor(id_texto_sair, 255, 171, 64, 255)
    SetTextPosition(id_texto_sair, GetVirtualWidth()/2 - GetTextTotalWidth(id_texto_sair)/2, 520)

// Score com fonte diferente pq a fonte nao tem numero
    id_texto_score_label = CreateText("Score: ")
    SetTextFont(id_texto_score_label, id_fonte_jogo)
    SetTextSize(id_texto_score_label, 25)
    SetTextColor(id_texto_score_label, 255, 171, 64, 255)
    SetTextPosition(id_texto_score_label, 10, 10)
    SetTextVisible(id_texto_score_label, 0)

    id_texto_score_value = CreateText("0")
    SetTextSize(id_texto_score_value, 25)
    SetTextColor(id_texto_score_value, 255, 171, 64, 255)
    SetTextPosition(id_texto_score_value, GetTextX(id_texto_score_label) + GetTextTotalWidth(id_texto_score_label), 10)
    SetTextVisible(id_texto_score_value, 0)
    
    id_texto_gameover = CreateText("FIM DE JOGO!")
    SetTextFont(id_texto_gameover, id_fonte_jogo)
    SetTextSize(id_texto_gameover, 60)
    SetTextColor(id_texto_gameover, 255, 171, 64, 255)
    SetTextPosition(id_texto_gameover, GetVirtualWidth()/2 - GetTextTotalWidth(id_texto_gameover)/2, 150)
    SetTextVisible(id_texto_gameover, 0)
    
    id_texto_continuar = CreateText("Clique para tentar novamente")
    SetTextFont(id_texto_continuar, id_fonte_jogo)
    SetTextSize(id_texto_continuar, 30)
    SetTextColor(id_texto_continuar, 255, 200, 100, 255)
    SetTextPosition(id_texto_continuar, GetVirtualWidth()/2 - GetTextTotalWidth(id_texto_continuar)/2, 450)
    SetTextVisible(id_texto_continuar, 0)
    
// Texto separado para o placar final
    id_texto_score_final = CreateText("")
    SetTextSize(id_texto_score_final, 30)
    SetTextColor(id_texto_score_final, 255, 200, 100, 255)
    SetTextVisible(id_texto_score_final, 0)
return


//INICIA O JOGO
start_game:
// Esconde o sprite do título e os textos do menu/gameover
    SetSpriteVisible(id_logo_titulo, 0)
    SetTextVisible(id_texto_jogar, 0)
    SetTextVisible(id_texto_sair, 0)
    SetTextVisible(id_texto_gameover, 0)
    SetTextVisible(id_texto_continuar, 0)
    SetTextVisible(id_texto_score_final, 0) // Esconde o score final

// Redefine o score para o estado de "jogando"
    score = 0
    SetTextString(id_texto_score_value, str(score))
    SetTextVisible(id_texto_score_label, 1)
    SetTextVisible(id_texto_score_value, 1)
    
// Posiciona o girassol no centro da tela
    SetSpritePosition(id_girassol, GetVirtualWidth()/2 - GetSpriteWidth(id_girassol)/2, GetVirtualHeight()/2 - GetSpriteHeight(id_girassol)/2)
    SetSpriteVisible(id_girassol, 1)

// Desativa todas as abelhas e sementes antes de começar
    for i = 0 to 14
        SetSpriteVisible(all_bees[i].id, 0)
        all_bees[i].active = 0
    next i
    for i = 0 to 24
        SetSpriteVisible(all_sementes[i].id, 0)
        all_sementes[i].active = 0
    next i

// Ativa as primeiras abelhas
    gosub spawn_bee
    gosub spawn_bee
    gosub spawn_bee

// Muda o estado do jogo para "jogando"
    game_state = 1
return


// --- MENU ---
logic_menu:
    rem // Mostra os elementos do menu
    SetSpriteVisible(id_logo_titulo, 1)
    SetTextVisible(id_texto_jogar, 1)
    SetTextVisible(id_texto_sair, 1)
    
    if GetPointerPressed()
        if GetTextHitTest(id_texto_jogar, GetPointerX(), GetPointerY()) then gosub start_game
        if GetTextHitTest(id_texto_sair, GetPointerX(), GetPointerY()) then end
    endif
return


// --- GAME OVER---
logic_gameover:
    if GetPointerPressed()
        if GetTextHitTest(id_texto_continuar, GetPointerX(), GetPointerY())
            gosub start_game
        endif
    endif
return


// --- GAMEPLAY ---
logic_gameplay:
// Faz o Girassol virar para a esquerda ou direita em direção ao mouse
    girassol_x = GetSpriteX(id_girassol) + GetSpriteWidth(id_girassol)/2
    if GetPointerX() < girassol_x
        SetSpriteFlip(id_girassol, 1, 0)
    else
        SetSpriteFlip(id_girassol, 0, 0)
    endif
	SetSpriteShape(id_girassol,3)
// Atirar com clique do mouse
    if GetPointerPressed()
        gosub shoot_semente
    endif
SetPhysicsDebugOn()
// Atualiza a posição das sementes e abelhas
    gosub update_sementes
    gosub update_bees
    
// Verifica colisões
    gosub check_collisions
return


// --- ATIRAR ---
shoot_semente:
    for i = 0 to 24
        if all_sementes[i].active = 0
            all_sementes[i].active = 1
            semente_id = all_sementes[i].id
            SetSpriteShape(semente_id,3)
// Pega a posição do centro do girassol
            player_x = GetSpriteX(id_girassol) + GetSpriteWidth(id_girassol)/2
            player_y = GetSpriteY(id_girassol) + GetSpriteHeight(id_girassol)/2
            SetSpritePosition(semente_id, player_x - GetSpriteWidth(semente_id)/2, player_y - GetSpriteHeight(semente_id)/2)
            
// Calcula o vetor de direção normalizado para o mouse
            dir_x# = GetPointerX() - player_x
            dir_y# = GetPointerY() - player_y
            distance# = Sqrt(dir_x#*dir_x# + dir_y#*dir_y#)
            
            if distance# > 0
                speed# = 8.0
                all_sementes[i].vx = (dir_x# / distance#) * speed#
                all_sementes[i].vy = (dir_y# / distance#) * speed#
            endif
     PlaySound(id_som_tiro)
     SetSpriteVisible(semente_id, 1)
            exit
        endif
    next i
return


// --- SEMENTES ---
update_sementes:
    for i = 0 to 24
        if all_sementes[i].active = 1
            id = all_sementes[i].id
            SetSpritePosition(id, GetSpriteX(id) + all_sementes[i].vx, GetSpriteY(id) + all_sementes[i].vy)      
// Se a semente saiu da tela, desativa ela
            if GetSpriteX(id) < -20 or GetSpriteX(id) > GetVirtualWidth() or GetSpriteY(id) < -20 or GetSpriteY(id) > GetVirtualHeight()
                all_sementes[i].active = 0
                SetSpriteVisible(id, 0)
            endif
        endif
    next i
return


// --- NOVA ABELHA ---
spawn_bee:
    for i = 0 to 14
        if all_bees[i].active = 0
            all_bees[i].active = 1
            id = all_bees[i].id
// Escolhe um lado aleatório para surgir (0=topo, 1=esquerda, 2=direita)
            side = Random(0, 2)
            if side = 0 // Topo
                spawn_x = Random(0, GetVirtualWidth())
                spawn_y = -50
            elseif side = 1 // Esquerda
                spawn_x = -50
                spawn_y = Random(0, GetVirtualHeight())
            else // Direita
                spawn_x = GetVirtualWidth() + 50
                spawn_y = Random(0, GetVirtualHeight())
            endif
            
            SetSpritePosition(id, spawn_x, spawn_y)
            SetSpriteVisible(id, 1)
            exit
        endif
    next i
return


// --- ATUALIZAR AS ABELHAS ---
update_bees:
    for i = 0 to 14
        if all_bees[i].active = 1
            id = all_bees[i].id
            SetSpriteShape(id,3)
// Faz a abelha voar em direção ao girassol (centro da tela)
            girassol_x = GetVirtualWidth()/2
            girassol_y = GetVirtualHeight()/2
            bee_x = GetSpriteX(id) + GetSpriteWidth(id)/2
            bee_y = GetSpriteY(id) + GetSpriteHeight(id)/2

            dir_x# = girassol_x - bee_x
            dir_y# = girassol_y - bee_y
            distance# = Sqrt(dir_x#*dir_x# + dir_y#*dir_y#)
            
            speed# = 1.0 + (score / 20.0) // Velocidade aumenta com o score
            
            if distance# > 0
                move_x# = (dir_x# / distance#) * speed#
                move_y# = (dir_y# / distance#) * speed#
                SetSpritePosition(id, GetSpriteX(id) + move_x#, GetSpriteY(id) + move_y#)
                
// Vira a abelha para a esquerda ou direita em vez de rotacionar
                if move_x# < 0
                    // Se está se movendo para a esquerda, vira o sprite horizontalmente
                    SetSpriteFlip(id, 1, 0)
                else
                    // Se está se movendo para a direita (ou reto para baixo), mantém o sprite normal
                    SetSpriteFlip(id, 0, 0)
                endif
            endif
        endif
    next i
return


// --- VERIFICAR COLISÕES ---
check_collisions:
    for s = 0 to 24
        if all_sementes[s].active = 1
            for b = 0 to 14
                if all_bees[b].active = 1
                    if GetSpriteCollision(all_sementes[s].id, all_bees[b].id)
                        PlaySound(id_som_acerto)
                        all_sementes[s].active = 0
                        SetSpriteVisible(all_sementes[s].id, 0)
                        all_bees[b].active = 0
                        SetSpriteVisible(all_bees[b].id, 0)
                        score = score + 1
                        SetTextString(id_texto_score_value, str(score))
                        gosub spawn_bee
                    endif
                endif
            next b
        endif
    next s
    
// Verifica colisão das abelhas com o jogador
    for b = 0 to 14
        if all_bees[b].active = 1
            if GetSpriteCollision(all_bees[b].id, id_girassol)
                gosub handle_game_over
            endif
        endif
    next b
return


// --- FIM DE JOGO ---
handle_game_over:
// Esconde todos os elementos do jogo
    SetSpriteVisible(id_girassol, 0)
    SetTextVisible(id_texto_score_label, 0)
    SetTextVisible(id_texto_score_value, 0)
    for i = 0 to 14 : SetSpriteVisible(all_bees[i].id, 0) : all_bees[i].active = 0 : next i
    for i = 0 to 24 : SetSpriteVisible(all_sementes[i].id, 0) : all_sementes[i].active = 0 : next i
    
    if score > high_score then high_score = score
    
// Tela de Game Over
    SetSpriteVisible(id_logo_titulo, 0)
    SetTextVisible(id_texto_jogar, 0)
    SetTextVisible(id_texto_sair, 0)
    SetTextVisible(id_texto_gameover, 1)
    SetTextVisible(id_texto_continuar, 1)
    
// Score final
    final_score_text$ = "Seu score: " + str(score) + " | Recorde: " + str(high_score)
    SetTextString(id_texto_score_final, final_score_text$)
    SetTextPosition(id_texto_score_final, GetVirtualWidth()/2 - GetTextTotalWidth(id_texto_score_final)/2, 220)
    SetTextVisible(id_texto_score_final, 1)
    
    game_state = 2
return
