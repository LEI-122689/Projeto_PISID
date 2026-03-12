import mysql.connector

try:
    ligacao = mysql.connector.connect(
        host="194.210.86.10",
        user="aluno",
        password="aluno",
        database="maze"
    )

    if ligacao.is_connected():
        print("Sucesso: Ligado ao MySQL da Nuvem!")

        # 2. Criar um "cursor" (é como o ponteiro do rato para escolher dados)
        cursor = ligacao.cursor()

        # 3. Executar o comando para ler a configuração do labirinto
        cursor.execute("SELECT * FROM setupmaze")

        # 4. Ir buscar os resultados e mostrá-los
        configuracao = cursor.fetchall()
        for linha in configuracao:
            print(linha)

except Exception as erro:
    print(f"Erro na ligação: {erro}")

finally:
    # 5. Fechar sempre a porta quando terminamos
    if 'ligacao' in locals() and ligacao.is_connected():
        cursor.close()
        ligacao.close()