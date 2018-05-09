#!/bin/bash

#
# Copyright (c) 2009-2018. Authors: see NOTICE file.
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

### transform the ims urls for the config file ###
arr=$(echo $IMS_URLS | tr "," "\n")
arr=$(echo $arr | tr "[" "\n")
arr=$(echo $arr | tr "]" "\n")

if [ $IS_LOCAL = true ]; then
	echo "#Custom adding" >> /etc/hosts
	echo "$(route -n | awk '/UG[ \t]/{print $2}')       $CORE_URL" >> /etc/hosts
	echo "$(route -n | awk '/UG[ \t]/{print $2}')       $UPLOAD_URL" >> /etc/hosts
	for x in $arr
	do
	    echo "$(route -n | awk '/UG[ \t]/{print $2}')       $x" >> /etc/hosts
	done
fi

cd /software_router/
mv /tmp/config.groovy .

echo "cytomineCoreURL='http://$CORE_URL'" >> config.groovy
echo "rabbitUsername='$RABBITMQ_LOGIN'" >> config.groovy
echo "rabbitPassword='$RABBITMQ_PASSWORD'" >> config.groovy
echo "groovyPath='$GROOVY_PATH'" >> config.groovy
echo "publicKey='$RABBITMQ_PUB_KEY'" >> config.groovy
echo "privateKey='$RABBITMQ_PRIV_KEY'" >> config.groovy

# horrible hack for groovy with dash
# PATH="$PATH:$GROOVY_HOME/bin:/root/anaconda/bin"

touch /tmp/test.out

java -jar Cytomine-software-router.jar > /tmp/test.out &

# bash wrapdocker #&& service docker start

tail -f /tmp/test.out
