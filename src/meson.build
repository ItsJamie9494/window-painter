sources = [
  'window.vala',
  'application.vala',
  'widgets/colour-switcher.vala',
  'widgets/game-board.vala',
  'models/colours.vala',
  'objects/signals.vala'
]

deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.0'),
  dependency('gee-0.8'),
]

gnome = import('gnome')

executable(
  'window_painter',
  sources,
  asresources,
  vala_args: '--target-glib=2.50',
  dependencies: deps,
  install: true,
)
