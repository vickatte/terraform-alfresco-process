#!/usr/bin/env bash

git clone -b develop https://$GITHUB_TOKEN@github.com/Alfresco/alfresco-process-acceptance-tests.git
cd ./alfresco-process-acceptance-tests
mkdir -p $HOME/.m2
cp settings.xml $HOME/.m2
