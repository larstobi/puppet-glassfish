require 'puppet/provider/asadmin'
Puppet::Type.type(:systemproperty).provide(:asadmin, :parent => 
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish system-properties support."
  commands :asadmin => "asadmin"

  def escape(value)
    # Add three backslashes to escape the colon
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
