[![Build Status](https://drone.kiwi-labs.net/api/badges/Diesel-Net/automation-station-ci/status.svg)](https://drone.kiwi-labs.net/Diesel-Net/automation-station-ci)


# automation-station-ci
Automation Station Continuous Integration. This repository contains the Ansible and Drone configuration necessary for automatic weekly builds of [Automation Station](https://www.automationstationgame.com/).

A big shoutout to the Devs working on [Game-CI](https://game.ci/) making this CI/CD pipeline possible. Unity + Docker + Linux = :heart:




## Notes

Build Custom Unity Editor Docker image from `game-ci/docker`
```bash
docker build \
    -f ./images/ubuntu/editor/Dockerfile \
    -t docker.nexus.diesel.net/unity-editor:latest \
    --build-arg hubImage=unityci/hub:latest \
    --build-arg baseImage=unityci/base:latest \
    --build-arg version=2020.3.24f1 \
    --build-arg changeSet=79c78de19888 \
    --build-arg module=windows-mono \
    --cache-from unityci/editor \
    .
```

Generating a license (Obtaining .ulf)

```bash
# create empty .alf file
touch /home/automation/test/Unity_v2020.3.24f1.alf

docker run -it \
    -v /home/automation/test/Unity_v2020.3.24f1.alf:/Unity_v2020.3.24f1.alf \
    docker.nexus.diesel.net/unity-editor:2020.3.24f1-windows-mono \
    unity-editor -createManualActivationFile -logfile -

# visit this site to upload .alf file to get the .ulf file
# https://license.unity3d.com/manual

```

Activate license && build game
```bash
docker run \
    -v /home/automation/Unity_v2020.x.ulf:/Unity_v2020.x.ulf \
    -v /home/automation/.diesel/automation-station-ci/development/config/automation-station:/automation-station \
    docker.nexus.diesel.net/unity-editor:2020.3.24f1-windows-mono \
    /bin/bash -c "unity-editor -manualLicenseFile /Unity_v2020.x.ulf -quit -logFile - ; unity-editor -quit -projectPath /automation-station -executeMethod BuildRunner.BuildWindowsMonoRelease -logFile -"
```

Debug builds

```bash
docker run -it \
    -v /home/automation/Unity_v2020.x.ulf:/Unity_v2020.x.ulf \
    -v /home/automation/.diesel/automation-station-ci/development/config/automation-station:/automation-station \
    docker.nexus.diesel.net/unity-editor:2020.3.24f1-windows-mono \
    /bin/bash
```
