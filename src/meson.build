sources = [
  'main.vala',
  'window.vala',
  'application.vala',
]

deps = [
  dependency('libadwaita-1', version: '>= 1.0'),
]

gnome = import('gnome')

sources += gnome.compile_resources('window_painter-resources',
  'window_painter.gresource.xml',
  c_name: 'as_resources'
)

executable(
  'window_painter',
  sources,
  vala_args: '--target-glib=2.50',
  dependencies: deps,
  install: true,
)
