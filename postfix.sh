#!/bin/bash
# Ativa o modo seguro
set -e

# Função para exibir mensagens no terminal
log(){
    echo -e "\n==== $1 ====\n"
}

# Variáveis com os parâmetros
MAIN_CF="/etc/postfix/main.cf"
SASL_PASSWD_FILE="/etc/postfix/sasl_passwd"

# Atualização do sistema
log "Atualizando pacotes do Sistema..."
apt-get update -y
apt-get upgrade -y

# Verificando e instalando os pacotes.
if ! dpkg -l | grep -q "postfix"; then
    if ! dpkg -l | grep -q "debconf-utils"; then
        log "Instalando o debconf-utils"
        apt-get install -y debconf-utils
    else
        log "debconf-utils já instalado."
    fi
    # Configurar automaticamente a opção Internet Site
    echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
    echo "postfix postfix/mailname string localhost" | debconf-set-selections
    log "Instalando o postfix..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y postfix
else
    log "Postfix já instalado, ignorando."
fi
# Lista de Pacotes a serem instalados
PACOTES=("mailutils" "libsasl2-modules" "ca-certificates")

# Loop para verificar e instalar pacotes
for PACOTE in "${PACOTES[@]}"; do
    if ! dpkg -l | grep -q "$PACOTE"; then
        log "Instalando o $PACOTE..."
        apt-get install -y "$PACOTE"
    else
        log "$PACOTE já instalado, ignorando."
    fi
done

log "Configurando Postfix para usar Gmail SMTP..."

# Criar backup do arquivo de configuração original
cp $MAIN_CF ${MAIN_CF}.bak

# Configurar Postfix para usar o Gmail SMTP
sed -i '/^relayhost/d' $MAIN_CF
sed -i '/^smtp_sasl_auth_enable/d' $MAIN_CF
sed -i '/^smtp_sasl_security_options/d' $MAIN_CF
sed -i '/^smtp_sasl_tls_security_options/d' $MAIN_CF
sed -i '/^smtp_tls_security_level/d' $MAIN_CF
sed -i '/^smtp_tls_CAfile/d' $MAIN_CF
sed -i '/^smtp_sasl_password_maps/d' $MAIN_CF

echo -e "\n# Configuração para Gmail SMTP" | tee -a $MAIN_CF
echo "relayhost = [smtp.gmail.com]:587" | tee -a $MAIN_CF
echo "smtp_sasl_auth_enable = yes" | tee -a $MAIN_CF
echo "smtp_sasl_security_options = noanonymous" | tee -a $MAIN_CF
echo "smtp_sasl_tls_security_options = noanonymous" | tee -a $MAIN_CF
echo "smtp_tls_security_level = encrypt" | tee -a $MAIN_CF
echo "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" | tee -a $MAIN_CF
echo "smtp_sasl_password_maps = hash:$SASL_PASSWD_FILE" | tee -a $MAIN_CF

# Criar arquivo de autenticação SMTP
log "Criando arquivo de autenticação SMTP..."
bash -c "echo '[smtp.gmail.com]:587 SEUEMAIL@gmail.com:SEUTOKEN' > $SASL_PASSWD_FILE"

# Definir permissões e compilar o mapa de senhas
chmod 600 $SASL_PASSWD_FILE
postmap $SASL_PASSWD_FILE

# Reiniciar o Postfix para aplicar as mudanças
log "Reiniciando o Postfix..."
systemctl restart postfix

log "Configuração do Postfix concluída!"