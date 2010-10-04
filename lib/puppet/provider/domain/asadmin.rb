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
