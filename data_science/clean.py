import pexpect
import sys

senha = '1234'
comando_make = "make memoria"

def comand(comando_make):

    # Inicia o processo em um pseudo-terminal
    child = pexpect.spawn(comando_make, encoding='utf-8')

    # Isso é útil para depuração, pois imprime a saída do comando em tempo real
    child.logfile_read = sys.stdout

    # Espera por uma linha que contenha '[sudo]' e 'password' (insensível a maiúsculas/minúsculas)
    child.expect('(?i)\[sudo\].*password')

    # Envia a senha para o processo
    child.sendline(senha)

    # Espera o comando terminar completamente
    child.expect(pexpect.EOF)

    # Fecha a conexão
    child.close()
    
    # child.exitstatus será 0 em caso de sucesso
    if child.exitstatus == 0:
        print("\nComando 'make memoria' executado com sucesso!")
    else:
        print(f"\nERRO: O comando falhou com o código de saída: {child.exitstatus}")
        print("A saída do processo foi mostrada acima.")
