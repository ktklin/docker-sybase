# Dockerfile for sybase server
FROM centos:7

MAINTAINER Kurt Klinner (kurt@mobux.de)

# Adding resources
ENV ASE_DOWNLOADFILE http://d1cuw2q49dpd0p.cloudfront.net/ASE16/Linux16SP03/ASE_Suite.linuxamd64.tgz

# ASE Express downloaded via http://d1cuw2q49dpd0p.cloudfront.net/ASE16/Linux16SP03/ASE_Suite.linuxamd64.tgz
RUN mkdir /opt/tmp \
    && cd /opt/tmp \
    && curl $ASE_DOWNLOADFILE | tar -xzf -

COPY assets/* /opt/tmp/

# Setting kernel.shmmax and
RUN set -x \
 && cp /opt/tmp/sysctl.conf /etc/ \
 && true || /sbin/sysctl -p

# Installing Sybase RPMs
RUN set -x \
 && yum -y install glibc.i686 libaio unzip

# Install Sybase
RUN set -x \
 && /opt/tmp/setup.bin -f /opt/tmp/sybase-response.txt \
    -i silent \
    -DAGREE_TO_SAP_LICENSE=true \
    -DRUN_SILENT=true

# Copy resource file
RUN cp /opt/tmp/sybase-ase.rs /opt/sybase/ASE-16_0/sybase-ase.rs
RUN cp /opt/tmp/sybase-loc.rs /opt/sybase/ASE-16_0/sybase-loc.rs

# Build ASE server & change localization
RUN source /opt/sybase/SYBASE.sh \
 && /opt/sybase/ASE-16_0/bin/srvbuildres -r /opt/sybase/ASE-16_0/sybase-ase.rs \
 && /opt/sybase/ASE-16_0/bin/sqllocres -r /opt/sybase/ASE-16_0/sybase-loc.rs

# Change the Sybase interface
# Set the Sybase startup script in entrypoint.sh
RUN mv /opt/sybase/interfaces /opt/sybase/interfaces.backup \
 && cp /opt/tmp/interfaces /opt/sybase/ \
 && cp /opt/tmp/sybase-entrypoint.sh /usr/local/bin/ \
 && chmod +x /usr/local/bin/sybase-entrypoint.sh \
 && ln -s /usr/local/bin/sybase-entrypoint.sh /sybase-entrypoint.sh


ENTRYPOINT ["/sybase-entrypoint.sh"]

EXPOSE 5000

# Remove tmp
RUN find /opt/tmp/ -type f | xargs -L1 rm -f

# To run / test it call
# docker run -d -p 8000:5000 -p 8001:5001 --name mobuxer-sybase sybase
