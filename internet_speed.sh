#!/bin/bash

###  ##################################################################### ###
###      Script medicao de velocidade - Por Luiz Peterli - em 11/03/20     ###
###      Dependencias: speedtest mailutils postfix wget mutt dnsutils      ###
###  ##################################################################### ###



VARS3(){
###==================---------| VARIAVEIS DO HTML DE LOG |---------==================###

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADAS NAS MENSAGENS DE PUSH DOS CELULARES
###> QUANDO UM E-MAIL APARECE NO MENU PUSH DO SMART PHONE, ESSA MENSAGEM É MOSTRADA COMO DESCRIÇÃO
PSM=`echo "A estação $NDM reportou automaticamente "`

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADA NO RODAPÉ DA E-MAIL ENVIADO COMO LOG
###> MENSAGEM NO FINAL DO CORPOR DO EMAIL, ANTES DO RODAPE
MRP=`echo -e "Buenos Dias Muchachos :)"`

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADA NO RODAPÉ DA E-MAIL ENVIADO COMO LOG
###> ELA FICA LOGO A BAIXO DO CAMPO MENSAGEM, E APARECE DE FORMA CINZA CLARO COMO DESCRIÇÃO DO EVENTO
MTR=`echo -e "Report de medições de velocidade da internet"`

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADA NO RODAPÉ DA E-MAIL ENVIADO COMO LOG
###> É BASICAMENTE O NOME DA PESSOA OU EMPRESA RESPONSÁVEL PELA TAREFA DO EMAIL
NQV=`echo -e "Suporte de TIC"`

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADA NO RODAPÉ DO E-MAIL ENVIADO COMO LOG
###> ESSE CAMPO É O "Powered by" QUE VAI NO RODAPE ANTES O FECHAMENTO DO EMAIL
FPR=`echo -e "Powered by"`

###> ESSE CAMPO ESTÁ DENTRO DO CORPO DO HTML, E É MOSTRADA NO RODAPÉ DA E-MAIL ENVIADO COMO LOG
###> ESSE É O CAMPO ONDE O SEU E-MAIL OU O DA SUA EMPRESA É INSERIDO COMO REFERENCIA NO ARQUIVO
SWS=`echo -e "Luiz Peterli - jnr.lzcarlos@gmail.com"`


###==================---------| VARIAVEIS DE ENVIO DE EMAIL |---------==================##

###> INSIRA AQUI O E-MAIL QUE IRÁ ENVIAR O LOG
EQV=`echo "--@gmail.com"`

###> INSIRA AQUI O E-MAIL OU LISTA QUE IRÁ RECEBER O LOG
###> CASO QUEIRA ENVIAR O LOG PARA MAIS DE UM E-MAIL OS SEPARE POR VÍRGULA OU ESPACOS
EQR=`echo "--@gmail.com"`

###> INSIRA AQUI O TITULO DO EMAIL
TDE=`echo "Report de velocidade de internet em $DT2"`
}



COLOR(){
###> ADICIONANDO COR AO SCRIPT
BC="\033[1;36m" # Bold+Cyan (Negrito+Ciano - Azul Claro)
BB="\033[1;34m" # Bold+Blue (Negrito+Azul)
BR="\033[1;31m" # Bold+Red (Negrito+Vermelho)
BG="\033[1;32m" # Bold+Green (Negrito+Verde)
NM="\033[0m" # Normal
}

VARS1(){
###> FUNÇÃO QUE TESTA A COMPATIBILIDADE DO SISTEMA    

###> CARREGANDO A FUNCAO DE CORES
COLOR

###> LOCALIZANDO O PROGRAMA SPEEDTEST NA MAQUINA LOCAL
ls /usr/bin/speedtest-cli >/dev/null 2>&1

if [ $? -ne 0 ]; then
        echo -e "\n\n O programa ${BR}Speedtest$NM não fo localizado na maquina - Favor instala-lo com o comando:"
        echo -e "\n$BB wget$NM https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O ${BG}speedtest-cli$NM;$BB chmod +x$NM$BG speedtest-cli$NM;$BB sudo mv$NM$BG speedtest-cli /usr/bin/speedtest-cli$NM"
        echo -e "\n Favor, verificar se as seguintes dependencias estao instaladas:$BB apt-get install$NM$BG mailutils wget mutt dnsutils postfix -y$NM\n"
        echo -e " Verificar tambem se a maquina faz ${BC}relay de email${NM} pelo ${BB}Postfix${NM}, esse procedimento e necessario para o envio dos logs por e-mail\n\n"
        exit 1
    else
        echo -e "\nSpeedtest localizado - proseguindo com os teste\n" >/dev/null 2>&1
fi

###> VERIFICANDO AS DEMAIS DEPENDENCIAS
### DECLARANDO OS ITENS PARA A VERIFICACAO NO ARRAY A BAIXO
array=( 
     "mailutils" "postfix" "dnsutils" "mutt"
     )
###> CRIANDO UM LACO DE REPETICAO QUE CARREGUE EM UM LISTA CADA ITEM DO ARRAY
for i in "${array[@]}"
do
	### VERIFICANDO SE O ITEM DA LISTA DO ARRAY ESTA INSTALADO NO SISTEMA
    LTP=`dpkg --get-selections |grep $i |wc -l`
    ### CASO O ITE, ESTEJA INSTALADO ELE RETORNA UM NUMERO MAIOR QUE ZERO
    if [ $LTP -gt 0 ]; then
            ### CASO O PROGRAMA ESTEJA INSTALADO ELE MOSTRA A MENSAGEM A BAIXO 
            echo -e "Programa instalado" >/dev/null 2>&1
        else
            ### CASO O PROGRAMA NAO ESTEJA INTALADO A MENSAGEM A BAIXO E MOSTRADA
            echo -e "\nFavor instalar o programa ${BG}$i${NM} com o seguinte comando: ${BB}apt-get install${NM} ${BG}$i${NM} ${BB}-y${NM}\n"
    fi               
done
}




VARS2(){
###> DEFININDO AS VARIAVEIS DO SISTEMA PARA EXECUTALAS APENAS UMA VEZ

#ARMAZENANDO O NOME DA MAQUINA EM UMA VARIAVEL
NDM=`echo Speed-$(/bin/hostname)`

###> DEFINA AQUI O TITULO DO HTML
TCB=`echo -e "Report Speedtest" `

###> DEFININDO DIRETORIO PARA SALVAMENTO DAS IMAGENS DO TESTE
DIT="/tmp/Report/"

###> DEFININDO O ARQUIVO DE LOG HTML
LHL="report.html"

###> FORMATO LONGO DE DATA E HORA
DTI=`(date --date "now" +%A_%d_de_%B_às_%H:%M:%S_hrs)| sed 's,_, ,g'`

###> FORMATO CURTO DE DATA E HORA
DT2=`(date --date "now" +%A_%d_de_%B)|sed 's,_, ,g'`
}


global(){
###> CRIANDO O CABECALHO DO EMAIL PARA SER ENVIADO PELA FUNCAO: GLOBAL 
clear

###> CARREGANDO A FUNCAO DE CORES
COLOR

###> IDENTIFICANDO O SISTEMA OPERACIONAL PELO KERNEL
KRN=$(uname -a)

###> VERIFICANDO A COMPATIBILIDADE DO SISTEMA OPERACIONAL
case "$KRN" in
    *buntu*)
        ###> CASO O SISTEMA OPERACIONAL SEJA UBUNTU
        VARS1
        ;;
    *ebian*)
        ###> CASO O SISTEMA OPERACIONAL SEJA O DEBIAN
        VARS1
        ;;
    *icrosoft*)
        ###> CASO O SISTEMA OPERACIONAL SEJA EMBARCADO MICROSOFT
        SEM=$(cat /etc/[A-Za-z]*[_-][rv]e[lr]* |grep 'NAME="')
        case "$SEM" in
            *buntu*)
                ###> CASO O SISTEMA OPERACIONAL SEJA UBUNTU
                VARS1
                ;;
            *ebian*)
                ###> CASO O SISTEMA OPRACIONAL SEJA DEBIAN
                VARS1
                ;;
            *)
                ###> CASO O SISTEMA OPERACIONAL NAO SUPORTE O SCRIPT
                clear;echo -e "\nInfelizmente o script ${BR}não ofecerece${NM} suporte ao sistema operacional ${BB}$KRN${NM}\n";exit 1
             ;;       
        esac
        ;;
    *)
        ###> CASO O SISTEMA OPERACIONAL NAO SUPORTE O SCRIPT
        clear;echo -e "\nInfelizmente o script ${BR}não ofecerece suporte${NM} ao sistema operacional ${BB}$KRN${NM}\n";exit 1
        ;;
esac


###> CHAMANDO A FUNCAO QUE CARREGA AS VARIAVEIS DE SISTEMA
VARS2

###> VERIFICANDO SE EXISTE O DIRETORIO DE ARAMAZENAMENTO DOS LOGS - CASO NAO, SERA CRIADO
if [ ! $DIT ]; then
        echo -e "\nDiretorio ja criado, vamos que vamos\n" >/dev/null 2>&1    
    else
        mkdir -p $DIT
fi


###> INICIO DA EXPORTAÇÃO DO HTML DE LOG DA PARTE DE CABEÇALHO
echo -e "<!doctype html>" > $DIT$LHL
echo -e "<html>" >> $DIT$LHL
echo -e "  <head>" >> $DIT$LHL
echo -e "    <meta name='viewport' content='width=device-width' />" >> $DIT$LHL
echo -e "    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />" >> $DIT$LHL
echo -e "    <title>$TCB</title>" >> $DIT$LHL
echo -e "    <style>" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          GLOBAL RESETS" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      img {" >> $DIT$LHL
echo -e "        border: none;" >> $DIT$LHL
echo -e "        -ms-interpolation-mode: bicubic;" >> $DIT$LHL
echo -e "        max-width: 100%; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      body {" >> $DIT$LHL
echo -e "        background-color: #f6f6f6;" >> $DIT$LHL
echo -e "        font-family: sans-serif;" >> $DIT$LHL
echo -e "        -webkit-font-smoothing: antialiased;" >> $DIT$LHL
echo -e "        font-size: 14px;" >> $DIT$LHL
echo -e "        line-height: 1.4;" >> $DIT$LHL
echo -e "        margin: 0;" >> $DIT$LHL
echo -e "        padding: 0;" >> $DIT$LHL
echo -e "        -ms-text-size-adjust: 100%;" >> $DIT$LHL
echo -e "        -webkit-text-size-adjust: 100%; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      table {" >> $DIT$LHL
echo -e "        border-collapse: separate;" >> $DIT$LHL
echo -e "        mso-table-lspace: 0pt;" >> $DIT$LHL
echo -e "        mso-table-rspace: 0pt;" >> $DIT$LHL
echo -e "        width: 100%; }" >> $DIT$LHL
echo -e "        table td {" >> $DIT$LHL
echo -e "          font-family: sans-serif;" >> $DIT$LHL
echo -e "          font-size: 14px;" >> $DIT$LHL
echo -e "          vertical-align: top; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          BODY & CONTAINER" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .body {" >> $DIT$LHL
echo -e "        background-color: #f6f6f6;" >> $DIT$LHL
echo -e "        width: 100%; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */" >> $DIT$LHL
echo -e "      .container {" >> $DIT$LHL
echo -e "        display: block;" >> $DIT$LHL
echo -e "        Margin: 0 auto !important;" >> $DIT$LHL
echo -e "        /* makes it centered */" >> $DIT$LHL
echo -e "        max-width: 580px;" >> $DIT$LHL
echo -e "        padding: 10px;" >> $DIT$LHL
echo -e "        width: 580px; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* This should also be a block element, so that it will fill 100% of the .container */" >> $DIT$LHL
echo -e "      .content {" >> $DIT$LHL
echo -e "        box-sizing: border-box;" >> $DIT$LHL
echo -e "        display: block;" >> $DIT$LHL
echo -e "        Margin: 0 auto;" >> $DIT$LHL
echo -e "        max-width: 580px;" >> $DIT$LHL
echo -e "        padding: 10px; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          HEADER, FOOTER, MAIN" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      .main {" >> $DIT$LHL
echo -e "        background: #ffffff;" >> $DIT$LHL
echo -e "        border-radius: 3px;" >> $DIT$LHL
echo -e "        width: 100%; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .wrapper {" >> $DIT$LHL
echo -e "        box-sizing: border-box;" >> $DIT$LHL
echo -e "        padding: 20px; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .content-block {" >> $DIT$LHL
echo -e "        padding-bottom: 10px;" >> $DIT$LHL
echo -e "        padding-top: 10px;" >> $DIT$LHL
echo -e "      }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .footer {" >> $DIT$LHL
echo -e "        clear: both;" >> $DIT$LHL
echo -e "        Margin-top: 10px;" >> $DIT$LHL
echo -e "        text-align: center;" >> $DIT$LHL
echo -e "        width: 100%; }" >> $DIT$LHL
echo -e "        .footer td," >> $DIT$LHL
echo -e "        .footer p," >> $DIT$LHL
echo -e "        .footer span," >> $DIT$LHL
echo -e "        .footer a {" >> $DIT$LHL
echo -e "          color: #999999;" >> $DIT$LHL
echo -e "          font-size: 12px;" >> $DIT$LHL
echo -e "          text-align: center; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          TYPOGRAPHY" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      h1," >> $DIT$LHL
echo -e "      h2," >> $DIT$LHL
echo -e "      h3," >> $DIT$LHL
echo -e "      h4 {" >> $DIT$LHL
echo -e "        color: #000000;" >> $DIT$LHL
echo -e "        font-family: sans-serif;" >> $DIT$LHL
echo -e "        font-weight: 400;" >> $DIT$LHL
echo -e "        line-height: 1.4;" >> $DIT$LHL
echo -e "        margin: 0;" >> $DIT$LHL
echo -e "        Margin-bottom: 30px; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      h1 {" >> $DIT$LHL
echo -e "        font-size: 35px;" >> $DIT$LHL
echo -e "        font-weight: 300;" >> $DIT$LHL
echo -e "        text-align: center;" >> $DIT$LHL
echo -e "        text-transform: capitalize; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      p," >> $DIT$LHL
echo -e "      ul," >> $DIT$LHL
echo -e "      ol {" >> $DIT$LHL
echo -e "        font-family: sans-serif;" >> $DIT$LHL
echo -e "        font-size: 14px;" >> $DIT$LHL
echo -e "        font-weight: normal;" >> $DIT$LHL
echo -e "        margin: 0;" >> $DIT$LHL
echo -e "        Margin-bottom: 15px; }" >> $DIT$LHL
echo -e "        p li," >> $DIT$LHL
echo -e "        ul li," >> $DIT$LHL
echo -e "        ol li {" >> $DIT$LHL
echo -e "          list-style-position: inside;" >> $DIT$LHL
echo -e "          margin-left: 5px; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      a {" >> $DIT$LHL
echo -e "        color: #3498db;" >> $DIT$LHL
echo -e "        text-decoration: underline; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          BUTTONS" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      .btn {" >> $DIT$LHL
echo -e "        box-sizing: border-box;" >> $DIT$LHL
echo -e "        width: 100%; }" >> $DIT$LHL
echo -e "        .btn > tbody > tr > td {" >> $DIT$LHL
echo -e "          padding-bottom: 15px; }" >> $DIT$LHL
echo -e "        .btn table {" >> $DIT$LHL
echo -e "          width: auto; }" >> $DIT$LHL
echo -e "        .btn table td {" >> $DIT$LHL
echo -e "          background-color: #ffffff;" >> $DIT$LHL
echo -e "          border-radius: 5px;" >> $DIT$LHL
echo -e "          text-align: center; }" >> $DIT$LHL
echo -e "        .btn a {" >> $DIT$LHL
echo -e "          background-color: #ffffff;" >> $DIT$LHL
echo -e "          border: solid 1px #3498db;" >> $DIT$LHL
echo -e "          border-radius: 5px;" >> $DIT$LHL
echo -e "          box-sizing: border-box;" >> $DIT$LHL
echo -e "          color: #3498db;" >> $DIT$LHL
echo -e "          cursor: pointer;" >> $DIT$LHL
echo -e "          display: inline-block;" >> $DIT$LHL
echo -e "          font-size: 14px;" >> $DIT$LHL
echo -e "          font-weight: bold;" >> $DIT$LHL
echo -e "          margin: 0;" >> $DIT$LHL
echo -e "          padding: 12px 25px;" >> $DIT$LHL
echo -e "          text-decoration: none;" >> $DIT$LHL
echo -e "          text-transform: capitalize; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .btn-primary table td {" >> $DIT$LHL
echo -e "        background-color: #3498db; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .btn-primary a {" >> $DIT$LHL
echo -e "        background-color: #3498db;" >> $DIT$LHL
echo -e "        border-color: #3498db;" >> $DIT$LHL
echo -e "        color: #ffffff; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          OTHER STYLES THAT MIGHT BE USEFUL" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      .last {" >> $DIT$LHL
echo -e "        margin-bottom: 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .first {" >> $DIT$LHL
echo -e "        margin-top: 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .align-center {" >> $DIT$LHL
echo -e "        text-align: center; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .align-right {" >> $DIT$LHL
echo -e "        text-align: right; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .align-left {" >> $DIT$LHL
echo -e "        text-align: left; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .clear {" >> $DIT$LHL
echo -e "        clear: both; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .mt0 {" >> $DIT$LHL
echo -e "        margin-top: 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .mb0 {" >> $DIT$LHL
echo -e "        margin-bottom: 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .preheader {" >> $DIT$LHL
echo -e "        color: transparent;" >> $DIT$LHL
echo -e "        display: none;" >> $DIT$LHL
echo -e "        height: 0;" >> $DIT$LHL
echo -e "        max-height: 0;" >> $DIT$LHL
echo -e "        max-width: 0;" >> $DIT$LHL
echo -e "        opacity: 0;" >> $DIT$LHL
echo -e "        overflow: hidden;" >> $DIT$LHL
echo -e "        mso-hide: all;" >> $DIT$LHL
echo -e "        visibility: hidden;" >> $DIT$LHL
echo -e "        width: 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      .powered-by a {" >> $DIT$LHL
echo -e "        text-decoration: none; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      hr {" >> $DIT$LHL
echo -e "        border: 0;" >> $DIT$LHL
echo -e "        border-bottom: 1px solid #f6f6f6;" >> $DIT$LHL
echo -e "        Margin: 20px 0; }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          RESPONSIVE AND MOBILE FRIENDLY STYLES" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      @media only screen and (max-width: 620px) {" >> $DIT$LHL
echo -e "        table[class=body] h1 {" >> $DIT$LHL
echo -e "          font-size: 28px !important;" >> $DIT$LHL
echo -e "          margin-bottom: 10px !important; }" >> $DIT$LHL
echo -e "        table[class=body] p," >> $DIT$LHL
echo -e "        table[class=body] ul," >> $DIT$LHL
echo -e "        table[class=body] ol," >> $DIT$LHL
echo -e "        table[class=body] td," >> $DIT$LHL
echo -e "        table[class=body] span," >> $DIT$LHL
echo -e "        table[class=body] a {" >> $DIT$LHL
echo -e "          font-size: 16px !important; }" >> $DIT$LHL
echo -e "        table[class=body] .wrapper," >> $DIT$LHL
echo -e "        table[class=body] .article {" >> $DIT$LHL
echo -e "          padding: 10px !important; }" >> $DIT$LHL
echo -e "        table[class=body] .content {" >> $DIT$LHL
echo -e "          padding: 0 !important; }" >> $DIT$LHL
echo -e "        table[class=body] .container {" >> $DIT$LHL
echo -e "          padding: 0 !important;" >> $DIT$LHL
echo -e "          width: 100% !important; }" >> $DIT$LHL
echo -e "        table[class=body] .main {" >> $DIT$LHL
echo -e "          border-left-width: 0 !important;" >> $DIT$LHL
echo -e "          border-radius: 0 !important;" >> $DIT$LHL
echo -e "          border-right-width: 0 !important; }" >> $DIT$LHL
echo -e "        table[class=body] .btn table {" >> $DIT$LHL
echo -e "          width: 100% !important; }" >> $DIT$LHL
echo -e "        table[class=body] .btn a {" >> $DIT$LHL
echo -e "          width: 100% !important; }" >> $DIT$LHL
echo -e "        table[class=body] .img-responsive {" >> $DIT$LHL
echo -e "          height: auto !important;" >> $DIT$LHL
echo -e "          max-width: 100% !important;" >> $DIT$LHL
echo -e "          width: auto !important; }}" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "      /* -------------------------------------" >> $DIT$LHL
echo -e "          PRESERVE THESE STYLES IN THE HEAD" >> $DIT$LHL
echo -e "      ------------------------------------- */" >> $DIT$LHL
echo -e "      @media all {" >> $DIT$LHL
echo -e "        .ExternalClass {" >> $DIT$LHL
echo -e "          width: 100%; }" >> $DIT$LHL
echo -e "        .ExternalClass," >> $DIT$LHL
echo -e "        .ExternalClass p," >> $DIT$LHL
echo -e "        .ExternalClass span," >> $DIT$LHL
echo -e "        .ExternalClass font," >> $DIT$LHL
echo -e "        .ExternalClass td," >> $DIT$LHL
echo -e "        .ExternalClass div {" >> $DIT$LHL
echo -e "          line-height: 100%; }" >> $DIT$LHL
echo -e "        .apple-link a {" >> $DIT$LHL
echo -e "          color: inherit !important;" >> $DIT$LHL
echo -e "          font-family: inherit !important;" >> $DIT$LHL
echo -e "          font-size: inherit !important;" >> $DIT$LHL
echo -e "          font-weight: inherit !important;" >> $DIT$LHL
echo -e "          line-height: inherit !important;" >> $DIT$LHL
echo -e "          text-decoration: none !important; }" >> $DIT$LHL
echo -e "        .btn-primary table td:hover {" >> $DIT$LHL
echo -e "          background-color: #34495e !important; }" >> $DIT$LHL
echo -e "        .btn-primary a:hover {" >> $DIT$LHL
echo -e "          background-color: #34495e !important;" >> $DIT$LHL
echo -e "          border-color: #34495e !important; } }" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "    </style>" >> $DIT$LHL
echo -e "  </head>" >> $DIT$LHL
echo -e "  <body class='>" >> $DIT$LHL
echo -e "    <table border='0' cellpadding='0' cellspacing='0' class='body'>" >> $DIT$LHL
echo -e "      <tr>" >> $DIT$LHL
echo -e "        <td>&nbsp;</td>" >> $DIT$LHL
echo -e "        <td class='container'>" >> $DIT$LHL
echo -e "          <div class='content'>" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "            <!-- START CENTERED WHITE CONTAINER -->" >> $DIT$LHL
echo -e "            <span class='preheader'>$PSM</span>" >> $DIT$LHL
echo -e "            <table class='main'>" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "              <!-- START MAIN CONTENT AREA -->" >> $DIT$LHL
}

coleta(){
###> COLETANDO AS MEDIÇÕES AS INSERINDO NO MEIO DO HTML PELA FUNCAO: COLETA

###> CHAMANDO A FUNCAO QUE CARREGA AS VARIAVEIS DE SISTEMA
VARS2

###> VERIFICANDO SE O ARQUIVO DE CABECALHO EXISTE
if [ -f $DIT$LHL ]; then
        echo -e "\nScript de cabecalho ja existe - segue o jogo\n" >/dev/null 2>&1
    else
        echo -e "\nArquivo html de cabecalho nao existe - rodando o script com o parametro global\n" >/dev/null 2>&1
        global; coleta
fi                


###> CAPTURANDO IMAGEM COMA VELOCIDADE DA CONEXAO
/usr/bin/speedtest-cli --share > ${DIT}vlc.spd

###> SEGREGANDO O LINK DA IMAGEM GERADA PELO TESTE EM UMA VARIAVEL
VLC=`cat ${DIT}vlc.spd|grep "Share"|awk '{print $3}'`

###> VERIFICANDO SE A IMAGEM EXISTE, CASO NÃO, UMA MENSAGEM SERA INSERIDA
if [ -z $VLC ]; then
        CVR=`echo -e "Não havia internet na hora dessa medição"`
    else
         echo -e "A variavel contendo o caminho da mensagem esta populada, nada a se fazer" >/dev/null 2>&1
fi          



###> INICIO DA EXPORTAÇÃO DO HTML DE LOG DA PARTE DE COLETA
echo -e "              <tr>" >> $DIT$LHL
echo -e "                <td class='wrapper'>" >> $DIT$LHL
echo -e "                  <table border='0' cellpadding='0' cellspacing='0'>" >> $DIT$LHL
echo -e "                    <tr>" >> $DIT$LHL
echo -e "                      <td>" >> $DIT$LHL
echo -e "                       <p align="center"><font color='#1E90FF'>Report de $DTI</font></p>" >> $DIT$LHL
echo -e "                       <p align="center"><img src='$VLC' width=290 height=170>$CVR</p>" >> $DIT$LHL

}


envia(){
###> FECHANDO O HTML E ENVIANDO O EMAIL COM OS DADOS USANDO A FUNCAO: ENVIA

###> CHAMANDO A FUNCAO QUE CARREGA AS VARIAVEIS DE SISTEMA E DE HTML/ENVIO
VARS2
VARS3

###> VERIFICANDO SE O ARQUIVO DE CABECALHO EXISTE
if [ -f $DIT$LHL ]; then
        echo -e "\nScript de cabecalho ja existe - vida que segue\n" >/dev/null 2>&1
    else
        echo -e "\nArquivo html de cabecalho nao existe - rodando o script com o parametros global e coleta\n" >/dev/null 2>&1
        global; coleta; coleta
fi  


###> FINALIZANDO O HTML DE LOG E SE PREPARANDO PARA O ENVIO DO ARQUIVO
echo -e "                        <table border='0' cellpadding='0' cellspacing='0' class='btn btn-primary'>" >> $DIT$LHL
echo -e "                          <tbody>" >> $DIT$LHL
echo -e "                            <tr>" >> $DIT$LHL
echo -e "                              <td align='left'>" >> $DIT$LHL
echo -e "                                <table border='0' cellpadding='0' cellspacing='0'>" >> $DIT$LHL
echo -e "                                  <tbody>" >> $DIT$LHL
echo -e "                                    <tr>" >> $DIT$LHL
echo -e "                                    </tr>" >> $DIT$LHL
echo -e "                                  </tbody>" >> $DIT$LHL
echo -e "                                </table>" >> $DIT$LHL
echo -e "                              </td>" >> $DIT$LHL
echo -e "                            </tr>" >> $DIT$LHL
echo -e "                          </tbody>" >> $DIT$LHL
echo -e "                        </table>" >> $DIT$LHL
echo -e "                        <p>$MRP</p>" >> $DIT$LHL
echo -e "                      </td>" >> $DIT$LHL
echo -e "                    </tr>" >> $DIT$LHL
echo -e "                  </table>" >> $DIT$LHL
echo -e "                </td>" >> $DIT$LHL
echo -e "              </tr>" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "            <!-- END MAIN CONTENT AREA -->" >> $DIT$LHL
echo -e "            </table>" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "            <!-- START FOOTER -->" >> $DIT$LHL
echo -e "            <div class='footer'>" >> $DIT$LHL
echo -e "              <table border='0' cellpadding='0' cellspacing='0'>" >> $DIT$LHL
echo -e "                <tr>" >> $DIT$LHL
echo -e "                  <td class='content-block'>" >> $DIT$LHL
echo -e "                    <span class='apple-link'>$MTR</span>" >> $DIT$LHL
echo -e "                    <br> $NQV <a href='$SWS'></a>." >> $DIT$LHL
echo -e "                  </td>" >> $DIT$LHL
echo -e "                </tr>" >> $DIT$LHL
echo -e "                <tr>" >> $DIT$LHL
echo -e "                  <td class='content-block powered-by'>" >> $DIT$LHL
echo -e "                    $FPR <a href='$SWS'>$SWS</a>." >> $DIT$LHL
echo -e "                  </td>" >> $DIT$LHL
echo -e "                </tr>" >> $DIT$LHL
echo -e "              </table>" >> $DIT$LHL
echo -e "            </div>" >> $DIT$LHL
echo -e "            <!-- END FOOTER -->" >> $DIT$LHL
echo -e "" >> $DIT$LHL
echo -e "          <!-- END CENTERED WHITE CONTAINER -->" >> $DIT$LHL
echo -e "          </div>" >> $DIT$LHL
echo -e "        </td>" >> $DIT$LHL
echo -e "        <td>&nbsp;</td>" >> $DIT$LHL
echo -e "      </tr>" >> $DIT$LHL
echo -e "    </table>" >> $DIT$LHL
echo -e "  </body>" >> $DIT$LHL
echo -e "</html>" >> $DIT$LHL


###> CARREGANDO A FUNCAO DE CORES
COLOR

###> VERIFICANDO SE A MAQUINA POSSUI RELAY DE EMAIL PARA ENVIO PELA LINHA DE COMANDO
if [ -f /etc/postfix/sasl_passwd ]; then
        ###> ENVIO DO E-MAIL COM OS REPORTS
        mutt -e "set content_type=text/html" -e "set from='$NDM <$EQV>'" -s "$TDE" $EQR < $DIT$LHL
    else
        echo -e "\nO Script não encontou o arquivo ${BR}/etc/postfix/sasl_passwd${NM} relativo ao ${BG}Postfix${NM}"
        echo -e "Isso pode dizer que essa maquina nao esta fazendo relay de email, procedimento necessario para o envio do log"
        echo -e "No entanto, se o script executou os passos ${BC}global${NM} e ${BC}coleta${NM}, voce pode ver o arquivo de log em ${BB}$DIT$LHL${NM}\n"
        exit 2
fi


###> DELETANDO O ARQUIVO DE LOG APOS O ENVIO DA MENSAGEM
if [ -f ${DIT}${LHL} ]; then
        echo -e "\nDeletando os arquivos de log apos o envio\n" >/dev/null 2>&1
        cd $DIT; rm -rf ${LHL} vlc.spd *.png
    else
        echo -e "\nNao existem arquivos a serem deletados\n" >/dev/null 2>&1
fi 
}

###> INFORMADO OS PARAMTROS DO SCRIP
case "$1" in
"global") global ;;
"coleta") coleta ;;
"envia") envia ;;
*) clear;COLOR;echo -e "\nPor favor utilize um dos parametros: |${BC}global${NM}|${BR}coleta${NM}|${BG}envia${NM}|\n"
esac

exit 0
###> Fim do Script
