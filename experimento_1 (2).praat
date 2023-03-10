clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\Teste\
	word Nome SIGLA
endform
createDirectory: "'dir$'\Resultados\'nome$'\"
#fazer uma janela de pausa com as intruções - ou demo windows

writeFileLine: "'dir$'\Resultados\'nome$'\info_'nome$'.txt", "audio'tab$'trecho'tab$'ordem'tab$'repeticao'tab$'"
writeFileLine: "'dir$'\Resultados\'nome$'\intervalo_quebras_'nome$'.txt", "audio'tab$'par'tab$'etiqueta'tab$'tempo_1'tab$'tempo_2'tab$'diferenca"
table = Read Table from tab-separated file: "'dir$'\table_sp.txt"
n_audios = Get number of rows
audio$ = Get value: 1, "audio"

for i to n_audios
	count_repetir=0
	@shuffle
	selectObject: table
	nome_arquivo = Get value: trechos#[i], "interval_id"
	ordem = i
	sound = Read from file: "'dir$'\bmedsp03_1a - extracted\'nome_arquivo'.wav"
	txtgrd = Read from file: "'dir$'\bmedsp03_1a - extracted\'nome_arquivo'.TextGrid"
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
	@repetir
endproc

procedure repetir
	editor: "TextGrid 'nome_arquivo'"
		Play window
	endeditor
	@feedback
endproc

procedure feedback
	beginPause: "Feedback"
		comment: "Você terminou a marcação ou quer repetir o áudio?"
	clicked = endPause: "Terminei", "Repetir", 2
	if clicked = 1
		beginPause: "Confirmação"
			comment: "Você tem certeza?"
		clicked2 = endPause: "Sim", "Não",2,1
		if clicked2 = 1			
			editor: "TextGrid 'nome_arquivo'"
				Close
			endeditor
			selectObject: txtgrd
			Save as text file: "'dir$'\Resultados\'nome$'\'nome_arquivo'_'nome$'.TextGrid"
			@contagem
			appendFileLine: "'dir$'\Resultados\'nome$'\info_'nome$'.txt", "'audio$''tab$''nome_arquivo''tab$''ordem''tab$''count_repetir''tab$'"
			select all
			minus table
			Remove
		else
			@repetir
			count_repetir+=1
		endif
	elsif clicked = 2
		@repetir
		count_repetir+=1
	endif
endproc

procedure contagem
	selectObject: txtgrd
	n_points = Get number of points: 1
	for i to n_points-1
		time = Get time of point: 1, i
		time_2 = Get time of point: 1, i+1
		label$ = Get label of point: 1, i
		label2$ = Get label of point: 1, i+1
		dif = time_2 - time
		appendFileLine: "'dir$'\Resultados\'nome$'\intervalo_quebras_'nome$'.txt", "'audio$''tab$''i'-'i+1''tab$''label$'-'label2$''tab$''time''tab$''time_2''tab$''dif'"
	endfor
	print 'n_points'
	time = Get time of point: 1, n_points
	label$ = Get label of point: 1, n_points
	appendFileLine: "'dir$'\Resultados\'nome$'\intervalo_quebras_'nome$'.txt", "'audio$''tab$''n_points''tab$''label$''tab$''time''tab$'NA'tab$'NA"
endproc

procedure shuffle
	temp#= zero# (n_audios)
	trechos# = zero# (n_audios)
	for j to n_audios
		temp#[j] = j
	endfor
	for index to n_audios
		trecho_index = randomInteger(index,n_audios)
		trechos#[index] = temp#[trecho_index]
		temp#[trecho_index] = temp#[index]
	endfor
endproc