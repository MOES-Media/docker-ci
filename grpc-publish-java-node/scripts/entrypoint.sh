#!/bin/sh
assets="/var/assets"
nodejsRoot="/workspace/nodejs"
javaRoot="/workspace/java"
docsRoot="/workspace/docs/md"
versionPlaceholder="__VERSION__"
namePlaceholder="__PACKAGE_NAME__"
gitUrlPlaceholder="__NPM_GIT_UTL__"

copyAssets() {
  cp $assets/package.json $nodejsRoot/package.json
  cp $assets/.npmrc $nodejsRoot/.npmrc
  cp $docsRoot/index.md $nodejsRoot/README.md
  cp $assets/pom.xml $javaRoot/pom.xml
  cp $assets/settings.xml $javaRoot/settings.xml
  cp $docsRoot/index.md $javaRoot/README.md
  if [[ "${local}" ]]; then
    cp -a $assets/mvn-wrapper/. $javaRoot/
  fi
}

setVariables() {
  sed -i "s/$versionPlaceholder/$VERSION/g" "$nodejsRoot/package.json"
  sed -i "s/$namePlaceholder/$NPM_PCK_NAME/g" "$nodejsRoot/package.json"
  sed -i "s/$gitUrlPlaceholder/$NPM_GIT_URL/g" "$nodejsRoot/package.json"

  if [[ -z "${local}" ]]; then
    sed -i "s/$versionPlaceholder/$VERSION/g" "$javaRoot/pom.xml"
  else
    sed -i "s/$versionPlaceholder/$VERSION-SNAPSHOT/g" "$javaRoot/pom.xml"
  fi

}

publish() {
  cd $nodejsRoot && npm publish
  cd $javaRoot && mvn -B package deploy -s $javaRoot/settings.xml
}

copyAssets
setVariables
if [[ -z "${local}" ]]; then
  publish
fi
