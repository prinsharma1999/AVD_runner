#!/bin/bash

# Setting variables:

# Put in LIST_AVD variable the path to the
# avdmanager script located inside */Android/Sdk/tools/bin/
# Include the extension(.bat) in Windows.
#
# Windows example:
# LIST_AVD="C:/Users/<username>/AppData/Local/Android/sdk/tools/bin/avdmanager.bat"
#
# MacOS example: 
# LIST_AVD="/Users/<username>/Library/Android/sdk/tools/bin/avdmanager"
#
# Ubuntu example:
# LIST_AVD="/root/Android/Sdk/tools/bin/avdmanager"
#
LIST_AVD="AVDMANAGER_PATH"

# Put in RUN_AVD variable the path to the
# emulator exe located inside */Android/sdk/emulator/
# Include the extension(.exe) in Windows.
#
# Windows example:
# RUN_AVD="C:/Users/<username>/AppData/Local/Android/sdk/emulator/emulator.exe"
#
# MacOS example: 
# RUN_AVD="/Users/<username>/Library/Android/sdk/emulator/emulator"
#
# Ubuntu example:
# RUN_AVD="/root/Android/Sdk/emulator/emulator"
#
RUN_AVD="EMULATOR_PATH"

##########################################################################
#                                                                        #
#     If you don't have JAVA_HOME, ANDROID_HOME(Windows and MacOS)       #
#                                                                        #
#  or ANDROID_AVD_HOME(Linux) in your environment variables you need to  #
#                                                                        #
#            uncomment the following export instructions:                #
#                                                                        #
##########################################################################

# For Windows, MacOS and Linux:
# Put in JAVA_HOME variable the path to the Java SDK
#
# Windows example:
# export JAVA_HOME="C:/Program Files/Java/jdk1.8.0_171"
#
# MacOS example: 
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home"
#
# Ubuntu example:
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
#
# Instruction to uncomment if you don't have JAVA_HOME as environment variable:
#export JAVA_HOME="JAVA_JDK_PATH"

# For Windows and MacOS:
# Put in ANDROID_HOME variable the path to the Android Studio SDK
#
# Windows example:
# export ANDROID_HOME="C:/Users/<username>/AppData/Local/Android/sdk"
#
# MacOS example: 
# export ANDROID_HOME="/Users/<username>/Library/Android/sdk"
#
# Instruction to uncomment if you don't have ANDROID_HOME as environment variable(Windows or MacOS):
#export ANDROID_HOME="ANDROID_STUDIO_SDK_PATH"

# For Linux:
# Put in ANDROID_AVD_HOME variable the path to the Android Studio SDK
#
# Ubuntu example:
# export ANDROID_AVD_HOME="/root/.android/avd"
#
# Instruction to uncomment if you don't have ANDROID_AVD_HOME as environment variable(Linux):
#export ANDROID_AVD_HOME="ANDROID_STUDIO_SDK_PATH_LINUX"


# Script core:

printf "\n"

# Retrieve all available devices with their specs and list them
devices_specs="$($LIST_AVD list avd | sed '/Android Virtual Devices:/d')"

# Quoting (") does matter to preserve multi-line values
# Print all available devices
echo "$devices_specs"

printf "\n"

device_number=0

# Save available devices name.
devices_name="$(echo "$devices_specs" | grep 'Name: ')"

# Map of the type {device_number: device_name}
devices_list=()

# Put in a map the device number and its name.
while read -r line
do
  current_device="$(echo "$line" | sed -n -e 's/^.*Name: //p')"
  devices_list[$device_number]=$current_device
  echo "$device_number) $current_device"
  ((device_number++))
done <<< "$devices_name"

printf "\n"

# Waiting for device choice.
read  -p "Choose a device and insert its number:" device_number_choice

# Check if the device choice is valid.
while true
do
  # Check if the chosen device's number is in the map's keys.
  if [[ -z "${devices_list[$device_number_choice]}" ]]; then
    read  -p "Invalid device number, try again:" device_number_choice
  else
    break
  fi
done

# Run emulator according to the choice and let the bash in background.
$RUN_AVD -avd "${devices_list[$device_number_choice]}" &
