clearinfo

form Files
	sentence Dir E:\Monografia\Tratamento automático de dados
	choice Audio 1
		button sp
		button ts
	choice Participant 3
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
	table_participant = writeFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt", "audio'tab$'participant'tab$'interval'tab$'point_participant'tab$'same_VV'tab$'count_vv'tab$'adjacent_VV'tab$'count_adj'tab$'segment_vv'tab$'segment_adj'tab$'duration_segment'tab$'retracting_vv'tab$'retracting_adj'tab$'interrupted_vv'tab$'interrupted_adj'tab$'pause_vv'tab$'pause_adj'tab$'duration_pause"
endif

#count_participant
for i to n_files
	select 'audio$'_'participant$'
	file$ = Get string: i
	file$ = file$-".TextGrid"
	open = Read from file: "'dir$'\TextGrids tratados\'participant$'\'audio$'\'file$'.TextGrid"
	n_vv = Get number of intervals: 3
	n_points = Get number of points: 2
	n_ntb = Get number of points: 5
	for j to n_points
		t_point = Get time of point: 2, j
		vv = Get interval at time: 3, t_point
		if vv = 0
			vv = n_vv
		endif
		t0 = Get start time of interval: 3, vv
		t = Get end time of interval: 3, vv
		t_0 = Get start time of interval: 3, vv-1
		if vv = n_vv
			t_f = t
		else
			t_f = Get end time of interval: 3, vv+1
		endif
		appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'audio$''tab$''participant$''tab$''file$''tab$''j''tab$'"
		@boundaries
		@segments
		@retracting
		@interrupted
		@pause
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt", "'newline$'"
	endfor
endfor

select all
Remove
print Done!


#procedures: boundaries, retracting, interrupted, pause, segments, and intersection
procedure boundaries
	count = 0
	count_2 = 0
	for k to n_ntb
		t_ntb = Get time of point: 5, k
		label$ = Get label of point: 5, k
		etiqueta_vv = number (label$)
		label_tb_vv$ = Get label of point: 6, k
		etiqueta_tb_vv = number(label_tb_vv$)
		if t0 < t_ntb and t_ntb < t	
			if etiqueta_vv >= 10 or etiqueta_tb_vv >=10
				boundary_vv = 1
				count +=1
			else
				boundary_vv = 0
			endif
		endif
		if t_0 < t_ntb and t_ntb < t_f
			label_adj$ = Get label of point: 5, k
			etiqueta_adj = number (label_adj$)
			label_tb_adj$ = Get label of point: 6, k
			etiqueta_tb_adj = number(label_tb_adj$)
			if etiqueta_adj >= 10 or etiqueta_tb_adj >= 10
				boundary_adj = 1
				count_2 +=1
			else
				boundary_adj = 0
			endif
		endif
	appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","mesma vv'boundary_vv''tab$'contagem'count''tab$'vvadjacente'boundary_adj''tab$'contagem2'count_2''tab$'"
	endfor
endproc

procedure retracting
	for a to n_ntb
		t_ret = Get time of point: 7, a
		if t0 < t_ret and t_ret < t
			label_ret$ = Get label of point: 7, a
			etiqueta_ret = number(label_ret$)
			if etiqueta_ret >= 10
				ret_vv = 1	
			else
				ret_vv = 0
			endif		
		elsif t_0 < t_ret and t_ret < t_f
			label_ret$ = Get label of point: 7, a
			etiqueta_ret = number(label_ret$)
			if etiqueta_ret >= 10
				ret_adj = 1	
			else
				ret_adj = 0
			endif
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","retrmesmavv'ret_vv''tab$'retrvvadj'ret_adj''tab$'"			
		endif
	endfor
endproc

procedure interrupted
	for b to n_ntb
		t_int = Get time of point: 8, b
		if t0 < t_int and t_int < t
			label_int$ = Get label of point: 8, b
			etiqueta_int = number(label_int$)
			if etiqueta_int >= 10
				int_vv = 1	
			else
				int_vv = 0
			endif		
		elsif t_0 < t_int and t_int < t_f
			label_int$ = Get label of point: 8, b
			etiqueta_int = number(label_int$)
			if etiqueta_int >= 10
				int_adj = 1	
			else
				int_adj = 0
			endif
		appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","intermesmavv'int_vv''tab$'intervvadj'int_adj''tab$'"			
		endif
	endfor
endproc

procedure segments
	for c to n_ntb
		seg_interval = Get interval at time: 4, t_point
		if seg_interval = 0
			seg_vv = 0
			seg_adj = 0
		else
			label_seg$ = Get label of interval: 4, seg_interval
			if label_seg$ <> ""
				t0_seg = Get start time of interval: 4, seg_interval
				t_seg = Get end time of interval: 4, seg_interval
				duration_seg = t_seg - t0_seg
				if (t0_seg < t0 and t0 < t_seg) or ((t0_seg < t and t_seg > t) or (t0_seg < t0 and t < t_seg))
					seg_vv = 1
				else
					seg_vv = 0
				endif				
				if (t_0 < t0_seg and t_seg < t_f) or ((t0_seg < t0 and t_seg < t_f) or (t0_seg < t_f and t_seg > t_f))
					seg_adj = 1
				else
					seg_adj = 0
				endif
				appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","segmentovv'seg_vv''tab$'segmentoadj'seg_adj''tab$''duration_seg:3''tab$'"
			endif
		endif
	endfor	
endproc

procedure pause
	for d to n_ntb
		pause_interval = Get interval at time: 9, t_point
		if pause_interval = 0
			pause_adj = 0
			pause_vv = 1
		else
			label_pause$ = Get label of interval: 9, pause_interval
			if label_pause$ <> ""
				t0_pause = Get start time of interval: 9, pause_interval
				t_pause = Get end time of interval: 9, pause_interval
				duration_pause = t_pause - t0_pause
				if (t0_pause < t0 and t0 < t_pause) or ((t0_pause < t and t_pause > t) or (t0_pause < t0 and t < t_pause))
					pause_vv = 1
				else
					pause_vv = 0	
				endif
				if (t_0 < t0_pause and t_pause < t_f) or ((t0_pause < t0 and t_pause < t_f) or (t0_pause < t_f and t_pause > t_f))
					pause_adj = 1	
				else
					pause_adj = 0
				endif
			appendFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","pausavv'pause_vv''tab$'pausaadj'pause_adj''tab$''duration_pause:3'"
			endif	
		endif
	endfor
endproc