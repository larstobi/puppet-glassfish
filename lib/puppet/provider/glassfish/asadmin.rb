Puppet::Type.type(:glassfish).provide(:asadmin) do
  desc "Glassfish support."
  commands :asadmin => "asadmin"

  def asadmin_exec(passed_args)
    port = @resource[:portbase].to_i + 48
    args = []
    args << "--port" << port.to_s
    args << "--user" << @resource[:asadminuser]
    args << "--passwordfile" << @resource[:passwordfile]
    passed_args.each { |arg| args << arg }
    exec_args = ""
    args.each { |arg| exec_args += arg += " " }
    command = "asadmin #{exec_args}"
    command = "su - #{@resource[:user]} -c \"#{command}\"" if @resource[:user]
    self.debug command
    result = `#{command}`
    self.fail result unless $?.exitstatus == 0
    result
  end

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
