project(
    'namarupa',
    'vala', 'c',
    version: '1.0.0'
)

i18n = import('i18n')
gettext_name = 'wingpanel-indicator-' + meson.project_name()

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')
add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

wingpanel_dep = dependency('wingpanel-2.0')

# Other configs
conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf
add_global_arguments('-DDATADIR="' + get_option('datadir') + '"', language: 'c')
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

# Find libindicator
cc = meson.get_compiler('c')
libindicator3 = cc.find_library('libindicator3', required: true)
libindicator = cc.find_library('libindicator', required: true)

# Arguments for C
c_args = [
  '-include', 'config.h',
  '-w'
]

shared_module(
    meson.project_name(),
    'src/AyatanaIndicator.vala',
    'src/Indicator.vala',
    'src/IndicatorButton.vala',
    'src/IndicatorIface.vala',
    'src/IndicatorFactory.vala',
    'src/IndicatorLoader.vala',
    'src/IndicatorObject.vala',
    'src/SubMenuButton.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        wingpanel_dep,
        libindicator,
        libindicator3
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        meson.source_root() + '/vapi/indicator3-0.4.vapi'
    ],
    install: true,
    install_dir : wingpanel_dep.get_pkgconfig_variable('indicatorsdir')
)
