clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\Experimento\
endform

sp = Read from file: "'dir$'\bmedsp03_1a - extracted\*"

#repetir o processo com o segundo áudio
ts = Read from file: "'dir$'\bmedts10_1 - extracted\*"



