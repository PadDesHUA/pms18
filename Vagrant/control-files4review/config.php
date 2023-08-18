<?php
$CONFIG = array (
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/owncloud/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/owncloud/custom',
      'url' => '/custom',
      'writable' => true,
    ),
  ),
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'control',
    2 => '172.18.0.2',
  ),
  'datadirectory' => '/mnt/data/files',
  'dbtype' => 'sqlite',
  'dbhost' => '',
  'dbname' => 'owncloud',
  'dbuser' => '',
  'dbpassword' => '',
  'dbtableprefix' => 'oc_',
  'log_type' => 'owncloud',
  'supportedDatabases' => 
  array (
    0 => 'sqlite',
    1 => 'mysql',
    2 => 'pgsql',
  ),
  'upgrade.disable-web' => true,
  'default_language' => 'en',
  'overwrite.cli.url' => 'http://localhost/',
  'htaccess.RewriteBase' => '/',
  'logfile' => '/mnt/data/files/owncloud.log',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'filelocking.enabled' => true,
  'passwordsalt' => 'cVftaCNKXOn4Wapa4+TQIZ+HBaRt14',
  'secret' => '8ONuJW9pI3Oury4+mZJg9LQbOPFMwurluyXBrI3tZMY/UJv4',
  'version' => '10.12.2.1',
  'allow_user_to_change_mail_address' => '',
  'logtimezone' => 'UTC',
  'installed' => true,
  'instanceid' => 'occ4r9o25h2l',
);
