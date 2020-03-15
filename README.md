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

    sudo apt install curl mailutils wget dig mutt dnsutils postfix -y; wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O speedtest-cli; sudo chmod +x speedtest-cli; sudo mv speedtest-cli /usr/bin/speedtest-cli
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

![enter image description here](https://lh3.googleusercontent.com/_hCq2foyvJphrNYfRXB_Cf_W3c9BUd3gVkBAyRf27GUn4THFVnejqdIjDvD1QY5ocN0IHccSwvh-vUzDtNY-EJ7HFB-J8v03nQ_Ic1-N17VT-mJNxiqD-jz0tUCf2uyuV8_MM5aO880gIymu0dlIGbimvpAy15lm5O3TCQXND0v8IO_FfGy9xJOFqnjSNQPYicvc55_SFGXBcGLwSKtbl9oDTKpFnNhipkcQYmsdSYEKv1dkeQ4yKzhkfzeVzwXVxORcL43BOsh1jjaRavzsOTpTW9dlmGDjN_rOvxNxcVwRLcKQ5PO3pHW16yULxseAr-SDvDr1YXx5ape9sWonuuhP-aaM-sP3xW79ONNxweQJWEOop5ZnySS7oeYuvZRxuwIB0me6Cz3-pVW0lgQkiLB-es4OSIBd6fKvo4uUnj-hfc3UScU18EAXUtENTQmi-LCUxTcJh1siKz_ScxkxidxgZeSMMZjRAtMlzh_W3_SATECIYV_eqvfyZB77gpIYDJvAHqKlTA7A8G9Zlce5bzg3LOZ3FGG0EVpk0kRi62E3YJDsJwnF3hGLlzudUr9DcriIPFXR1-eEOT0FbakT2OsiG4bEia8LX8Gulnu5aT5q0_G8GbQ3s_R3ntJtsJO5YnPicE1li1txVp5gOJ60A7LeH8ZKpZIByERYv-j7dHig0oo5C9ruPKaY4v1ALU8fWCMNWjiAK_rdfn0qg8DBSkokkT1Va2NFdIFGVGsNP6GLm5P2urCQ4qc=w603-h256-no)

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

**`Considerações Finais`**

Como parte de um projeto aberto, voluntário e feito por hobby, não posso dar garantia de que essa ferramenta ira rodar em todos os sistemas em que ela se propõe a ser executada, com tudo, me coloco a diposição para ajuda e feedbacks, qualquer coisa é só entrar em contato pelo e-mail jnr.lzcarlos@gmail.com - Grande abraço a todos!
#


