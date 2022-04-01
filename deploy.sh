#!\bin\bash

# остановить публикацию при ошибках
set -e

#сборка приложения
npm run build

#переход в каталог сборки
cd dist

#инициаоизация репозитория и загрузка кода в GitHub
git init
git add -A
git commit -m 'deploy'

git push -f https://github.com/Fozzyk/vue-app.git master:gh-pages

cd ..