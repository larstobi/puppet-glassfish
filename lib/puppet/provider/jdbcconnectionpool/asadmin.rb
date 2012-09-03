require 'puppet/provider/asadmin'
Puppet::Type.type(:jdbcconnectionpool).provide(:asadmin, :parent =>
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish JDBC connection pool support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-jdbc-connection-pool"
    args << "--datasourceclassname" << @resource[:datasourceclassname]
    args << "--restype" << @resource[:resourcetype]
    args << "--property" << "\\\"#{@resource[:properties]}\\\""
    args << @resource[:name]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-jdbc-connection-pool" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-jdbc-connection-pools"]).each do |line|
      return true if @resource[:name] == line.chomp
    end
    return false
  end
end
