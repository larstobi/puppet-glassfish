require 'puppet/provider/asadmin'
Puppet::Type.type(:glassfish).provide(:asadmin,
                                      :parent => Puppet::Provider::Asadmin) do
  desc "Glassfish support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-domain"
    args << "--profile" << @resource[:profile]
    args << "--portbase" << @resource[:portbase]
    args << "--savelogin" << @resource[:domain]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-domain" << @resource[:domain]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-domains"]).each do |line|
      if line.match(/^Name:\ /)
        domain = line.split(" ")[1]
        return true if @resource[:domain] == domain
      end
    end
    return false
  end
end
