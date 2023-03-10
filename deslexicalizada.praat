clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\For real now\3) Deslexicalizada
	choice Audio
		button sp
		button ts
	sentence Nome
	word Sigla
	natural Idade
	sentence Origem Belo Horizonte, MG
	choice Sexo 1
		button F
		button M
	choice Escolaridade
		button Ensino Médio incompleto
		button Ensino Médio completo
		button Ensino Superior incompleto
		button Ensino Superior completo
endform

createDirectory: "'dir$'\resultados\'sigla$'\"
createDirectory: "'dir$'\resultados\'sigla$'\'audio$'"

writeFileLine: "'dir$'\resultados\'sigla$'\'audio$'\info_'sigla$'.txt", "audio'tab$'trecho'tab$'ordem'tab$'"
writeFileLine: "'dir$'\resultados\'sigla$'\'audio$'\intervalo_quebras_'sigla$'.txt", "audio'tab$'par'tab$'etiqueta'tab$'tempo_1'tab$'tempo_2'tab$'diferenca"

#Ficha Social
if fileReadable ("'dir$'\resultados\info_participantes.txt") = 0
	writeFileLine: "'dir$'\resultados\info_participantes.txt", "nome'tab$'sigla'tab$'idade'tab$'origem'tab$'sexo'tab$'escolaridade"
endif
appendFileLine: "'dir$'\resultados\info_participantes.txt", "'nome$''tab$''sigla$''tab$''idade''tab$''origem$''tab$''sexo$''tab$''escolaridade$'"

#Cria tabela que cronometra tempo de realização de cada parte.
if fileReadable ("'dir$'\resultados\tempo_por_enunciado.txt") = 0
	writeFileLine: "'dir$'\resultados\tempo_por_enunciado.txt", "participante'tab$'data'tab$'tarefa'tab$'tempo inicial'tab$'tempo final'tab$'tempo total"
endif

#Script
strings = Create Strings as file list: "trechos", "'dir$'\audios\extracted - 'audio$'\*.wav"
n_strings = Get number of strings
@shuffle

for i to n_strings
	count_repetir=0
	select strings
	nome_arquivo$ = Get string: trechos#[i]
	nome_arquivo$ = nome_arquivo$-".wav"
	nome_arquivo = number(nome_arquivo$)
	ordem = i
	sound = Read from file: "'dir$'\audios\extracted - 'audio$'\'nome_arquivo'.wav"
	txtgrd = Read from file: "'dir$'\audios\extracted - 'audio$'\'nome_arquivo'.TextGrid"
	@exibir
endfor
select all
Remove
print Obrigado!

procedure exibir
	selectObject: sound
	plusObject: txtgrd
	View & Edit
	editor: "TextGrid 'nome_arquivo'"
		Add point tier: 1, "b"
		Sound scaling: "fixed height", 1000, 1, 1
		Show analyses: "no", "no", "no", "no", "no", 10
	endeditor
	data0$ = date$()
	hora0$ = mid$ (data0$, 12, 8)
	hour0 = number(mid$(data0$,12,2))
	minutes0 = number(mid$(data0$,15,2))
	seconds0 = number(mid$(data0$,18,2))
	t0 = 360*hour0 + 60*minutes0 + seconds0
	@feedback
endproc

procedure feedback
	beginPause: "Feedback"
		comment: "Quando terminar sua marcação, continue a tarefa."
	clicked = endPause: "Continuar", 1
	if clicked = 1
		beginPause: "Confirmação"
			comment: "Você tem certeza?"
		clicked2 = endPause: "Sim", "Não",2,1
		if clicked2 = 1			
			data$ = date$()
			dia$ = left$ (data$, 10)
			hora$ = mid$ (data$, 12, 8)
			hour = number(mid$(data$,12,2))
			minutes = number(mid$(data$,15,2))
			seconds = number(mid$(data$,18,2))
			t = 360*hour + 60*minutes + seconds
			dif = t - t0
			appendFileLine: "'dir$'\resultados\tempo_por_enunciado.txt", "'sigla$''tab$''dia$''tab$''hora0$''tab$''hora$''tab$''dif'"
			editor: "TextGrid 'nome_arquivo'"
				Close
			endeditor
			selectObject: txtgrd
			Save as text file: "'dir$'\resultados\'sigla$'\'audio$'\'nome_arquivo'_'sigla$'.TextGrid"
			@contagem
			appendFileLine: "'dir$'\resultados\'sigla$'\'audio$'\info_'sigla$'.txt", "'audio$''tab$''nome_arquivo''tab$''ordem''tab$'"
			select all
			minus strings
			Remove
		else
			@feedback
		endif
	endif
endproc

procedure contagem
	selectObject: txtgrd
	n_points = Get number of points: 1
	if n_points > 0
		for i to n_points-1
			time = Get time of point: 1, i
			time_2 = Get time of point: 1, i+1
			label$ = Get label of point: 1, i
			label2$ = Get label of point: 1, i+1
			dif = time_2 - time
			next_bound= i+1
			appendFileLine: "'dir$'\resultados\'sigla$'\'audio$'\intervalo_quebras_'sigla$'.txt", "'audio$''tab$''i'-'next_bound''tab$''label$'-'label2$''tab$''time''tab$''time_2''tab$''dif'"
		endfor
	endif
	if n_points > 0
		time = Get time of point: 1, n_points
		label$ = Get label of point: 1, n_points
		appendFileLine: "'dir$'\resultados\'sigla$'\'audio$'\intervalo_quebras_'sigla$'.txt", "'audio$''tab$''n_points''tab$''label$''tab$''time''tab$'NA'tab$'NA"
	endif
endproc

procedure shuffle
	temp#= zero# (n_strings)
	trechos# = zero# (n_strings)
	for j to n_strings
		temp#[j] = j
	endfor
	for index to n_strings
		trecho_index = randomInteger(index,n_strings)
		trechos#[index] = temp#[trecho_index]
		temp#[trecho_index] = temp#[index]
	endfor
endproc