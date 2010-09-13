Puppet::Type.newtype(:glassfish) do
  @doc = "Manage Glassfish domains"

  ensurable

  newparam(:domain) do
    desc "The Glassfish domain name."
    isnamevar
  end

  newparam(:portbase) do
    desc "The Glassfish domain port base."
  end

  newparam(:profile) do
    desc "Glassfish domain profile: cluster, devel, etc."
  end

  newparam(:adminuser) do
    desc "The internal Glassfish user asadmin uses. Default: admin"
    defaultto "admin"
  end

  newparam(:passwordfile) do
    desc "The file containing the password for the user."
  end
end
