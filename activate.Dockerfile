ARG image
FROM $image

ARG license_file

COPY $license_file UnityLicense.ulf

RUN unity-editor \
    -manualLicenseFile UnityLicense.ulf \
    -quit \
    -logFile -
