#!/usr/bin/env python3
import json
import subprocess
import os
import shutil


with open('config.json', 'r') as f:
    config = json.loads(f.read())


# Helper functions
def install_packages(command, packages):
    success = subprocess.run(command.split(' ') + packages).returncode == 0
    return success

def install_config(path, config, move=False):
    # Create directories
    if not os.path.exists(path):
        os.makedirs(path)

    # Remove already existing files
    if os.path.exists(os.path.join(path, config)):
        os.remove(os.path.join(path, config))

    # Move or copy
    if move:
        shutil.move(config, path)
    else:
        shutil.copyfile(config, path)


# Get system config
glob = config['systems']['global']

system_name = None
systems = [ system for system in config['systems'] if system != 'global' ]
system_query = 'Choose system:\n- ' + '\n- '.join(systems)
while system_name not in systems:
    print(system_query)
    system_name = input('> ')
system = config['systems'][system_name]

# Merge with global
system['packages'] += glob['packages']
if 'install' in system.keys():
    system['install'].update(glob['install'])


# ARCH: Install yay
if system_name == 'arch' and not shutil.which('yay'):
    subprocess.run([ 'git', 'clone', 'https://aur.archlinux.org/yay.git' ])
    os.chdir('yay')
    subprocess.run([ 'makepkg', '-si' ])
    os.chdir('..')


# Install packages
print('Installing packages...')

install_packages(system['install_command'], system['packages'])
print('Done.')


# Remove old system profile
with open('.zshrc', 'r') as cfg, open('.zshrctmp', 'w') as tmp:
    copy = True
    for line in cfg:
        if 'SYS PROFILE' in line:
            if 'START' in line:
                copy = False
            elif 'END' in line:
                copy = True

        if copy:
            tmp.write(line)


# Update profile
contents = ['# SYS PROFILE START'] + system['profile'] + ['# SYS PROFILE END']
for i, line in [ (i, line) for i, line in enumerate(contents) ]:
    contents[i] = line + "\n"
contents = ''.join(contents)

with open('.zshrctmp', 'a') as f:
    f.write(contents)
install_config(os.path.join(os.path.expanduser('~'), '.zshrc'), '.zshrctmp', True)

# Install other config files
if 'install' in system.keys():
    for file in system['install']:
        install_config(system['install'][file], file)

