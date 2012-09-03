require 'puppet/provider/asadmin'
Puppet::Type.type(:domain).provide(:asadmin,
                                   :parent => Puppet::Provider::Asadmin) do
  desc "Glassfish support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-domain"
    args << "--profile" << @resource[:profile]
    args << "--portbase" << @resource[:portbase]
    args << "--savelogin" << @resource[:name]
    asadmin_exec(args)

    if @resource[:startoncreate]
      asadmin_exec(["start-domain", @resource[:name]])
      if @resource[:smf]
        asadmin_exec(["create-service", "--name", @resource[:name]])
        asadmin_exec(["stop-domain", @resource[:name]])
        `svccfg -s @resource[:name] setprop start/user = astring: @resource[:user]`
        `svccfg -s @resource[:name] setprop stop/user = astring: @resource[:user]`
        `svcadm refresh @resource[:name]`
      end
    end
  end

  def destroy
    args = []
    args << "delete-domain" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-domains"]).each do |line|
      domain = line.split(" ")[0] if line.match(/running/) # Glassfish > 3.0.1
      domain = line.split(" ")[1] if line.match(/^Name:\ /) # Glassfish =< 3.0.1
      return true if @resource[:name] == domain
    end
    return false
  end
end
