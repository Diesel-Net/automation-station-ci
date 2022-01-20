ARG image

FROM $image

ARG license_file

COPY $license_file UnityLicense.ulf

COPY activate.sh activate.sh

RUN source activate.sh
