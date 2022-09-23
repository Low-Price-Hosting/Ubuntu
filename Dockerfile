FROM scratch
ARG RELEASE
ARG LAUNCHPAD_BUILD_ARCH
LABEL org.opencontainers.image.ref.name="ubuntu"
LABEL org.opencontainers.image.version=$RELEASE
ADD ubuntu-*-oci-$LAUNCHPAD_BUILD_ARCH-root.tar.gz /
CMD ["/bin/bash"]
