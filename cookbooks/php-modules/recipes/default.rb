# encoding: UTF-8
#
# Einige Module für PHP nachinstallieren.

execute "apt-get update"

package "imagemagick" do
  action :install
end

package "php5-curl" do
  action :install
end

package "php5-gd" do
  action :install
end

package "php5-imagick" do
  action :install
end

package "php5-mcrypt" do
  action :install
end

package "php5-mysql" do
  action :install
end

package "php5-suhosin" do
  action :install
end

package "php5-xdebug" do
  action :install
end

package "sendmail" do
  action :install
end
