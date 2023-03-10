clearinfo

form Files
	sentence Dir F:\Monografia
	choice Audio
		button sp
		button ts
	choice Participant
		button BHF
		button FC
		button GB
		button LFLS
		button SMS
endform

#merge textgrids
txtgrds_bar = Create Strings as file list: "anotacao_vv", "'dir$'\Tratamento automático de dados\TextGrids Bárbara\'audio$'\*.TextGrid"
n_txtgrds_bar = Get number of strings

txtgrds_part = Create Strings as file list: "seg_deslex", "'dir$'\Tratamento automático de dados\TextGrids Participantes\'participant$'\'audio$'\*.TextGrid"
n_txtgrds_part = Get number of strings

for i to n_txtgrds_bar
	select txtgrds_bar
	file$ = Get string: i
	file$ = file$ - ".TextGrid"
	bar = Read from file: "'dir$'\Tratamento automático de dados\TextGrids Bárbara\'audio$'\'file$'.TextGrid"
	part = Read from file: "'dir$'\Tratamento automático de dados\TextGrids Participantes\'participant$'\'audio$'\'file$'_'participant$'.TextGrid"
	selectObject: bar
	plusObject: part
	merge = Merge
	@exibir
endfor
select all
Remove
print Done!

procedure exibir
	selectObject: merge
	rename = Rename: "'file$'_merged_'participant$'"
	selectObject: rename
	Duplicate tier: 10, 1, "'participant$'"
	Remove tier: 11
	Remove tier: 10
	Insert point tier: 2, "points_'participant$'"
	selectObject: rename
	n_intervals = Get number of intervals: 1
	for j to n_intervals
		if j < n_intervals
			t = Get end point: 1, j
			j$ = string$ (j)
			Insert point: 2, t, j$
		endif
	endfor
	View & Edit
	editor: "TextGrid 'file$'_merged_'participant$'"
		@checklist
	endeditor
	Save as text file: "'dir$'\Tratamento automático de dados\TextGrids Tratados\'participant$'\'audio$'\'file$'_merged_'participant$'.TextGrid"
endproc

procedure checklist
	beginPause: "Item one"
		comment: "Make the first tier an interval one named 'participant$', with his/hers boundaries."
		endeditor
	clicked = endPause: "Done", "Wait", 2, 1
	if clicked = 2
		@checklist
	else
		beginPause: "Item two"
			comment: "Delete any surplus tier."
		clicked2 = endPause: "Done", "Wait", 2, 1
		if clicked2 = 2
			@checklist
		else
			beginPause: "Item three"
				comment: "Check if the points are equivalent in number and time to the interval boundaries."
			clicked3 = endPause: "Done", "Wait", 2, 1
			if clicked3 = 2
				@checklist
			endif
		endif
	endif
endproc

#cria as tabelas, extrai os dados e as salva em .txt


			