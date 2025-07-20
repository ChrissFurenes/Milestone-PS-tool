# Scripts to automate simple tasks in Milestone XProtect and AXIS

These scripts are designed to automate simple tasks in Milestone XProtect. They are intended for use by system administrators and developers who want to improve efficiency.

[Milestone PS tools](https://www.milestonepstools.com/) is used to interact with the Milestone XProtect system and perform various tasks.

1. [Milestone AXIS check SD card](https://github.com/ChrissFurenes/Milestone-PS-tool/tree/main/1.%20Milestone_AXIS_check_SD_Card)
   - This script checks the SD card status of AXIS cameras in a Milestone XProtect environment.
   - It requires the `milestoneps-tools` module and an admin user in XProtect.

2. [Milestone Camera model group](https://github.com/ChrissFurenes/Milestone-PS-tool/tree/main/2.%20Milestone_Camera_model_group)
   - When running, it will ask to connect to a management server, then create groups based on camera model name
   - it only adds camera stream that is enabled

3. [Milestone Snapshot](https://github.com/ChrissFurenes/Milestone-PS-tool/tree/main/3.%20Milestone_Snapshot) **IN PROGRESS!**
   - Take a snapshot of all cameras in selected groups or recording servers.
   - It requires the `milestoneps-tools` module and an admin user in XProtect.
   - The script will create a folder structure based on the camera model and save the snapshots there.

4. [Milestone Group Update device password](https://github.com/ChrissFurenes/Milestone-PS-tool/tree/main/4.%20Milestone_group_update_device_password)
    - Update device password in bulk, selected devices in recording server or device group.
    - It requires the `milestoneps-tools` module and an admin user in XProtect.
    - The script will prompt for the new password and update the selected devices.

## TODO
- [X] make camera folder based on camera-device model and assign active camera to it.
- [X] add camera to group based on camera model name.
- [ ] snapshot of all cameras in selected groups or recording servers. **IN PROGRESS**
- [ ] Creating an automated version of some scripts **IN PROGRESS**
- [ ] update device password in bulk, selected devices in recording server or device group.
- [ ] report of a system and cameras
- [ ] openAI/ChatGPT creates a description of the camera image
- [ ] update camera/device clock time from local computer
- [ ] add ntp server to camera/device
- [ ] create backup of camera/device configuration
- [ ] report of available firmware updates for cameras/devices **AXIS ONLY!**




## Missing something?
Create an issue or a pull request to add your script to this list.
