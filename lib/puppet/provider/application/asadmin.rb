require 'puppet/provider/asadmin'
Puppet::Type.type(:application).provide(:asadmin, :parent =>
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish application deployment support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "deploy" << "--precompilejsp=true"
    unless @resource[:contextroot] == ""
      args << "--contextroot" << @resource[:contextroot]
    end
    args << "--name" << @resource[:name]
    args << @resource[:source]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "undeploy" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-applications"]).each do |line|
      return true if @resource[:name] == line.split(" ")[0]
    end
    return false
  end
end
