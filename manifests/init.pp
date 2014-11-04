# == Defined Type: svn_auth_simple
#
# Manage repository credentials in user's home directory.
#
# === Parameters
#
# [*owner*]
#   System user, credentials are delivered for.
#
# [*group*]
#   System user's group.
#
# [*home*]
#   System user's home directory.
#
# [*uri*]
#   Subversion URI.
#
# [*username*]
#   Subversion user's name.
#
# [*password*]
#   Subversion user's password.
#
#
# === Authors
#
# Tio Teath <tioteath@gmail.com>
#

define svn_auth_simple (
  $owner,
  $group,
  $home,
  $uri,
  $username,
  $password,
) {
  ensure_resource('file', [
    "${home}/.subversion",
    "${home}/.subversion/auth",
    "${home}/.subversion/auth/svn.simple"
  ], {
    'ensure'=> 'directory',
    'owner' => $owner,
    'group' => $group,
    'mode'  => '0700'
  })

  $svn_realm = svn_realm_string_digest($uri)
  $realm_string = $svn_realm[0]
  $digest = $svn_realm[1]
  file { "${home}/.subversion/auth/svn.simple/${digest}":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0600',
    content => template('svn_auth_simple/svn-auth.simple.erb'),
  }
}
