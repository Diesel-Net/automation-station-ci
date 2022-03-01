ARG editor_image
FROM $editor_image

ARG license_file
COPY $license_file UnityLicense.ulf

COPY activate.sh activate.sh
RUN chmod +x activate.sh

RUN ./activate.sh
