# Type: dslocal_user
# Created: Mon Dec  5 12:19:52 PST 2011
Puppet::Type.newtype(:x_user) do
  @doc = "Manage Mac OS X DS Local user accounts
    dslocal_user { 'newuser':
      dslocal_node  => 'MyNode',
      uid           => '301',
      shell         => '/bin/bash',
      gid           => '80',
      home          => '/private/var/newuser',
      password      => '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000D56D545F53C451CA4CDA1B23ECD0D320B325DDFA70548FF30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
      comment       => 'A local user.',
      ensure        => 'present'
    }"
      
  ensurable do
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
    defaultto :present
  end

  newparam(:name) do
    desc 'The name of the user record to manage.'
    isnamevar
  end

  newparam(:dslocal_node) do
    desc 'The name of the node to manage. Default is "Default".'
    defaultto 'Default'
  end

  newparam(:uid) do
    desc 'The numeric UID for the users account.'
  end

  newparam(:shell) do
    desc "The user's shell attribute."
  end

  newparam(:gid) do
    desc "The user's numeric GID attribute."
  end

  newparam(:home) do
    desc "Path to the user's home directory."
  end

  newparam(:password_sha1) do
    desc "The user's password stored as a shadow hash string."
  end

  newparam(:password_sha512) do
    desc "The user's password stored as a salted SHA512 hex digest."
  end

  newparam(:comment) do
    desc "Add a comment about this user."
  end
  
  
end