# automation-station-ci
Automation Station CI


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


## Deployments
This application is configured and deployed automatically with [Drone CI](https://github.com/harness/drone) and [Ansible](https://github.com/ansible/ansible), however there might be situations where you would prefer to run the Ansible playbooks manually. 

If [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html#encrypting-content-with-ansible-vault) is being used then you will need to have the  password file installed on your machine. Please read the relevant ansible documentation on [setting a default password source](https://docs.ansible.com/ansible/latest/user_guide/vault.html#setting-a-default-password-source).

If you are trying to reuse this Ansible configuration for _your own_ purposes, then you will need to encrypt all of _your own_ secrets using _your own_ Ansible Vault password and replace those variables in the [Ansible configuration](.ansible) after forking/cloning.

### Requirements
I recommend [installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible) with `pip` (globally) versus other package managers like `apt` or `brew`. It makes upgrading and using third party modules much easier. If you are on Windows, I would also recommend installing Ansible onto the WSL filesystem instead of the Windows filesytem. 
```bash
python3 -m pip install --user ansible
```

### Steps
1. Install [Ansible roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) (playbook dependencies). This will download the roles defined in [requirements.yaml](.ansible/roles/requirements.yaml) and place them into `.ansible/roles` for you.
   ```bash
   ansible-galaxy install -r .ansible/roles/requirements.yaml -p .ansible/roles --force
   ```
2. Run [Ansible playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) against the `development` inventory.
   ```bash
   ansible-playbook .ansible/build.yaml -i .ansible/inventories/development
   ```
