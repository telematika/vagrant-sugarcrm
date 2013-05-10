#!/usr/bin/env bash

sudo apt-get install -y curl pwgen

DB_USERNAME="root"
DB_PASSWORD="password"
DB_ADMIN_USER="sugarcrm"
DB_ADMIN_PASSWORD=`pwgen -cns 16`
SITE_ADMIN_PASSWORD="password"
SUGAR_SRC="https://github.com/telematika/sugarcrm_dev.git"
SUGAR_WWW=/var/www

rm -f "${SUGAR_WWW}/index.html"

if [[ ! -f "${SUGAR_WWW}/index.php" ]]; then
  echo "Installing sugarcrm..."

  echo "\tCREATE DATABASE ${DB_ADMIN_USER} DEFAULT CHARACTER SET = 'utf8';"
  echo "CREATE DATABASE ${DB_ADMIN_USER} DEFAULT CHARACTER SET = 'utf8';" | mysql --user=${DB_USERNAME} --password=${DB_PASSWORD} mysql || exit 1
  echo "\tGRANT all ON ${DB_ADMIN_USER}.* TO '${DB_ADMIN_USER}'@'localhost' IDENTIFIED BY '...';"
  echo "GRANT all ON ${DB_ADMIN_USER}.* TO '${DB_ADMIN_USER}'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';" | mysql --user=${DB_USERNAME} --password=${DB_PASSWORD} mysql || exit 1
  echo "\tFLUSH PRIVILEGES;"
  echo "FLUSH PRIVILEGES;" | mysql --user=${DB_USERNAME} --password=${DB_PASSWORD} mysql || exit 1

  echo "Cloning git repository..."
  git clone "${SUGAR_SRC}" "${SUGAR_WWW}"
  echo "Removing .git directory..."
  rm -rf "${SUGAR_WWW}/.git"

  echo "Creating configuration for silent installer..."
  cat > "${SUGAR_WWW}/config_si.php" << EOF
<?php
\$sugar_config_si = array (
  'setup_db_host_name' => 'localhost',
  'setup_db_database_name' => '${DB_ADMIN_USER}',
  'setup_db_drop_tables' => 0,
  'setup_db_create_database' => 1,
  'setup_db_pop_demo_data' => 0,
  'setup_site_admin_user_name' => 'admin',
  'setup_site_admin_password' => '${SITE_ADMIN_PASSWORD}',
  'setup_db_create_sugarsales_user' => 0,
  'setup_db_admin_user_name' => '${DB_ADMIN_USER}',
  'setup_db_admin_password' => '${DB_ADMIN_PASSWORD}',
  'setup_db_type' => 'mysql',
  'setup_site_url' => 'http://localhost',
  'setup_system_name' => 'Vagrant SugarCRM Installation',
  'default_currency_iso4217' => 'EUR',
  'default_currency_name' => 'Euro',
  'default_currency_significant_digits' => '2',
  'default_currency_symbol' => '€',
  'default_date_format' => 'd.m.Y',
  'default_time_format' => 'H:i',
  'default_decimal_seperator' => ',',
  'default_export_charset' => 'UTF-8',
  'default_language' => 'en_us',
  'default_locale_name_format' => 's f l',
  'default_number_grouping_seperator' => '.',
  'export_delimiter' => ',',
);
?>
EOF
  echo "Setting file system permissions..."
  sudo chown -Rfh www-data:www-data "${SUGAR_WWW}"

  SILENT_URL="http://localhost/install.php?goto=SilentInstall&cli=true"
  echo "Calling silent installer url : ${SILENT_URL}"
  curl "${SILENT_URL}"

  echo "Done."

  echo "Credentials: admin : ${SITE_ADMIN_PASSWORD}"
else
  echo "${SUGAR_WWW}/index.php exists, skipping installation."
fi
