#!/bin/bash

# Este script cria na pasta atual um arquivo para cada stored procedure
# Recomenda-se executar periodicamente e colocar sob controle de SVN ou GIT

# Modificar aqui (configure o pg_hba ou use .pgpass)
SERVIDOR=192.168.0.1
USUARIO=rednaxel
BANCO=rnge2

# Inicio do script
PARAMS="-U $USUARIO -d $BANCO -A -t -q --pset=pager=off -h $SERVIDOR"
CMDSQL="SELECT proname FROM pg_proc WHERE proowner = (SELECT usesysid FROM pg_user WHERE usename = '$USUARIO') and probin is null ORDER BY 1"
#echo $CMDSQL  #debug
psql $PARAMS -c "$CMDSQL" -o LISTA.TXT
for arq in `cat LISTA.TXT`
do
  echo $arq
  psql $PARAMS -c "SELECT pg_get_functiondef(proname::regproc)||';' FROM pg_proc WHERE proname = '$arq'" -o $arq".sql"
done

# Fim do script
echo "OK"
