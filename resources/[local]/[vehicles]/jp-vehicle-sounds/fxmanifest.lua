fx_version 'cerulean'

game 'gta5'

files {
    'dlc_nikez_sounds/*.awc',
    'dlc_nikez_ros_general/*.awc',
    'general.dat54.rel',
    'ros_general.dat54.rel',
}

data_file 'AUDIO_WAVEPACK' 'dlc_nikez_sounds'
data_file 'AUDIO_SOUNDDATA' 'general.dat'

data_file 'AUDIO_WAVEPACK' 'dlc_nikez_ros_general'
data_file 'AUDIO_SOUNDDATA' 'ros_general.dat'

client_script 'cl_client.lua'