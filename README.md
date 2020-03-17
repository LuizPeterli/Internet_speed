# Shell Script Internet Monitor

O script de teste de velocidade de internet pelo terminal utiliza a linguagem Shell Script no terminal bash nos sistemas Ubuntu e Debian.  Através dele é possível fazer medições pelo terminal utilizando a ferramenta [speedtest-cli](https://www.speedtest.net/pt/apps/cli) montando um HTML recursivo para o envio das medições através de um e-mail, montado e enviado por linha de comando através da configuração de um smtp relay na maquina em que a ferramenta é executada.
#


**`A estrutura do Script`**

O script utiliza a estrutura de parâmetros, o primeiro deles é o **global** que tem a função de fazer verificações no sistema operacional da maquina a fim de identificar incompatibilidades, dependências e configurações, e também inicia a escrita do cabeçalho HTML em um arquivo de log temporário.

O segundo parâmetro é o **coleta** que propriamente dito é o core do script, ele faz as medições de velocidade pelo terminal e armazena o link das imagens geradas pelo teste, inserindo-os no corpo do HTML de log.

O terceiro parâmetro é o **envia**, como o nome já diz, antes de enviar o teste, ele fecha o rodapé do arquivo HTML de log, faz uma verificação no sistema operacional a fim de identificar se o recurso de SMTP Relay está ativo, dispara a mensagem, e apaga os arquivos temporários gerados pelo processo.
#


**`Dependências do script`**

Durante a execução acionada pelo parâmetro **global**  algumas verificações de dependências serão feitas, uma delas é a distro Linux, o script foi elaborado para ser executado em sistemas Ubuntu ou Debian, existe até mesmo uma lógica que verifica se um desses dois sistemas está embarcado dentro de um sistema Windows *10/2012/2016/2019*, porém outras distros que não sejam essas não serão capazes de executar a ferramenta.

Outra rotina executada é a busca pela ferramenta do [speedtest-cli](https://www.edivaldobrito.com.br/verificar-a-velocidade-da-internet/) que deve estar devidamente armazenada no local **/usr/bin/**

O próximo passo da verificação é checar se existem instalados no sistema operacional da máquina os programas: **curl mailutils postfix wget mutt dnsutils**

Sendo assim, basta executar o seguinte comando em um sistema Debian ou Ubuntu para habilitar a execução da ferramenta:

    sudo apt install mailutils wget mutt dnsutils postfix -y; wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O speedtest-cli; sudo chmod +x speedtest-cli; sudo mv speedtest-cli /usr/bin/speedtest-cli
#

**`Execução do script`**

Para executar o script com os parâmetros na ordem correta, devemos fazer o seguinte:

Primeiro dar permissão de execução a ele:
` sudo chmod +x internet_speed.sh `

Em seguida devemos executá-lo com o primeiro parâmetro:
`./internet_speed.sh global `

Depois executamos a coleta dos testes:
`./internet_speed.sh coleta `

E por último, o terceiro parâmetro, o de fechamento e envio do arquivo HTML:
`./internet_speed.sh envia `

Caso seja executado sem nenhum parâmetro o próprio script informará que necessita de um desses três para funcionar.:

![enter image description here](https://lh3.googleusercontent.com/yMohhQEyWXhCaNJmsDuVyeExGElrghn-mawvx3_6UaiiDt--z1BP2IczER6JtAtqIQ5gHdbQ5qLqf_qLagyK2aGqVDroobX3uXCVqtWrdKb4pcajcAYfr0GWWhjG5RvsO3OUxdtH486paeTnJ0xoMVTk_3Nx5pEkWVisC33iY7LuQhCFNKuH_nqRhbAhoUWpD3rpPW2RVAdYLFZK86gWBUBV0gIMnG67jZ7wpRV1GBsiG-aGlw2a6d0KNSJ54Darkf9jThlG8GH3Jr4qdBDlg89PIcyOywELiI2gRfZZ0qJ0dPUidDALdHtQB9C7y5NtIGtUW3TSb1mkF-IzrxFYBsXZectcahPaUc1lahuqCTOAwtLe5wmvA66pnVQ37GMsFKCUPYmHmFE2j3C9s70B1drlAj1L3icFfibs4SdbHLFAtAlg5Lct4qXGarHWafYvJq4ipAfDBtZTnZIkC6q-LDcFxcXqOk47ahhQ8_Bjp0vqdtJxO0EXyvfotc8IFuNoj2bWqS6FtAQTHCqoX4-iHRl4rh51x9FCHx_C1krFA5lqqDNdNoKjWApUsJspwU3G5WLeHFaq58bNXt6lEz06PL8_HFAv5SpXECsOcvGMU1icLc1RM_xuHU1cCEDul-mXnCQhMQ0bXbQLZmDlw4oFT0-w46LNYkX4BDDTsJt0SwUl5xZgfECE7M0lZbEl9fiyOXLkFtLS5-9XSPDOMUg3p3GSUNPs1J__s3ss0b62U4pLiG0kvPkiQ7U=w562-h165-no)

Caso ainda sim os parâmetros **coleta** ou * **envia** sejam executados sem o parâmetro **global** (que deve ser o primeiro a ser executado), esses dois últimos invocam automaticamente o parâmetro global para iniciar o arquivo de log, pois sem ele seria impossível montar o arquivo HTML.

É possível também executar o script em modo debug, para isso basta adicionarmos o comando **bash -x** no terminal bash:
`bash -x internet_speed.sh global `
#


**`Proteção contra quebras`**

Mesmo sendo criado inteiramente em Shell Script a ferramenta possui redundâncias que biscam prevenir falhas de execução, rechecagem de variáveis, segmentação de blocos para evitar rotinas muito grandes, limpeza de arquivos temporários de logs, porém mesmo assim pode ser que ainda hajam falhas, o quanto antes eu as descobrir irei as concertando, assim como irei melhorando ainda mais o código da ferramenta com o tempo, que teve a sua primeira versão criada em 2017.

**Eu sei que existem métodos melhores, mais práticos e robustos de se fazer o que esse script se propõem a fazer, eu mesmo sou utilizador do Zabbix e do Grafana, porém a diversão e desafio me motivam a continuar escrevendo esse arquivo.**
#

**`Variáveis Internas do Script`**

A ferramenta conta com alguns blocos de variáveis, porém pelo menos um deles é crucial o preenchimento por parte do usuário ou administrador antes da execução do mesmo. Esse bloco de comandos seria o **VARS_HTML**  (que na versão atual começa mais ou menos pela linha 10 do arquivo) que refere as variáveis que serão escritas no arquivo HTML e os endereços de origem e destino de e-mails a serem enviados via SMTP Relay do sistema operacional da máquina.:

![enter image description here](https://lh3.googleusercontent.com/kTgwwoQT2MFJl2vIdJBo_PRAPnDXY458g7-Ui66RbNvIVRDXb4m9twZv9HUrttC_9S0IpkaGl556ieiI5BnlXR6QzGtj3W2LrLkJ-OTUVZke-vgPP0Y9iuhdLDqgMyMDD1RubKJW-U7gzeiorjd6wIjJqWsW42KX-nR0udl-QTsPWhoRYpfYSt4mAGuEst5EHy_aH9C3hc9SKDZuvq4jsLa6YNpNXvSbDFa9nggpqxsYor66QpWtPBnTsJ0hmt-kQyZQAiUnIqmseLIw0Hl0tqKbBLjs_T8xhG13Tp4QQgsNGG7pN_68NYlxUWarTOqHl1b_f1-X354jGDUCzr8WV7DODfRp2_6lHWgJuKnWw-9t4wlwT_oVJAqHuKfHLsL2NbeTN0b24SNVW0ZWFyBToypnYuo8acO0rYfOp1MO59OSwnnSzjcHoWNa4rg7IaGGcFq4J0BaIPUMya5d6kyLvgXm9VA3lON0vRsRu2jfkUJ1BevJIXf1lWZFiXcuJsDQ1ZfLgca9jBp1_HYMkzKSKEmcBuSyFdlr1HzEukaH0uC7fAn3tACUnEx0wZVRW4hYxXOwj6tBFPx8tKi6whmmREdFU7wE2eCt_RVwlgFT-IDPMCrMcJ-kaHpNrfm-3kqK2e-KZOs307glUKfGLziIkplqv9m55YFX_IOPQPJpi85tI4BedVX5mVNfpThGUMsVnDGYvBbcSA_LeC_NU1KSoD1ZeCj9ADJz4NohlVzZpLmUmd74PKWAiGY=w925-h504-no)


#
**`Limitações do Script`**

Infelizmente na versão atual o script suporta apenas seis medições consecutivas por log, mais medições que isso podem quebrar as tabelas internas do HTML e desconfigurar o arquivo de log enviado por e-mail.

Fora isso não há limitações por parte do HTML, que por ser recursivo, se adapta muito bem tanto a visualizações em desktops quanto por dispositivos móveis:

#

**`Executando o Script`**

O ideal seria colocar o script em execução automática pelo cron da máquina, e como temos a limitação de seis medições por arquivo de log, o ideal é agendar a execução da ferramenta pelo arquivo crontab da máquina, para uma medição diária de velocidade de internet, podemos usar os seguintes parâmetros no cron da estação.

Partamos do exemplo que o scipt esteja armazenado no diretório **/script**, veja o exemplo de como ficariam as entradas dele no crontab **/etc/crontab** da máquina:

```
## Medindo a velocidade da internet
## 0 - Coletando criando o cabecalho do script e aguardando as coletas
00	07	*	*	*	root	/scripts/internet_speed.sh global
## 1 - Primeira coleta de informacoes de velocidade da MANHA
01	08	*	*	*	root	/scripts/internet_speed.sh coleta
## 2 - Segunda coleta de informacoes de velocidade da MANHA
02	10	*	*	*	root	/scripts/internet_speed.sh coleta
## 3 - Primeira coleta de informacoes de velocidade da TARDE
03	12	*	*	*	root	/scripts/internet_speed.sh coleta
## 4 - Segunda  coleta de informacoes de velocidade da TARDE
04	14	*	*	*	root	/scripts/internet_speed.sh coleta
## 5 - Primeira coleta de informacoes de velocidade da NOITE
05	16	*	*	*	root	/scripts/internet_speed.sh coleta
## 6 - Segunda coleta de informacoes de velocidade da NOITE
06	18	*	*	*	root	/scripts/internet_speed.sh coleta
## 7 - Envio do arquivo de log
10	18	*	*	*	root	/scripts/internet_speed.sh envia
#

```

#

**`Modelos do e-mail de log`**

Seguem a baixo modelos dos e-mails enviados pelo script via SMTP Relay do sistema operacional da máquina:

**Modelo Desktop**

![enter image description here](https://lh3.googleusercontent.com/ltB2z76GlgD6K267JDGCuUjbCjtXP__y58BKWAzPZDAQW9xCW4ctGFS3fc6wl2EHZ6SsomC868nK0jPzbkGb58VWChGMhSzUgtvtMNz6giokaEk_S8yhmdydfZfZZkGuUyDsQJ6Gt97DK12nFVaaw7EGM0BKvl97fYaOLGT4KM2Nkq4i6O6e_3Kc-RwfzOqQ7wKGp0xBY0tTB2G9judj5HNeLIo37AEfBxfCpPwIQ0IgWUmbbFfEGnR9aoxLip3x988zEr12JQypgVChs-1RDUzy24QtAtzHwRtYQGlX74laThy8MRPe30gL51jp8HTkW69kWN4TMb7Oa11gWMo0UP9NBMFfZsaYssZDSO-PVKaEa-ndho5n_bSJiCwhSXU0l9LcXpd0pnFJRNb6HOytQxztwO_sHYOZplYWYx1jllDAo4rS3FuGwdL3ew6xr5XsgtSgEahy0ubUKJ5jDg-VVRCbjAwOpEkSUxelECo7bTNQZ03MJiMgvM7NYWgsQfN3DGnfFOoSVoL3KZFfqiiS5HvXRwPaPIoSnHcjn1tN4pBTqZiuP1gMVr27kogFm0WsMO-vDGTypbgaQ4OHsdu9cqEqs2--ZzyDrrJwEO5qM0Nl17lxgyeHjMmWsIpO8Gk2VKqrHty24JDTShhibqN-66YIRqnyvWQrkQCqRNu2o2yq7-5vJxH9MK62sWEuvM7Itfl-oaDglqNjr2U_uJyEX-VYceoGYpUgnTZ3hzFjUk5bQV8lNiQ1eGw=w636-h622-no)



**Modelo Mobile**

![enter image description here](https://lh3.googleusercontent.com/ie6pwxDccly-LZqusV5zsJQr-5vJV92pYIPqynYPpzc7PKgdzhO3ArMJzfSHWhE2lenJShWs5V5DGRUYDmdd0c9HBcgnW4ZxCii4iEALWd8PWGeVsn3r3m3FFv6BclGYlOFGCUSqb99ddCp0_1ckcF9P1Kej32S04QItBQiiVdl5y9iT7iJ_SQ4DzyED94pQsz26FX4Kepem_i5dwFw2xuhnBMR9Fin4z2xWpzSqLOYb5rXivV45Sge2SZwKH4WuBfWiyS9PgqjKTwZ4vEvNDQvyhs9HzR_Z8hAsTozMdddvj7A9lWdWbuUIQnN15emjGoR_mr7APm9GM5KY43HEL5-mTJriOmFSLxfaPiyaOVL8_V4hJ8-uILR-oTxH9GYn8ILSVGzWmosmfZatdvPdekkiCE_Mgrlrs6knWqAlzcljBCb861E_JIZY2MfFOxOYDh6Z8amBsBhvZBbU9ZvV5OjpTyCibElUrUOiIP-LqM64SaMQFWvXVXL0oA_uBJ8rFScs1QTe-OtoVKTxCOI28PwhM22wG-Ae_5BMjwz1a_HYhE6i-EV6XRjwnw3jCr8nyCClWJlnRCOeybmuFczDdea6Nph27dU3sJpg71F4E0JPNqMtsupis8yXiw1ykcCxM_gF_HYrXJAxFG9c7BS2PEXAgmdE7rLyIy7jqRnad2Gc0Y_4lu9o-kmRRkvyElWkoG9sM4XSnJ0uyD9uhbVwP9IWaYK-qKD6HsA857flifpXOb6y-6NfsEg=w324-h622-no)

#

**`Arquivo de HTML de log`**

O arquivo HTML de log é formado por um código recursivo qeu se adapta tanto a telas de computadores quanto de despositivos móveis, o modelo utilizado nessa ferramenta é uma edição do projeto original que pode ser converido aqui nesse [link](https://github.com/leemunroe/responsive-html-email-template), com tudo ,segue também junto a esse projeto uma amostra de tódo o código HTML que é utilizado nessa ferramenta.
#

**`Considerações Finais sobre o script`**

Como parte de um projeto aberto, voluntário e feito por hobby, não posso dar garantia de que essa ferramenta ira rodar em todos os sistemas em que ela se propõe a ser executada, com tudo, me coloco a diposição para ajuda e feedbacks, qualquer coisa é só entrar em contato pelo e-mail jnr.lzcarlos@gmail.com - Grande abraço a todos!
#

## STMP Relay

**`Fazendo STMP Relay`**

Vamos criar aqui um exemplo de configuração de SMTP Relay para ser usado junto a um e-mail da Google, porém também já o utilizei com e-mails Microsfot.

 **1**. Durante a instalação do smtp *`(apt install postfix)`* configure o seu e-mail na tela que a instalação do Postfix lhe perguntará. Ex: *`seuemail@gmail.com`*
 
 **2**. Faça um backup do arquivo de configuração do Postfix e em seguinda abra o arquivo de configuração com o seu editor favorito, no exempo a baixo usarei o vim:

     cp /etc/postfix/main.cf /etc/postfix/BKP.main.cf; vim /etc/postfix/main.cf

 **3**. No final do arquivo de configuração do postfix, adicione as seguintes linhas (lembre-se de fazer as adequações pro seu e-mail):
 
    relayhost = [smtp.gmail.com]:587
    ...
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_security_level = encrypt
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

Caso já exista um campo chamado `relayhost =` basta apagá-lo e colar o bloco a cima no arquivo, ou então preenchê-lo com a informação depois do caractere **=** e ignorar esse campo do bloco a cima.

Um outro detalhe é o campo **inet_protocols** que fica no final do arquivo **`main.cf`**. em máquinas que não conseguem resolver classes de IPv6 o envio de e-mail pode ser perder tentando resolver endereços da Google, a saída nesses casos então é alterar o campo: `inet_protocols = all` para `inet_protocols = ipv4` como mostra a figura a baixo:

![enter image description here](https://lh3.googleusercontent.com/8laVP9uFmoh6C77Xx0nKL4ZJ3F5caG1kOT643f1wADLoCmY33o4CSIV4pSXY-uRdFCuBhOXOFjsSE7wadLgA4j2eK9Wz0VYV7i1wxd3sb_e13OCaBAOzbfWxKVrGuxBJsfLIS-id8BLQgc0M9VvzWmnon7VgNnUaRz_xYKVll1KNOOLR3We-n7f6wOIOnLi7DGDNxN2djyyH0kqoMqiYp9KNL5oNUNPUQEVBSiRoBt6MG-Wo4F5SxNBDsSPFDmvsz_2az64Tn5dEga1oW1qJNyAwMGvCnJIq6phjxkjFawHVONfWNykIa6KbctUDIMiSFDpMA9XV5ZG2JTbJY3X0CCSom9R0J21xxBjcZLP9RwwZbOFKZlt9Xp74wcyFnUcPb5LuxQu6ySDetXWSTIN04eOsH_CjVIB2vcxIcROs8kxzY_CDJtkxGd3PkH-EoKVSZEJm2_dWyAWtgmN-CyWfbmkfo_vH6hdnvzA2QoApte-W955D8MFAqoJs7_hPAY9VVvFQCGR1KkvFQdEguoOmIudDQEoj9MHnhLNhvuMxqeBFMPBxMyQza-0urFHEeNqTEyAgkq5BgHTocng1R2rEEmPdddaNSIrdoOtjc47nBPTHGL6V7Z1r8Gyn5oWCs5LfnIzurDN3NB4S-qHhMmpzhuJcKOmVJAlbCucXl7DV829afmCQt_TVsW253kqCmD0iMWv-HdFVUdsDoOeYRBRQk3zRb6nA1LSSIHCUvJufQoATcg741lqE-sA=w711-h297-no)



 **4**. Vamos criar o arquivo **sasl_passwd** e preenchê-lo com as informações da conta:

    vim /etc/postfix/sasl_passwd

Dentro dele vamos colocar as seguintes informações:

    [smtp.gmail.com]:587 seue-mail@gmail.com:suasenha

 **5**. Vamos proteger o arquivo com as informações sensíveis de usuário e senha:

```
chown root:root /etc/postfix/sasl_passwd; chmod 600 /etc/postfix/sasl_passwd
```
 

 6. E por último, vamos criar o banco com as informações de usuário e senha de e-mail e restartar o serviço do postfix com os seguintes comandos:

```
postmap /etc/postfix/sasl_passwd; sudo systemctl restart postfix
```

 7. E por último, tente enviar um e-mail de testes pelo terminal e veja se ele chega no destino:

```
echo "Test Postfix Gmail Relay" | mail -s "Postfix Gmail Relay" email-de-destino@gmail.com
```
#

**`Debugando o STMP Relay`**

Caso o e-mail via terminal não chegue ao destino, tente verificar o arquivo de log dos e-mails, faça isso com o seguinte comando:

    tail  /var/log/mail.log

Ou abra outro terminal, e fique monitorando o arquivo de log enquanto vc envia o e-mail de teste pelo primeiro terminal, para isso você pode usar o parâmetro **-f** no comando tail:

    tail -f /var/log/mail.log
#

**`G-mail e os Aplicativos menos seguros`**

Se por algum motivo você estiver percebendo problemas no envio de e-mail, e entradas no log como "sasl falha de autenticação" veja se a opção de logins de aplicativos menos seguros está habilitada no seu G-mail, você pode fazer isso no seguinte [link](https://myaccount.google.com/lesssecureapps).

Veja o exemplo de como esse erro é descrito no log dos e-mails do sistema:

![enter image description here](https://lh3.googleusercontent.com/JvANnJaQ5wqNFAlFqa8k7lmMZ9XOOLb6tcahlNIgwgWQD7G7Lz6oBfTLag7ypcl3cSMmO6yOoTuv05gpRUQMMNzsWYwvOwex5PiHmLkA9QQV5cPnIkzue7dZYK58VageSnjYCXnejyIAKkdycH31ZlCIy8EXLS3OhQ9GXgcnax1rzFR2tvtIXzLNCwTClaWbjtL_hb3JsSuKLa1Be7IsjG8ZtsJJ6xFllyw1PjLtKOUteYqYsSZXkmC8-7e401GOb1oGoDzpkS6j-nRDfIFoTc3UmAEVJyKz5h4Hx3o67tb1KGENM4_yQbtAKs2YvrCbrexOkhQqjoz4u21snX8ooGF84xTVFeOAbFkYfF2oXOH-OSfmW22BMeHpMCrUPA2EWhYkX1Dxpu-XDHeUqBDnmyKY0-__2QV1IyCpkBzdpP9W-GbofnmDhUNe-BE21j3p-7gUyS7ySPWh3nEfdtDaz5Kh6MUzYYekDIc5RPGo0HB2xG1640vsZ8Ve21Wi_FGZPHhFeGEX5iOnnRf1zkBn74AaazlN8qvDDjtNsaip81mG_czzLIVRqF5lV0fDL3ZC4gD_SY56w5N69tDD96FGgiNUAavptSo0XdBDbxTayMDmCQkBJJN4PwRdohOykjtdhoUcA_JxUkyHQasghmWoRHxdlpmnUSrdQ4vnEZwaenVdtS19d_D3BbQ10GLSLdH6rPup2EjJUYWByluNMSZK-ux5LMbISXoGnlENp3UFjbMBX_I9gyV5Ls8=w819-h111-no)
#

**`Executando o script em vários servidores com a mesma conta de email`**

Se mesmo após os procedimentos a cima estarem certos e a máquina com o Relay de SMTP ainda não estiver disparando os e-mails, pode ser que você tenha configurados muitas máquinas diferentes para enviar os logs de teste de velocidade por um único endereço de e-mail.

Isso se resolve se você estiver na máquina que está disparando os e-mails via relay, ou em alguma outra máquina que esteja na mesma rede que a máquina que esteja disparando o relay (é importante as duas terem o mesmo IP público), logue no seu e-mail via navegador, e abra a mensagem que informará uma atividade de login bloqueada:

![enter image description here](https://lh3.googleusercontent.com/B9qb02QOb-8CMezwSLVVpSa_2CPiC1EqFp7wlNIE7jHF6WNdM1S6Dg_FE20W41Zc2Fauq8kC_uizlpm8x_HCCpnaWob6ypfTb7Gs0X_CxuVG_LvZCLfLuOzixesG4E7_0SpWmegekz7tAO9tbSgi84bkapAvdgVP0Los_Y2wp0zCr1eGiSHXTTnOTJi5TO930AxqHiLGIs1UhihSGL64Kf76hp7hIspqq0pMZ-k5VIiikq5GbizjZXvPOkw2tMCj4uaYDe_lPBZPpOGYXP-yG_hhiJOhK7C7yvTCKPrTpm4tIZqdZgOnx30AAVk5TUOljG8mwaPe2_nUq0Mc7UEIYVWTzfp4UpHXFoyqd5hsYohwClA_dfOXNpFpk6qq-Jhj1vtzPU7WiOQlAGnlWG4HE8YgVv-yP-mQat8FL3avE7EPMK4jnMxvDgp0rg7XyopbX42sxwIQp_6pnbQ8tPctXBlx3oyuvlITHJwhIDMd8xNlnuIT6s0wi7cbW90Vlni3RccKCTmzNhYkp_R0q4PAr4L4pnz37W05e2uJYZAF91cRNUywohJD0g4d9CNHfNuGe9M7k0TfOV9QWxvISJ8v_d2RE_R0fLk5QhBw8n6mWtv5biPKFa10oYI9zXwh9_WWKjgoThAfGrVjlHT5eFCWA6-yoqwCpis6nR0kfwA1KCdoVa4Zgr8R7xQmWxYZMxwxDHyKCsLbqlIFP9nwmR8TXN7thxxjrX_3tPa4PFWzwswUioEAeFUgr2c=w541-h446-no)

Certifique-se pela data e hora que foi mesmo a sua tentativa de login, e se tudo estiver certo, clique em **verificar atividade** e em seguida confirme que foi você e autorize o login:

![enter image description here](https://lh3.googleusercontent.com/klHwu0j0fynLqWJMYNly7CGkkp8X31GYUhaNJiMRK6gFT4ajCB7Hez2VgcETpFLB8lf_xmodtX_100W1cEGflWqmRaMpG4v_ZW5DpjjyjMt3puJ7cAFvWr29j95IoiUnhjZeZWasRyWeEKmZxT9iaEQWdv2mXcBq_PR2VrH2G5p21V6QlIE_EER2FUvAlAZ6nN3Yp9pdekaZSxoZeEcz2aLUbSJjqSGEYRzmIhtLERzDE1_na4GpKq9bjG2VrbdxqkakFaaxbtBt32tAANvaOYA36C7pjUM4GF2zHW3UJ2vmPonqE4oitYrq6RWhmI5QXKkJvACsBOsL87NHw8viHxcAIcx9aHFxgn-mBzYyl1Zb-G-250Uo2-PHv_6kEEexJ_Q3NJ30LIRTTUX9Ttxtn9ytcjM81v-Snv4h73mPdz_3RUtzon69ybexX-lGM3QD3WK97Gp-5BKgLcBe3qW13EYNs2ddzgzjvo6yriJeqr-cdfuWG4rQDGhkctQUX6dfvHluK4LWJ55RykZ3d1zPS02YI3qjIAHa_SxRZ1Wx_VQ06iPJBVXdXKLlS_5v5fAODAMPQooPSsYw3sg4CxNfl8BdIa_0slxjGxKAbEowGbW6a9tJB9ucvGXy4ns5R-miABnZdfmqmfMqf6gWkW4wXGFR9Skv5UNLWuh4nb6ique3M4RgSqrcBbTwfBq40jOs8xp5PkO7_gXAu3RzP4AetDzvoe_ocWBRskjerSkZxmqhYUr_GBGpZk4=w553-h533-no)

E com isso você já deve conseguir enviar e-mails pelo terminal normalmente, agende as coletas e envios do script de teste de velocidade e seja feliz =)
#
