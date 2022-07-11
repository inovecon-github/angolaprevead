# angolaprevead

- Baixar os arquivos baseline.zip e moodledata.zip
- http://baseline.ead.inovecon.com.br/GET/

# Descompactar para as pastas
- baseline.zip > app_ead/

# Para o docker hub
- 1º > docker login
- 2º > docker biuld -t "NOMEdaIMAGEM" .
- 3º > docker tag <NOMEdaIMAGEM> inovecon/inovecon-ead-angolaprev:TAG
- 4º > docker push inovecon/inovecon-ead-angolaprev:TAG
