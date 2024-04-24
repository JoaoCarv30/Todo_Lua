local chalk = require('chalk')

local green = chalk.green.bold
local yellow = chalk.yellow.bold
local title = chalk.cyan.bold

-- Função para limpar a tela do terminal
local function LimparTela()
    -- Verifica o sistema operacional
    local sistema = os.getenv("OS") or io.popen("uname"):read("*a")
    if sistema:find("Windows") then
        os.execute("cls")  -- Comando para limpar a tela no Windows
    else
        os.execute("clear")  -- Comando para limpar a tela em sistemas Unix-like
    end
end

-- Função para adicionar uma tarefa à lista
local function AdicionarTarefa(tarefas, nome)
    local novaTarefa = {
        id = #tarefas + 1,  -- ID único para a nova tarefa
        nome = nome,
        status = "pendente"  -- Por padrão, a tarefa é adicionada como pendente
    }
    table.insert(tarefas, novaTarefa)
    print("Tarefa adicionada com sucesso!")
end

-- Função para remover uma tarefa da lista
local function RemoverTarefa(tarefas, id)
    for i, tarefa in ipairs(tarefas) do
        if tarefa.id == id then
            table.remove(tarefas, i)
            print("Tarefa removida com sucesso!")
            return
        end
    end
    print("Tarefa não encontrada!")
end

-- Função para atualizar o status de uma tarefa
local function AtualizarStatusTarefa(tarefas, id, status)
    for _, tarefa in ipairs(tarefas) do
        if tarefa.id == id then
            tarefa.status = status
            print("Status da tarefa atualizado com sucesso!")
            return
        end
    end
    print("Tarefa não encontrada!")
end

-- Função para listar todas as tarefas
local function ListarTarefas(tarefas)
    print(title("-----------------Tarefas-----------------"))
    for _, tarefa in ipairs(tarefas) do
        if tarefa.status == 'concluido' then
            print(green(string.format("ID: %d | Nome: %s | Status: %s", tarefa.id, tarefa.nome, tarefa.status)))
        else
            print(yellow(string.format("ID: %d | Nome: %s | Status: %s", tarefa.id, tarefa.nome, tarefa.status)))
        end
    end
    print(title("----------------------------------------"))
end

-- Função para solicitar entrada do usuário
local function SolicitarEntrada(mensagem)
    io.write(mensagem)
    return io.read()
end

-- Função principal
local function Main()
    local tarefas = {}  -- Lista de tarefas

    -- Loop principal
    while true do
        LimparTela()
        ListarTarefas(tarefas)

        print(title("O que deseja fazer?"))
        print("1. Adicionar tarefa")
        print("2. Remover tarefa")
        print("3. Atualizar status da tarefa")
        print("4. Sair")

        local escolha = SolicitarEntrada("Escolha: ")

        if escolha == "1" then
            local nome = SolicitarEntrada("Digite o nome da nova tarefa: ")
            AdicionarTarefa(tarefas, nome)
        elseif escolha == "2" then
            local id = tonumber(SolicitarEntrada("Digite o ID da tarefa que deseja remover: "))
            RemoverTarefa(tarefas, id)
        elseif escolha == "3" then
            local id = tonumber(SolicitarEntrada("Digite o ID da tarefa que deseja atualizar: "))
            local status = SolicitarEntrada("Digite o novo status da tarefa (pendente/concluido): ")
            AtualizarStatusTarefa(tarefas, id, status)
        elseif escolha == "4" then
            print("Saindo...")
            break
        else
            print("Escolha inválida! Tente novamente.")
        end
    end
end

-- Inicia o programa chamando a função Main
Main()
