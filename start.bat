for /F "tokens=*" %f in ('ruby -v') do set rubyv=%f

if (rubyv содержит "не является внутренней или внешней") then ECHO "Установите ruby 2.3 или выше" _прервать выполнение

for /F "tokens=*" %f in ('bundle -v') do set bundlev=%f

if (bundlev содержит "не является внутренней или внешней") then 'gem install bundler'

for /F "tokens=*" %f in ('git --version') do set gitv=%f

if (bundlev содержит "не является внутренней или внешней") then ECHO "Установите git" _прервать выполнение

bundle install

ruby application.rb
