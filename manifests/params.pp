class ssh::params {
  $accept_env                      = 'LANG LC_*'
  $address_family                  = undef
  $allowed_users                   = []
  $allowed_groups                  = []
  $authorized_keys_file            = ['%h/.ssh/authorized_keys']
  $authorized_keys_command         = undef
  $authorized_keys_command_user    = undef
  $banner_manage                   = false
  $banner_enable                   = false
  $banner_template                 = 'ssh/issue.erb'
  $compression                     = undef
  $ciphers                         = []
  $client_alive_interval           = undef
  $client_alive_count_max          = undef
  $client_config_template          = 'ssh/ssh_config.erb'
  $client_enable_ssh_key_sign      = 'yes'
  $client_forward_agent            = 'no'
  $client_hostbased_authentication = 'no'
  $deny_groups                     = []
  $gateway_ports                   = 'no'
  $gssapi_authentication           = 'no'
  $gssapi_keyexchange              = 'no'
  $gssapi_cleanupcredentials       = 'yes'
  $kerberos_authentication         = 'no'
  $known_host_sssd                 = undef
  $manage_service                  = true
  $max_auth_retries                = 6
  $macs                            = []
  $password_authentication_groups  = []
  $password_authentication_users   = []
  $password_authentication         = 'no'
  $permit_root_login               = 'no'
  $permit_tunnel                   = 'no'
  $permit_tty                      = undef
  $permit_tty_users                = {}
  $permit_user_environment         = 'no'
  $port                            = '22'
  $print_motd                      = 'no'
  $pubkey_authentication           = 'yes'
  $server_config_template          = 'ssh/sshd_config.erb'
  $server_key_bits                 = '1024'
  $syslog_facility                 = 'AUTH'
  $syslog_level                    = 'INFO'
  $use_pam                         = 'yes'
  $use_dns                         = 'yes'
  $x11_forwarding                  = 'yes'
  $match                           = {}
  case $::osfamily {
    'Debian': {
      $subsystem_sftp  = '/usr/lib/openssh/sftp-server'
      $service_name = 'ssh'
      $banner_file  = '/etc/issue.net'
    }
    'RedHat': {
      $subsystem_sftp  = '/usr/libexec/openssh/sftp-server'
      $service_name = 'sshd'
      $banner_file  = '/etc/issue'
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}, currently only supports Debian and RedHat")
    }
  }
  case $::operatingsystem {
    'Debian': {
      if (versioncmp($::operatingsystemmajrelease, '8') >= 0) {
        $service_provider  = 'systemd'
      }

      if (versioncmp($::operatingsystemmajrelease, '7') >= 0) {
        $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key','/etc/ssh/ssh_host_ecdsa_key']
      } else {
        $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key']
      }
    }
    'Ubuntu': {
      if (versioncmp($::operatingsystemmajrelease, '15.04') >= 0) {
        $service_provider  = 'systemd'
      }

      if (versioncmp($::operatingsystemmajrelease, '14.04') >= 0) {
        $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key','/etc/ssh/ssh_host_ecdsa_key','/etc/ssh/ssh_host_ed25519_key']
      } else {
        $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key']
      }
    }
    'RedHat': {
      case $::operatingsystemrelease {
        /^7.*/: {
          $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_ecdsa_key','/etc/ssh/ssh_host_ed25519_key']
        }
        default : {
          $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key']
        }
      }
    }
    default : {
      $host_keys=['/etc/ssh/ssh_host_rsa_key','/etc/ssh/ssh_host_dsa_key']
    }
  }
}
