" Minimal bottom panel, no side panel for single file editing
let s:bottom_term = {
      \  'name': 'bottom_term',
      \  'set_all': ['nonu', 'nornu'],
      \  'bot': {
      \    'h_sz': 10,
      \    'init': ['term'],
      \  }
      \}

let g:vwm#layouts=[s:bottom_term]

let s:dev_panel = {
      \  'name': 'dev_panel',
      \  'set_all': ['nonu', 'nornu'],
      \  'bot': {
      \    'h_sz': 10,
      \    'init': ['term'],
      \  },
      \  'left': {
      \    'v_sz': 30,
      \    'init': ['NvimTreeOpen'],
      \  },
      \}

let g:vwm#layouts+=[s:dev_panel]
