# Projeto Configurando Postfix com Gmail

## Descrição
Neste projeto vamos provisionar uma VM utilizando o Vagrant iremos atualizar o sistema e instalar o postfix, através de um shell script. Além disso, iremos sincronizar uma pasta do host com o guest sendo a pasta "configs" do guest, para facilitar a gerencia de arquivos de configurações.

## Objetivos
- Praticar o uso de Vagrant com provisionamento via shell script.
- Automatizar a instalação do postfix e sua configuração.
- Sincronizar pastas entre o host e a máquina virtual para compartilhar arquivos de configurações.
- Treinar Git para subir o projeto no GitHub.

## Instruções para Iniciar a VM
Para que consiga utilizar este projeto é necessário ter instalado e configurado o Vagrant e algum virtualizador como virtualbox, vmware e etc. Todavia para teste foi utilizado o VirtualBox.

- [ ] Clone este repositório.
- [ ] Dentro da pasta execute o comando: `vagrant up`
- [ ] Para acessar via SSH a VM: `vagrant ssh`

## Provisionamento
Ao rodar o comando `vagrant up` irá subir a VM e conforme script será instalado os pacotes e configurado o postfix com o gmail.

## Testando o envio de e-mail

Para testar acesse a vm e digite:
```bash
echo "Teste de envio via Postfix + Gmail" | mail -s "Teste" SEU_EMAIL_DESTINO@gmail.com
```

Verifique os logs para ver se houve algum erro:
```bash
sudo tail -f /var/log/mail.log
```

## Sincronização de Pastas

A pasta `/home/configs_vm/` do servidor web(guest) é o espelho da pasta `configs` do host. Desta forma, qualquer modificação, criação ou deleção de arquivos ou pastas será vista tanto no host como o guest.

https://www.linkedin.com/in/eliezer-pires-sre-devops-aws