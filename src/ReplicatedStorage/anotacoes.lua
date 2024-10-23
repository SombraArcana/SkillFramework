local Players = game:GetService("Players")

-- Função para criar uma bola de fogo
local function criarBolaDeFogo(jogador, poscaoInicial, anguloDeLancamento)
    -- Criar uma parte para representar a bola de fogo
    local bolaDeFogo = Instance.new("Part")
    bolaDeFogo.Size = Vector3.new(2, 2, 2)
    bolaDeFogo.Position = poscaoInicial
    bolaDeFogo.Color = Color3.fromRGB(255, 0, 0) -- Vermelho
    bolaDeFogo.Anchored = true
    bolaDeFogo.CanCollide = false
    bolaDeFogo.Parent = game.Workspace

    -- Calcular a velocidade inicial da bola de fogo com base no ângulo de lançamento
    local velocidadeInicial = Vector3.new(math.sin(anguloDeLancamento), 0, math.cos(anguloDeLancamento)) * 50 -- Velocidade ajustável

    -- Aplicar a velocidade inicial à bola de fogo
    bolaDeFogo.AssemblyLinearVelocity = velocidadeInicial

    -- Conectar um manipulador de eventos à parte para lidar com colisões
    bolaDeFogo.Touched:Connect(function(hit)
        -- Verificar se a bola de fogo colidiu com uma parte do cenário
        if hit and hit:IsDescendantOf(game.Workspace) then
            -- Destruir a bola de fogo
            bolaDeFogo:Destroy()
        end
    end)
end

-- Conectar um manipulador de eventos ao jogador para lidar com a ativação da habilidade
Players.PlayerAdded:Connect(function(jogador)
    jogador:GetMouse().Button1Down:Connect(function()
        -- Posição inicial da bola de fogo (próxima ao jogador)
        local poscaoInicial = jogador.Character.HumanoidRootPart.Position

        -- Posição do mouse para calcular o ângulo de lançamento
        local mousePosition = jogador:GetMouse().Hit.p

        -- Calcular o ângulo de lançamento com base na posição do jogador e do mouse
        local anguloDeLancamento = math.atan2(mousePosition.Z - poscaoInicial.Z, mousePosition.X - poscaoInicial.X)

        -- Criar a bola de fogo
        criarBolaDeFogo(jogador, poscaoInicial, anguloDeLancamento)
    end)
end)
