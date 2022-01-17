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
