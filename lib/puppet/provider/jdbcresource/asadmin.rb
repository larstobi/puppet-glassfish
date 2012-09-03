require 'puppet/provider/asadmin'
Puppet::Type.type(:jdbcresource).provide(:asadmin, :parent =>
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish JDBC connection pool support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-jdbc-resource"
    args << "--connectionpoolid" << @resource[:connectionpool]
    args << @resource[:name]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-jdbc-resource" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-jdbc-resources"]).each do |line|
      return true if @resource[:name] == line.chomp
    end
    return false
  end
end
