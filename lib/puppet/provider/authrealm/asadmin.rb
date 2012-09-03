require 'puppet/provider/asadmin'
Puppet::Type.type(:authrealm).provide(:asadmin, :parent =>
                                      Puppet::Provider::Asadmin) do
  desc "Glassfish authentication realms support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-auth-realm"
    args << "--classname" << @resource[:classname]
    args << "--property" << "\\\"#{@resource[:properties]}\\\""
    args << @resource[:name]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-auth-realm" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-auth-realms"]).each do |line|
      return true if @resource[:name] == line.split(" ")[0]
    end
    return false
  end
end
