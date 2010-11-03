Puppet::Type.newtype(:authrealm) do
  @doc = "Manage authentication realms of Glassfish domains"
  ensurable

  newparam(:name) do
    desc "The realm name."
    isnamevar
  end

  newparam(:classname) do
    desc "The Java class name. Ex. com.sun.identity.agents.appserver.v81.AmASRealm"
  end

  newparam(:properties) do
    desc "The properties. Ex. jaas-context=agentRealm"
  end

  newparam(:isdefault) do
    desc "Sets realm to default if true."
    defaultto false
  end

  newparam(:portbase) do
    desc "The Glassfish domain port base. Default: 4800"
    defaultto "4800"
  end

  newparam(:asadminuser) do
    desc "The internal Glassfish user asadmin uses. Default: admin"
    defaultto "admin"
  end

  newparam(:passwordfile) do
    desc "The file containing the password for the user."

    validate do |value|
      unless File.exists? value
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end

  newparam(:user) do
    desc "The user to run the command as."

    validate do |user|
      unless Puppet.features.root?
        self.fail "Only root can execute commands as other users"
      end
    end
  end
end
