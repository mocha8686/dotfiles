#!/usr/bin/env python3
import json
import os
import shutil
import subprocess

with open('config.json', 'r') as f:
    config = json.loads(f.read())


# Helper functions
def install_packages(command, packages):
    subprocess.call(command.split(' ') + packages)

def install_config(path, config, copy=False):
    # Expand paths
    path = os.path.expanduser(path)
    config = os.path.expanduser(config)

    # Create directories
    if not os.path.exists(path):
        os.makedirs(path)

    # Remove existing files
    if os.path.exists(os.path.join(path, config)):
        os.remove(os.path.join(path, config))

    # Symlink
    try:
        if copy:
            shutil.copy(config, path)
        else:
            os.symlink(os.path.join(os.getcwd(), config), os.path.join(path, config))
    except Exception:
        return


# Get system config
glob = config['systems']['global']

system_name = None
systems = [ system for system in config['systems'] if system != 'global' ]
system_query = 'Choose system:\n- ' + '\n- '.join(systems)
while system_name not in systems or system_name == 'global':
    print(system_query)
    system_name = input('> ')
system = config['systems'][system_name]

# Merge with global
keys = set()
for key in system.keys():
    keys.add(key)
for key in glob.keys():
    keys.add(key)

for key in keys:
    if key not in glob.keys():
        continue

    if key in system.keys():
        if type(system[key]) == dict:
            system[key].update(glob[key])
        elif type(system[key]) == list:
            system[key] += glob[key]
        else:
            raise TypeError('invalid type ' + str(type(system[key])))
    else:
        system[key] = glob[key]

# Install packages
confirm_install = True if input('Install packages? [Y/n] ')[0].lower() != 'n' else False
if confirm_install:
    print('Installing packages...')
    install_packages(system['install_command'], system['packages'])
    print('Done.')


# Install config files
if 'install' in system.keys():
    for file in system['install']:
        install_config(system['install'][file], file)

if 'copy' in system.keys():
    for file in system['copy']:
        install_config(system['copy'][file], file, True)

# Update profile
if 'profile' in system:
    contents = ['# SYS PROFILE START'] + system['profile'] + ['# SYS PROFILE END']
    for i, line in [ (i, line) for i, line in enumerate(contents) ]:
        contents[i] = line + "\n"
    contents = ''.join(contents)
    with open(os.path.expanduser('~/.zshrc'), 'a') as f:
        f.write(contents)

# Additional steps
confirm_additional = True if input('Use additional commands? [Y/n] ')[0].lower() != 'n' else False
if confirm_additional:
    print('Running additional commands...')
    for command in system['additional_commands']:
        os.popen(command)
