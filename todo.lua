local chalk = require('../libs/chalk')
local json = require("../libs/json")

local green = chalk.green.bold
local yellow = chalk.yellow.bold
local title = chalk.cyan.bold


local function CarregarTarefas()
    local arquivo = io.open("tarefas.json", "r")
    if arquivo then
        local conteudo = arquivo:read("*a")
        arquivo:close()
        return json.decode(conteudo)
    else
        return {}
    end
end

local function SalvarTarefas(tarefas)
    local arquivo = io.open("tarefas.json", "w")
    if arquivo then
        arquivo:write(json.encode(tarefas))
        arquivo:close()
    else
        print("Erro ao salvar as tarefas.")
    end
end




local function LimparTela()
  
    local sistema = os.getenv("OS") or io.popen("uname"):read("*a")
    if sistema:find("Windows") then
        os.execute("cls") 
    else
        os.execute("clear")
    end
end


local function AdicionarTarefa(tarefas, nome)
    local novoId = 0
    for _, tarefa in ipairs(tarefas) do
        if tarefa.id > novoId then
            novoId = tarefa.id
        end
    end
    novoId = novoId + 1

    local novaTarefa = {
        id = novoId,  
        nome = nome,
        status = "pendente"  
    }
    table.insert(tarefas, novaTarefa)
    SalvarTarefas(tarefas)  
    print("Tarefa adicionada com sucesso!")
end


local function RemoverTarefa(tarefas, id)
    for i, tarefa in ipairs(tarefas) do
        if tarefa.id == id then
            table.remove(tarefas, i)
            SalvarTarefas(tarefas)  
            print("Tarefa removida com sucesso!")
            return
        end
    end
    print("Tarefa não encontrada!")
end


local function AtualizarStatusTarefa(tarefas, id)
    for _, tarefa in ipairs(tarefas) do
        if tarefa.id == id then
            if tarefa.status == "pendente" then
                tarefa.status = "concluido"
            elseif tarefa.status == "concluido" then
                tarefa.status = "pendente"
            end
            SalvarTarefas(tarefas)  
            print("Status da tarefa atualizado com sucesso!")
            return
        end
    end
    print("Tarefa não encontrada!")
end


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


local function SolicitarEntrada(mensagem)
    io.write(mensagem)
    return io.read()
end


local function Main()
    local tarefas = CarregarTarefas()  


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
            AtualizarStatusTarefa(tarefas, id)
        elseif escolha == "4" then
            print("Saindo...")
            break
        else
            print("Escolha inválida! Tente novamente.")
        end
    end
end

Main()
