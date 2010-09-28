Puppet::Type.type(:systemproperty).provide(:asadmin) do
  desc "Glassfish system-properties support."
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

  def escape(value)
    # Prepend three backslashes to escape the colon
    return value.gsub(/:/) { '\\\\\\:' }
  end

  def create
    args = []
    args << "create-system-properties"
    args << @resource[:name] + "=" + escape(@resource[:value])
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-system-property" << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-system-properties"]).each do |line|
      if line.match(/^[A-Za-z0-9]+=/)
        key, value = line.split("=")
        return true if @resource[:name] == key
      end
    end
    return false
  end
end
