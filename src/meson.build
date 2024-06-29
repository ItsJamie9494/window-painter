sources = [
  'window.vala',
  'application.vala',
  'utils.vala',
  'widgets/colour-switcher.vala',
  'widgets/game-board.vala',
  'widgets/difficulty-selector.vala',
  'models/colours.vala',
  'models/difficulty.vala',
  'objects/signals.vala',
  'dialogs/victory-dialog.vala',
  'dialogs/defeat-dialog.vala'
]

deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.0'),
  dependency('gee-0.8'),
]

config_file = configure_file(
    input: 'config.vala.in',
    output: 'config.vala',
    configuration: conf
)

gnome = import('gnome')

executable(
  'windowpainter',
  sources,
  config_file,
  asresources,
  vala_args: '--target-glib=2.50',
  dependencies: deps,
  install: true,
)
