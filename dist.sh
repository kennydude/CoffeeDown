echo "Distribute"
mkdir -p gen/dist/src

coffee -c -o gen/dist/src src/*.coffee
cp src/*.md gen/dist/src
cp package.json gen/dist
cp *.md gen/dist
cp src/cli.js gen/dist/src

echo "npm publish gen/dist"
