clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\For real now\1) Familiarização
	sentence Nome
	word Sigla 
	natural Idade
	choice Sexo 1
		button F
		button M
	choice Escolaridade 1
		button Ensino Médio incompleto
		button Ensino Médio completo
		button Ensino Superior incompleto
		button Ensino Superior completo
endform

#Cria uma pasta para os resultados.
createDirectory: "'dir$'\resultados\"
createDirectory: "'dir$'\resultados\'sigla$'\"

#Cria e/ou preenche uma tabela com os dados da ficha social.
if fileReadable ("'dir$'\resultados\info_participantes.txt") = 0
	writeFileLine: "'dir$'\resultados\info_participantes.txt", "nome'tab$'sigla'tab$'idade'tab$'sexo'tab$'escolaridade"
endif
appendFileLine: "'dir$'\resultados\info_participantes.txt", "'nome$''tab$''sigla$''tab$''idade''tab$''sexo$''tab$''escolaridade$'"

#Cria tabela que cronometra tempo de realização de cada parte.
if fileReadable ("'dir$'\resultados\tempo_por_enunciado.txt") = 0
	writeFileLine: "'dir$'\resultados\tempo_por_enunciado.txt", "participante'tab$'data'tab$'tarefa'tab$'tempo inicial'tab$'tempo final'tab$'tempo total"
endif

#Treinamento Praat
etapa$ = "treinamento"
clearinfo
print Este é o Treinamento Praat
sound = Read from file: "'dir$'\audios\Praat\frase.wav"
txtgrd = Read from file: "'dir$'\audios\Praat\frase.TextGrid"
nome_arquivo$ = "frase"
selectObject: sound
plusObject: txtgrd
View & Edit
data0$ = date$()
hora0$ = mid$ (data0$, 12, 8)
hour0 = number(mid$(data0$,12,2))
minutes0 = number(mid$(data0$,15,2))
seconds0 = number(mid$(data0$,18,2))
t0 = 360*hour0 + 60*minutes0 + seconds0
@feedback
select all
Remove


#Tarefa 1
etapa$ = "doremifa"
clearinfo
print Esta é a Tarefa 1
sound = Read from file: "'dir$'\audios\Tarefa 1\doremifa_cut_mono.wav"
txtgrd = Read from file: "'dir$'\audios\Tarefa 1\doremifa_cut_mono.TextGrid"
nome_arquivo$ = "doremifa_cut_mono"
selectObject: sound
plusObject: txtgrd
View & Edit
data0$ = date$()
hora0$ = mid$ (data0$, 12, 8)
hour0 = number(mid$(data0$,12,2))
minutes0 = number(mid$(data0$,15,2))
seconds0 = number(mid$(data0$,18,2))
t0 = 360*hour0 + 60*minutes0 + seconds0
@feedback
select all
Remove

#Tarefa 2 - parte 1 (progressivo)
etapa$ = "progressivo"
clearinfo
print Esta é a Tarefa 2
strings = Create Strings as file list: "trechos", "C:\Users\thais\Documents\UFMG\E) Monografia\For real now\1) Familiarização\audios\Tarefa 2\Progressivo\number\*.wav"
n_strings = Get number of strings

for i to n_strings
	select strings
	nome_arquivo$ = Get string: i
	nome_arquivo$ = nome_arquivo$-".wav"
	nome_arquivo = number(nome_arquivo$)
	sound = Read from file: "'dir$'\audios\Tarefa 2\Progressivo\number\'nome_arquivo'.wav"
	txtgrd = Read from file: "'dir$'\audios\Tarefa 2\Progressivo\number\'nome_arquivo'.TextGrid"
	selectObject: sound
	plusObject: txtgrd
	data0$ = date$()
	hora0$ = mid$ (data0$, 12, 8)
	hour0 = number(mid$(data0$,12,2))
	minutes0 = number(mid$(data0$,15,2))
	seconds0 = number(mid$(data0$,18,2))
	t0 = 360*hour0 + 60*minutes0 + seconds0
	View & Edit
	@feedback
endfor
select all
Remove

#Tarefa 2 - parte 2 (randomizado)
etapa$ = "randomizado"
strings = Create Strings as file list: "trechos", "C:\Users\thais\Documents\UFMG\E) Monografia\For real now\1) Familiarização\audios\Tarefa 2\Randomizado\name\*.wav"
n_strings = Get number of strings
@shuffle

for i to n_strings
	select strings
	nome_arquivo$ = Get string: trechos#[i]
	nome_arquivo$ = nome_arquivo$-".wav"
	sound = Read from file: "'dir$'\audios\Tarefa 2\Randomizado\name\'nome_arquivo$'.wav"
	txtgrd = Read from file: "'dir$'\audios\Tarefa 2\Randomizado\name\'nome_arquivo$'.TextGrid"
	selectObject: sound
	plusObject: txtgrd
	View & Edit
	data0$ = date$()
	hora0$ = mid$ (data0$, 12, 8)
	hour0 = number(mid$(data0$,12,2))
	minutes0 = number(mid$(data0$,15,2))
	seconds0 = number(mid$(data0$,18,2))
	t0 = 360*hour0 + 60*minutes0 + seconds0
	@feedback
endfor
select all
Remove


#Tarefa 3
etapa$ = "fronteiras"
clearinfo
print Esta é a Tarefa 3
strings2 = Create Strings as file list: "trechos2", "C:\Users\thais\Documents\UFMG\E) Monografia\For real now\1) Familiarização\audios\Tarefa 3\name\*.wav"
n_strings2 = Get number of strings
@shuffle

for i to n_strings2
	select strings2
	nome_arquivo$ = Get string: trechos2#[i]
	nome_arquivo$ = nome_arquivo$-".wav"
	ordem = i
	sound = Read from file: "'dir$'\audios\Tarefa 3\name\'nome_arquivo$'.wav"
	txtgrd = Read from file: "'dir$'\audios\Tarefa 3\name\'nome_arquivo$'.TextGrid"
	selectObject: sound
	plusObject: txtgrd
	View & Edit
	data0$ = date$()
	hora0$ = mid$ (data0$, 12, 8)
	hour0 = number(mid$(data0$,12,2))
	minutes0 = number(mid$(data0$,15,2))
	seconds0 = number(mid$(data0$,18,2))
	t0 = 360*hour0 + 60*minutes0 + seconds0
	@feedback
endfor
select all
Remove
clearinfo
print Obrigado!

procedure feedback
	beginPause: "Feedback"
		comment: "Quando terminar sua marcação, continue a tarefa."
	clicked = endPause: "Continuar", 1
	if clicked = 1
		beginPause: "Confirmação"
			comment: "Você tem certeza?"
		clicked2 = endPause: "Sim", "Não", 2, 1
		if clicked2 = 1			
			data$ = date$()
			dia$ = left$ (data$, 10)
			hora$ = mid$ (data$, 12, 8)
			hour = number(mid$(data$,12,2))
			minutes = number(mid$(data$,15,2))
			seconds = number(mid$(data$,18,2))
			t = 360*hour + 60*minutes + seconds
			dif = t - t0
			appendFileLine: "'dir$'\resultados\tempo_por_enunciado.txt", "'sigla$''tab$''dia$''tab$''etapa$''tab$''hora0$''tab$''hora$''tab$''dif'"
			editor: "TextGrid 'nome_arquivo$'"
				Close
			endeditor
			selectObject: txtgrd
			Save as text file: "'dir$'\resultados\'sigla$'\'sigla$'_'etapa$'_'nome_arquivo$'.TextGrid"
		else
			@feedback
		endif
	endif
endproc

procedure shuffle
	if etapa$ = "randomizado"
		temp#= zero# (n_strings)
		trechos# = zero# (n_strings)
		for j to n_strings
			temp#[j] = j
		endfor
		for index to n_strings
			trechos_index = randomInteger(index,n_strings)
			trechos#[index] = temp#[trechos_index]
			temp#[trechos_index] = temp#[index]
		endfor
	elsif etapa$ = "fronteiras"
		temp#= zero# (n_strings2)
		trechos2# = zero# (n_strings2)
		for j to n_strings2
			temp#[j] = j
		endfor
		for index to n_strings2
			trechos2_index = randomInteger(index,n_strings2)
			trechos2#[index] = temp#[trechos2_index]
			temp#[trechos2_index] = temp#[index]
		endfor
	endif
endproc