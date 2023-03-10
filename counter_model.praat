clearinfo

form Files
	sentence Dir F:\Monografia\Tratamento automático de dados
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
table_model = writeFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_model.txt", "audio'tab$'participant'tab$'interval'tab$'boundary_point'tab$'same_vv'tab$'adj_vv'tab$'segment_vv'tab$'segment_adj'tab$'segment_duration'tab$'pause_vv'tab$'pause_adj'tab$'pause_duration'tab$'end_of_snippet'tab$'"

#count_model
for i to n_files
	select 'audio$'_'participant$'
	file$ = Get string: i
	file$ = file$-".TextGrid"
	open = Read from file: "'dir$'\TextGrids tratados\'participant$'\'audio$'\'file$'.TextGrid"
	n_part = Get number of points: 2
	n_ntb = Get number of points: 5
	n_vv = Get number of intervals: 3
	count = 0
	for i to n_ntb
		t_point = Get time of point: 5, i
		label_ntb$ = Get label of point: 5, i
		label_ntb = number (label_ntb$)
		label_tb$ = Get label of point: 6, i
		label_tb = number (label_tb$)
		if label_ntb >= 10
			vv = Get interval at time: 3, t_point
			t0 = Get start time of interval: 3, vv
			t = Get end time of interval: 3, vv
			t_0 = Get start time of interval: 3, vv-1
			if vv = n_vv
				t_f = t
			else
				t_f = Get end time of interval: 3, vv+1
			endif
			@part_breaks
			@segments
			@pause
			@snippet	
		elsif label_tb >= 10
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
			@part_breaks
			@segments
			@pause
			@snippet
		elsif label_ntb + label_tb >= 10
			vv = Get interval at time: 3, t_point
			t0 = Get start time of interval: 3, vv
			t = Get end time of interval: 3, vv
			t_0 = Get start time of interval: 3, vv-1
			if vv = n_vv
				t_f = t
			else
				t_f = Get end time of interval: 3, vv+1
			endif
			@part_breaks
			@segments
			@pause
			@snippet
		else
			part_vv = 0
			part_adj = 0
			seg_vv = 0
			seg_adj = 0
			pause_vv = 0
			pause_adj = 0
		endif
		print 'i' 'label_ntb' 'label_tb' 'part_vv' 'part_adj' 'seg_vv' 'seg_adj' 'pause_vv' 'pause_adj' 'snippet' 'newline$'
		appendFile:"'dir$'\Tabelas\'participant$'\'audio$'\base_model.txt","'audio$''tab$''participant$''tab$''file$''tab$''j''tab$''part_vv''tab$''part_adj''tab$''seg_vv''tab$''seg_adj''tab$''duration_seg:3''tab$''pause_vv''tab$''pause_adj''tab$''duration_pause:3''tab$''snippet''newline$'"
	endfor
endfor

print Done!

procedure part_breaks
	for j to n_part
		t_part = Get time of point: 2, j
		if t0 < t_part and t_part < t
			part_vv = 1
			count += 1
		elsif (t_0 < t_part and t_part < t0) or (t < t_part < t_f)
			part_adj = 1
			count +=1
		else
			part_vv = 0
			part_adj = 0
		endif
	endfor
endproc

procedure segments
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
			appendFile: "'dir$'\Tabelas\'participant$'\'audio$'\base_model.txt","'seg_vv''tab$''seg_adj''tab$''duration_seg:3''tab$'"
		endif
	endif
endproc

procedure pause
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
		appendFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_model.txt","'pause_vv''tab$''pause_adj''tab$''duration_pause:3'"
		endif	
	endif
endproc

procedure snippet
	if vv = n_vv
		snippet = 1
	else
		snippet = 0
	endif
endproc