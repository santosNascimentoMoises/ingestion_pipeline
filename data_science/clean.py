import pexpect
import sys
import os

senha  = os.getenv("senha")
comando_make = "make memoria"

def comand(comando_make):

    child = pexpect.spawn(comando_make, encoding='utf-8')

    child.logfile_read = sys.stdout

    child.expect('(?i)\[sudo\].*password')

    child.sendline(senha)

    child.expect(pexpect.EOF)

    child.close()
    
    if child.exitstatus == 0:
        print("\n'make memoria' executado")
