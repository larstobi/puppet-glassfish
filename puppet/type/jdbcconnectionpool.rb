Puppet::Type.newtype(:jdbcconnectionpool) do
  @doc = "Manage JDBC connection pools of Glassfish domains"

  ensurable

  newparam(:name) do
    desc "The JDBC connection pool name."
    isnamevar
  end

  newparam(:datasourceclassname) do
    desc "The data source class name. Ex. com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource"
  end

  newparam(:resourcetype) do
    desc "The resource type. Ex. javax.sql.ConnectionPoolDataSource"
  end

  newparam(:properties) do
    desc "The properties. Ex. user=myuser:password=mypass:url=jdbc\:mysql\://myhost.ex.com\:3306/mydatabase"
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
