clearinfo

form Files
	sentence Dir D:\Monografia\Tratamento automático de dados
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
	table_participant = writeFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt", "audio'tab$'participant'tab$'interval'tab$'point_participant'tab$'point_model'tab$'same_VV'tab$'count_vv'tab$'adjacent_VV'tab$'count_adj'tab$'retracting_vv'tab$'retracting_adj'tab$'interrupted_vv'tab$'interrupted_adj'tab$'segment_vv'tab$'segment_adj'tab$'duration_segment'tab$'pause_vv'tab$'pause_adj'tab$'duration_pause'tab$'"
endif

#count_participant
#quantidade de textgrids por texto
for i to n_files
	select 'audio$'_'participant$'
	file$ = Get string: i
	file$ = file$-".TextGrid"
	open = Read from file: "'dir$'\TextGrids tratados\'participant$'\'audio$'\'file$'.TextGrid"
	n_vv = Get number of intervals: 3
	n_points = Get number of points: 2
	n_ntb = Get number of points: 5
	#marcações do participante
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
		
		#silent segments
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
			elsif label_seg$ = ""
				seg_vv = 0
				seg_adj = 0
				duration_seg = 0
			endif
		endif
		#pauses
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
			elsif label_pause$ = ""
				pause_vv = 0
				pause_adj = 0
				duration_pause = 0
			endif
		endif
		#escaneamento das fronteiras do modelo
		count = 0
		count_2 = 0
		for k to n_ntb 
			t_ntb = Get time of point: 5, k
			t_ret = Get time of point: 7, k
			t_int = Get time of point: 8, k
			#boundaries
			if t0 < t_ntb and t_ntb < t
			label$ = Get label of point: 5, k
			etiqueta_vv = number (label$)
			label_tb_vv$ = Get label of point: 6, k
			etiqueta_tb_vv = number(label_tb_vv$)
				if etiqueta_vv >= 10 or etiqueta_tb_vv >=10
					boundary_vv = 1
					count +=1
				else
					boundary_vv = 0
				endif
			endif
			if (t_0 < t_ntb and t_ntb < t0) or (t < t_ntb and t_ntb < t_f)
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
			#retracting
			if t0 < t_ret and t_ret < t
				label_ret$ = Get label of point: 7, k
				etiqueta_ret = number(label_ret$)
				if etiqueta_ret >= 10
					ret_vv = 1
				else
					ret_vv = 0
				endif	
			elsif (t_0 < t_ret and t_ret < t0) or (t < t_ret and t_ret < t_f)
				label_ret$ = Get label of point: 7, k
				etiqueta_ret = number(label_ret$)
				if etiqueta_ret >= 10
					ret_adj = 1	
				else
					ret_adj = 0
				endif
			endif
			#interrupted
			if t0 < t_int and t_int < t
				label_int$ = Get label of point: 8, k
				etiqueta_int = number(label_int$)
				if etiqueta_int >= 10
					int_vv = 1	
				else
					int_vv = 0
				endif		
			elsif (t_0 < t_int and t_int < t0) or (t < t_int and t_int < t_f)
				label_int$ = Get label of point: 8, k
				etiqueta_int = number(label_int$)
				if etiqueta_int >= 10
					int_adj = 1	
				else
					int_adj = 0
				endif
			endif
		appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_participant.txt","'audio$''tab$''participant$''tab$''file$''tab$''j''tab$'pointmodel'k''tab$'mesmavv'boundary_vv''tab$'contagem'count''tab$'vvadj'boundary_adj''tab$'contagem2'count_2''tab$'retvv'ret_vv''tab$'retadj'ret_adj''tab$'intvv'int_vv''tab$'intadj'int_adj''tab$'segvv'seg_vv''tab$'segadj'seg_adj''tab$''duration_seg:3''tab$'psavv'pause_vv''tab$'psaadj'pause_adj''tab$''duration_pause:3''newline$'"
		endfor
	endfor
endfor
select all
Remove
print Done!