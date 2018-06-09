git checkout master

#!/usr/bin/env sh
set -e
echo "Enter release version: "
read VERSION

read -p "Releasing $VERSION - are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  VERSION=$VERSION

  # build
  yarn build
  yarn build:page
  yarn build:docs

  # commit
  npm version $VERSION --no-git-tag-version
  git tag v$VERSION
  git commit -am "build: release $VERSION"

  # merge
  git checkout gh-pages
  git rebase master
  git push origin gh-pages
  git checkout master
  git push origin master

  # publish
  npm publish
fi