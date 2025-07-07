#!/usr/bin/env python

import os
import subprocess
import glob

ERROR_COLOR = '\033[91m'
END_COLOR = '\033[0m'

def clear_console():
    os.system('clear')

def start_command_with_output(command_list):
    return subprocess.run(command_list, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).stdout.rstrip()

class ADB:
    @staticmethod
    def run_command_on_device(command):
       command_list = ['adb', 'shell']
       for _ in command.split():
          command_list.append(_)

       return start_command_with_output(command_list)

    def wait_device(self, boot_mode):
       subprocess.run(['adb', f'wait-for-{boot_mode}'])

    def getprop(self, prop):
       return self.run_command_on_device(f'getprop {prop}')

    def push(self, source, dest):
       print(start_command_with_output(['adb', 'push', source, dest]))

    def reboot(self, mode):
       start_command_with_output(['adb', 'reboot', mode])

class UBportsRecovery(ADB):
    def check_recovery(self):
       if self.getprop('ro.ubuntu.recovery') == 'true':
           return True
       return False

    def disable_ota_signature_verification(self):
       self.run_command_on_device('enable_updater_debug')

    def wipe_data(self):
       self.run_command_on_device('''echo 'format data' > /cache/recovery/ubuntu_command''')
       self.reboot('recovery')

class Program:
    __ubports_recovery = UBportsRecovery()

    __ota_path = None # (str type)
    __wipe_data = False # (boolen type) Wipe userdata after ota flashing
    __verify_recovery = True # (boolen type) Verify recovery after device detected

    @staticmethod
    def __change_boolen(menu_entry):
        if menu_entry:
            menu_entry = False
            return
        menu_entry = True
        return menu_entry

    def __set_ota_path_action(self):
        new_ota_path = input('Enter new fake ota directory: ')

        if not os.path.isdir(new_ota_path) or not os.path.isfile(f'{new_ota_path}/ubuntu_command'):
            print(f'{ERROR_COLOR}Entered path is not exist or not correct fake ota{END_COLOR}')
            return

        self.__ota_path = new_ota_path

    def __flash_ota(self):
        if self.__ota_path is None:
            print(f'{ERROR_COLOR}Set ota path before ota flashing{END_COLOR}')
            return

        print('Wait device in recovery')
        self.__ubports_recovery.wait_device('recovery')

        if self.__verify_recovery and not self.__ubports_recovery.check_recovery():
            print(f'{ERROR_COLOR}Error: device in recovery detected, but is not ubports recovery{END_COLOR}')
            return

        self.__ubports_recovery.disable_ota_signature_verification()

        for file in glob.glob(f'{self.__ota_path}/*'):
            self.__ubports_recovery.push(file, '/cache/recovery/')
        print(self.__ubports_recovery.run_command_on_device('cd /cache/recovery && system-image-upgrader ubuntu_command'))

        if self.__wipe_data:
            self.__ubports_recovery.wipe_data()
            return

        self.__ubports_recovery.reboot('')

    def menu(self):
        print(f'''
Current ota path is {self.__ota_path}

(1) Set ota path
(2) {'Disable wipe data after ota flashing' if self.__wipe_data else 'Enable wipeing data after ota flashing'}
(3) {'Disable recovery verification after device detected' if self.__verify_recovery else 'Enable recovery verification after device detected'}
(4) Start ota flashing
(5) Exit
        ''')
        choiced_action = input('Input number from menu to invoke action: ')

        match choiced_action:
            case '1':
                self.__set_ota_path_action()
            case '2':
                self.__wipe_data = self.__change_boolen(self.__wipe_data)
            case '3':
                self.__verify_recovery = self.__change_boolen(self.__verify_recovery)
            case '4':
                self.__flash_ota()
            case '5':
                exit()

if __name__ == '__main__':
    program = Program()

    clear_console()
    while True:
       program.menu()
