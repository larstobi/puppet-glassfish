require 'puppet/provider/asadmin'
Puppet::Type.type(:jvmoption).provide(:asadmin, :parent =>
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish jvm-options support."
  commands :asadmin => "asadmin"

  def create
    args = []
    args << "create-jvm-options"
    args << "'" + escape(@resource[:name]) + "'"
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << "delete-jvm-options" << "'" + escape(@resource[:name]) + "'"
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-jvm-options"]).each do |line|
      line.sub!(/-XX: ([^\ ]+)/, '-XX:+\1')
      if line.match(/^-.[^\ ]+/)
        return true if @resource[:name] == line.chomp
      end
    end
    return false
  end
end
