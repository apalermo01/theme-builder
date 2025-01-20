from . import colors
available_terminals = ['kitty', 'alacritty']
available_wms = ['i3wm']
available_bars = ['polybar']
available_shells = ['fish', 'bash']
available_nvim_distros = ['nvim', 'nvchad']

allowed_elements = {
    'terminals': available_terminals,
    'wms': available_wms,
    'bars': available_bars,
    'shells': available_shells,
    'nvim_distros': available_nvim_distros
}

modules = {
    'colors': colors.parse_colors,
}
