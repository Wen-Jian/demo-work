FROM ruby:2.5.3

MAINTAINER Wen <genning7@gmail.com>

# 設定一個程式起始的目錄
ENV APP_HOME /usr/src/app
RUN mkdir -p $APP_HOME

ENV RAILS_ENV production

# 將現在（本地）所在專案目錄加入到 Docker Image 內
ADD . $APP_HOME

# 設定 Docker 的工作目錄
WORKDIR $APP_HOME
RUN gem install bundler
RUN cd $APP_HOME && bundle install --without development test --deployment

# RUN bundle exec rake db:migrate && rake db:seed

# 連結需要的設定檔
# ADD vendor/configs/.env $APP_HOME/.env
# ADD vendor/configs/database.yml.example $APP_HOME/config/database.yml

# 加入啟動用的 shell command
ADD vendor/entrypoint /usr/bin/entrypoint

# 設定 Server Port
EXPOSE 3000
# 告知 Docker 要用哪個指定啟動服務
# ENTRYPOINT ["/usr/bin/entrypoint"]
# RUN rails s -e $RAILS_ENV

