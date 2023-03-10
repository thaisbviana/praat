clearinfo

form Files
	sentence Dir F:\Monografia\Tratamento automático de dados
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

#creates file list
'audio$'_'participant$' = Create Strings as file list: "textgrids", "'dir$'\TextGrids tratados\'participant$'\'audio$'\*.TextGrid"
n_files = Get number of strings

#creates table
if fileReadable ("'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt") = 0
	table_participant = writeFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt", "audio'tab$'participant'tab$'interval'tab$'point_participant'tab$'boundary_type'tab$'same_VV'tab$'adjacent_VV'tab$'contagem_fronteiras_vv'tab$'contagem_fronteiras_adj'tab$'segment_vv'tab$'segment_adj'tab$'duration_segment'tab$'retracting_vv'tab$'retracting_adj'tab$'interrupted_vv'tab$'interrupted_adj'tab$'pause_vv'tab$'pause_adj'tab$'"
endif

#count_participant
for i to n_files
	select 'audio$'_'participant$'
	file$ = Get string: i
	file$ = file$-".TextGrid"
	open = Read from file: "'dir$'\TextGrids tratados\'participant$'\'audio$'\'file$'.TextGrid"
	n_points = Get number of points: 2
	n_ntb = Get number of points: 5
	for j to n_points
		t_point = Get time of point: 2, j
		vv = Get interval at time: 3, t_point
		t0 = Get start time of interval: 3, vv
		t = Get end time of interval: 3, vv
		t_0 = Get start time of interval: 3, vv-1
		t_f = Get end time of interval: 3, vv+1
		appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'audio$''tab$''participant$''tab$''file$''tab$''j''tab$'"
		@boundaries
		@segments
		@retracting
		@interrupted
		@pause
	endfor
endfor
print Done!

#procedures: boundaries, retracting, interrupted, pause, segments, and intersection
procedure boundaries
	count = 0
	count_2 = 0
	for k to n_ntb
		t_ntb = Get time of point: 5, k
		boundary_type$ = "ntb"
		if t0 < t_ntb and t_ntb < t	
			label$ = Get label of point: 5, k
			etiqueta = number (label$)
			if etiqueta >= 10
				boundary_vv = 1
				count +=1
			else
				boundary_vv = 0
			endif
			appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'boundary_type$''tab$''boundary_vv''tab$'"
		endif
		if t_0 < t_ntb and t_ntb < t_f
			label$ = Get label of point: 5, k
			etiqueta = number (label$)
			if etiqueta >= 10
				boundary_adj = 1
				count_2 +=1
			else
				boundary_adj = 0
			appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'boundary_type''tab$''boundary_adj''tab$'"
			endif
		endif
	endfor
	for l to n_ntb
		t_tb = Get time of point: 6, l
		boundary_type$ = "tb"
		if t0 < t_tb and t_tb < t
			label_tb$ = Get label of point: 6, l
			etiqueta_tb = number(label_tb$)
			if etiqueta_tb >= 10
				boundary_vv = 1
				count +=1
			else
				boundary_vv = 0
			endif
			appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'boundary_type$''tab$''boundary_vv''tab$'"
		endif	
		if t_0 < t_tb and t_tb < t_f
			label_tb$ = Get label of point: 6, l
			etiqueta_tb = number(label_tb$)
			if etiqueta_tb >= 10
				boundary_adj = 1
				count_2 +=1
			else
				boundary_adj = 0
			endif				
			appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'boundary_adj''tab$''count''tab$''count_2''tab$'"
		endif
	endfor
endproc

procedure retracting
	for m to n_ntb
		t_ret = Get time of point: 7, m
		if t0 < t_ret and t_ret < t
			label_ret$ = Get label of point: 7, m
			etiqueta_ret = number(label_ret$)
			if etiqueta_ret >= 10
				ret_vv = 1	
			else
				ret_vv = 0
			endif		
		elsif t_0 < t_ret and t_ret < t_f
			label_ret$ = Get label of point: 7, m
			etiqueta_ret = number(label_ret$)
			if etiqueta_ret >= 10
				ret_adj = 1	
			else
				ret_adj = 0
			endif
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'ret_vv''tab$''ret_adj'tab$'"			
		endif
	endfor
endproc

procedure interrupted
	for n to n_ntb
		t_int = Get time of point: 8, n
		if t0 < t_int and t_int < t
			label_int$ = Get label of point: 8, n
			etiqueta_int = number(label_int$)
			if etiqueta_int >= 10
				int_vv = 1	
			else
				int_vv = 0
			endif		
		elsif t_0 < t_int and t_int < t_f
			label_int$ = Get label of point: 7, n
			etiqueta_int = number(label_int$)
			if etiqueta_int >= 10
				int_adj = 1	
			else
				int_adj = 0
			endif
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'int_vv''tab$''int_adj''tab$'"			
		endif
	endfor
endproc

procedure segments
	seg_interval = Get interval at time: 4, t_point
	label_seg$ = Get label of interval: 4, seg_interval
	if label_seg$ <> ""
		t0_seg = Get start time of interval: 4, seg_interval
		t_seg = Get end time of interval: 4, seg_interval
		duration_seg = t_seg - t0_seg
		if (t0_seg < t0 and t0 < t_seg) or (t0_seg < t and t_seg > t) or (t0_seg < t0 and t < t_seg)
			seg_vv = 1
		else
			seg_vv = 0
		endif			
		if (t_0 < t0_seg and t_seg < t_f) or (t0_seg < t0 and t_seg < t_f) or (t0_seg < t_f and t_seg > t_f)
			seg_adj = 1
		else
			seg_adj = 0
		endif
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'seg_vv''tab$''seg_adj''tab$''duration_seg''tab$'"
	endif		
endproc

procedure pause
	pause_interval = Get interval at time: 9, t_point
	label_pause$ = Get label of interval: 9, pause_interval
	if label_pause$ <> ""
		t0_pause = Get start time of interval: 9, pause_interval
		t_pause = Get end time of interval: 9, pause_interval
		duration_pause = t_pause - t0_pause
		if if (t0_pause < t0 and t0 < t_pause) or (t0_pause < t and t_pause > t) or (t0_pause < t0 and t < t_pause)
			pause_vv = 1
		else
			pause_vv = 0	
		endif
		if (t_0 < t0_pause and t_pause < t_f) or (t0_pause < t0 and t_pause < t_f) or (t0_pause < t_f and t_pause > t_f)
			pause_adj = 1	
		else
			pause_adj = 0
		endif
	appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'pause_vv''tab$''pause_adj''tab$'"
	endif	
endproc