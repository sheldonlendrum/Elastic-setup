!#/bin/bash

#CONFIG
elkversion=7.4.0
elasticserver="192.168.10.38:9200"
kibanaserver="192.168.10.38:80"

# Packages
metricbeatpkg="metricbeat-$elkversion-amd64.deb"
metricbeaturl="https://artifacts.elastic.co/downloads/beats/metricbeat/$metricbeatpkg"

filebeatpkg="filebeat-$elkversion-amd64.deb"
metricbeaturl="https://artifacts.elastic.co/downloads/beats/filebeat/$filebeatpkg"

echo " Downloading:  $metricbeatpkg  "
curl -L -O $metricbeaturl
sudo dpkg -i $metricbeatpkg

echo ""
echo "   metricbeat installed   "
echo ""

echo " Downloading:  $filebeatpkg  "
curl -L -O $filebeatpkg
sudo dpkg -i $filebeatpkg

echo ""
echo "   filebeat installed   "
echo ""

rm $filebeatpkg
rm $metricbeatpkg

echo "   updating config   "
sudo sed -i "/#host: \"localhost:5601\"/c\ \ host: \"$kibanaserver\"" /etc/metricbeat/metricbeat.yml
sudo sed -i "/localhost:9200/c\ \ hosts: [\"$kibanaserver\"]" /etc/metricbeat/metricbeat.yml

sudo sed -i "/#host: \"localhost:5601\"/c\ \ host: \"$kibanaserver\"" /etc/filebeat/filebeat.yml
sudo sed -i "/localhost:9200/c\ \ hosts: [\$kibanaserver\"]" /etc/filebeat/filebeat.yml


echo ""
echo "  Define which pages need to be installed.   "
echo ""

echo "Install for REDIS? [Y/n]"
read inputredis
if [[ $inputredis == "Y" || $inputredis == "y" || $inputredis == "yes" ]]; then
    echo "Installed metricbeat and filebeat for REDIS:"

	sudo metricbeat modules enable redis
	sudo filebeat modules enable redis

fi

echo "Install for NGINX? [Y/n]"
read inputnginx
if [[ $inputnginx == "Y" || $inputnginx == "y" || $inputnginx == "yes" ]]; then
    echo "Installed metricbeat and filebeat for NGINX:"

	sudo metricbeat modules enable nginx
	sudo filebeat modules enable nginx
fi

echo "Install for php_fpm? [Y/n]"
read inputphp
if [[ $inputphp == "Y" || $inputphp == "y" || $inputphp == "yes" ]]; then
    echo "Installed metricbeat for php_fpm:"

	sudo metricbeat modules enable php_fpm
fi

echo "Install for mysql? [Y/n]"
read inputmysql
if [[ $inputmysql == "Y" || $inputmysql == "y" || $inputmysql == "yes" ]]; then
    echo "Installed metricbeat and filebeat for mysql:"

	sudo metricbeat modules enable mysql
	sudo filebeat modules enable mysql
fi

echo "Install for moongodb? [Y/n]"
read inputmongo
if [[ $inputmongo == "Y" || $inputmongo == "y" || $inputmongo == "yes" ]]; then
    echo "Installed metricbeat and filebeat for inputmongo:"

	sudo metricbeat modules enable mongodb
	sudo filebeat modules enable mongodb
fi

echo ""
echo "  Starting services..  "
echo ""

sudo metricbeat setup
sudo service metricbeat start

sudo filebeat setup
sudo service filebeat start

echo ""
echo "  Finish setup metricbeat and filebeat   "
echo ""
