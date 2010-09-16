Puppet::Type.type(:glassfish).provide(:asadmin) do
  desc "Glassfish support."

  def self.find_asadmin(path = ENV['PATH'])
    path.split(":").each do |directory|
      executable = directory + "/asadmin"
      if File.executable? executable
        debug executable
        return executable
      end
    end
    return ""
  end
  commands :asadmin => find_asadmin

  def create
    args = []
    args << "--user" << resource[:adminuser]
    args << "--passwordfile" << resource[:passwordfile]
    args << "create-domain"
    args << "--profile" << resource[:profile]
    args << "--portbase" << resource[:portbase]
    args << "--savelogin" << resource[:domain]
    Puppet.debug asadmin + " " + args.to_s
    asadmin(*args)
  end

  def destroy
    args = []
    args << "delete-domain" << resource[:domain]
    Puppet.debug asadmin + " " + args.to_s
    asadmin(*args)
  end

  def exists?
    asadmin("list-domains").each do |line|
      if line.match(/^Name:\ /)
        domain, status = line.split(" ").values_at(1,3)
        return true if resource[:domain] == domain
      end
    end
    return false
  end
end
