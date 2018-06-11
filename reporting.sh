#!/bin/bash
#
# Copyright (c) 2009-2017. Authors: see NOTICE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

rm -r ./reporting.tgz

mkdir -p ./reporting

docker cp core:/usr/share/tomcat7/.grails/cytomineconfig.groovy ./reporting/configurationCore.groovy
docker cp core:/var/lib/tomcat7/logs/catalina.out ./reporting/catalinaCore.out
docker cp ims:/usr/share/tomcat7/.grails/imageserverconfig.properties ./reporting/configurationIMS.properties
docker cp ims:/var/lib/tomcat7/logs/catalina.out ./reporting/catalinaIMS.out
docker cp retrieval:/tmp/retrieval.log ./reporting/catalinaRetrieval.out
#docker cp iipJ2:/tmp/iip-openslide.out ./reporting/logIIPJ2.out
docker cp iip:/tmp/iip-openslide.out ./reporting/logIIPCyto.out

tail -n 200 ./reporting/catalinaCore.out           > ./reporting/catalinaCoreTail.out
mv ./reporting/catalinaCoreTail.out                  ./reporting/catalinaCore.out
tail -n 200 ./reporting/catalinaIMS.out            > ./reporting/catalinaIMSTail.out
mv ./reporting/catalinaIMSTail.out                   ./reporting/catalinaIMS.out
tail -n 200 ./reporting/catalinaRetrieval.out      > ./reporting/catalinaRetrievalTail.out
mv ./reporting/catalinaRetrievalTail.out             ./reporting/catalinaRetrieval.out

tail -n 200 ./reporting/logIIPCyto.out          > ./reporting/logIIPCytoTail.out
mv ./reporting/logIIPCytoTail.out                 ./reporting/logIIPCyto.out

cp ./configuration.sh ./reporting/configuration.sh
sed -i "/SENDER_EMAIL_PASS=/c\SENDER_EMAIL_PASS=******" ./reporting/configuration.sh

cp ./start_deploy.sh ./reporting/start_deploy.sh

tar -zcvf reporting.tgz reporting
rm -r ./reporting

