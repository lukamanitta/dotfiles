" Minimal bottom panel, no side panel for single file editing
let s:bottom_term = {
      \  'name': 'bottom_term',
      \  'set_all': ['nonu', 'nornu'],
      \  'bot': {
      \    'h_sz': 12,
      \    'init': ['term'],
      \  }
      \}

let g:vwm#layouts=[s:bottom_term]

" Vista attempts to move itself, the sleep prevents a race.
let s:dev_panel = {
      \  'name': 'dev_panel',
      \  'set_all': ['nonu', 'nornu'],
      \  'bot': {
      \    'h_sz': 12,
      \    'init': ['term'],
      \  },
      \  'left': {
      \    'v_sz': 30,
      \    'init': ['NERDTree'],
      \  },
      \}

let g:vwm#layouts+=[s:dev_panel]
