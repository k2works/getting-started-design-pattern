class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def method_missing(name, *args, &block)
    check_access
    @subject.public_send(name, *args, &block)
  end

  def respond_to_missing?(name, include_private = false)
    @subject.respond_to?(name, include_private) || super
  end

  private

  def check_access
    return if Etc.getlogin == @owner_name

    raise "Illegal access: #{Etc.getlogin} cannot access account."
  end
end
