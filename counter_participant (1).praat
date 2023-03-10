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
'participant$'_'audio$' = Create Strings as file list: "textgrids". "'dir$'\TextGrids tratados\'participant$'\'audio$'\*.TextGrid"
n_files = Get number of strings

#creates table
table_participant = writeFileLine: "'dir$'\Tabelas\'participant$'\'audio$'\base_participante.txt", "audio'tab$'participant'tab$'interval'tab$'point'boundary_type'tab$'same_VV'tab$'adjacent_VV'tab$'segment_vv'tab$'segment_adj'tab$'duration_segment'tab$'retracting_vv'tab$'retracting_adj'tab$'interrupted_vv'tab$'interrupted_adj'tab$'intersection'tab$'pause_vv'tab$'pause_adj'tab$'"

#count_participant
for i to n_files
	select 'participant$'_'audio$'
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
		@boundaries
		@retracting
		@interrupted
		@segments
		@pause
		@intersection
		appendFileLine:"'dir$'\Tabelas\'participant$'\'audio$'\base_participante.txt","'audio$''tab$''participant$''tab$''file$''tab$''j''tab$''boundary_type$''tab$''boundary_vv''tab$''boundary_adj''tab$''seg_vv''tab$''seg_adj''tab$''duration_seg''tab$''ret_vv''tab$''ret_adj'tab$''int_vv''tab$'int_adj''tab$'count''tab$''pause_vv''tab$''pause_adj''tab$'"
	endfor
endfor

#procedures: boundaries, retracting, interrupted, pause, segments, and intersection
procedure boundaries
	for k to n_ntb
		t_ntb = Get time of point: 5, k
		if t0 < t_ntb < t
			label$ = Get label: 5, k
			label = number (label$)
			if label >= 10
				boundary_vv = 1
				boundary_type$ = ntb
			else
				boundary_vv = 0
			endif	
		elsif t_0 < t_ntb < t_f
			label$ = Get label: 5, k
			label = number (label$)
			if label >= 10
				boundary_adj = 1
				boundary_type$ = ntb
			else
				boundary_adj = 0
			endif			
		endif
	endfor
	for l to n_ntb
		t_tb = Get time of point: 6, l
		if t0 < t_tb < t
			label_tb$ = Get label: 6, l
			label_tb = number (label_tb$)
			if label_tb >= 10
				boundary_vv = 1
				boundary_type$ = tb
			else
				boundary_vv = 0
			endif		
		elsif t_0 < t_tb < t_f
			label_tb$ = Get label: 6, l
			label_tb = number (label_tb$)
			if label_tb >= 10
				boundary_adj = 1
				boundary_type$ = tb
			else
				boundary_adj = 0
			endif				
		endif
	endfor
	@intersection
endproc

procedure intersection
	for t to n_ntb
		count = 
	endfor
endproc

procedure retracting
	for m to n_ntb
		t_ret = Get time of point: 7, m
		if t0 < t_ret < t
			label_ret$ = Get label: 7, m
			label_ret = number (label_ret$)
			if label_ret >= 10
				ret_vv = 1	
			else
				ret_vv = 0
			endif		
		elsif t_0 < t_tb < t_f
			label_ret$ = Get label: 7, m
			label_ret = number (label_ret$)
			if label_ret >= 10
				ret_adj = 1	
			else
				ret_adj = 0
			endif				
		endif
	endfor
endproc

procedure interrupted
	for n to n_ntb
		t_int = Get time of point: 8, n
		if t0 < t_int < t
			label_int$ = Get label: 8, n
			label_int = number (label_int$)
			if label_int >= 10
				int_vv = 1	
			else
				int_vv = 0
			endif		
		elsif t_0 < t_int < t_f
			label_int$ = Get label: 7, n
			label_int = number (label_int$)
			if label_int >= 10
				int_adj = 1	
			else
				int_adj = 0
			endif				
		endif
	endfor
endproc

procedure segments
	seg_interval = Get interval at time: 4, t_point
	label_seg$ = Get label: 4, seg_interval
	if label_seg$ <> ""
		t0_seg = Get start time of interval: 4, seg_interval
		t_seg = Get end time of interval: 4, seg_interval
		duration_seg = t_seg - t0_seg
		if t0 < t_seg < t or t0 < t0_seg < t
			seg_vv = 1
		else
			seg_vv = 0
		endif			
		if t_0 < t_seg < t_f or t_0 < t0_seg < t_f
			seg_adj = 1	
		else
			seg_adj = 0
		endif
	endif		
endproc

procedure pause
	pause_interval = Get interval at time: 9, t_point
	label_pause$ = Get label: 9, pause_interval
	if label_pause$ <> ""
		t0_pause = Get start time of interval: 9, seg_interval
		t_pause = Get end time of interval: 9, seg_interval
		duration_pause = t_pause - t0_pause
		if t0 < t_pause < t or t0 < t0_pause < t
			pause_vv = 1
		else
			pause_vv = 0	
		endif
		if t_0 < t_pause < t_f or t_0 < t0_pause < t_f
			pause_adj = 1	
		else
			pause_adj = 0
		endif
	endif	
endproc