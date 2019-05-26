FROM openjdk:8-jdk-alpine

RUN apk update && apk add bash

ADD hello-world.sh /tmp/hello-world.sh

CMD /bin/bash /tmp/hello-world.sh

ENTRYPOINT ["/bin/bash", "/tmp/hello-world.sh"]
