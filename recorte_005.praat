clearinfo

form
	sentence Dir F:\Monografia\PROBLEMA
endform

strings = Create Strings as file list: "trechos", "'dir$'\audios\extracted - 'audio$'\*.wav"
n_strings = Get number of strings

for i to n_strings
	select strings
	nome_arquivo$ = Get string: trechos#[i]
	nome_arquivo$ = nome_arquivo$-".wav"
	nome_arquivo = number(nome_arquivo$)
	sound = Read from file: "'dir$'\audios\extracted - 'audio$'\'nome_arquivo'.wav"
	t0 = Get start time
	t = Get end time
	
	txtgrd = Read from file: "'dir$'\audios\extracted - 'audio$'\'nome_arquivo'.TextGrid"
endfor