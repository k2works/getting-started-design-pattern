class VirtualAccountProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def method_missing(name, *args, &block)
    subject.public_send(name, *args, &block)
  end

  def respond_to_missing?(name, include_private = false)
    subject.respond_to?(name, include_private) || super
  end

  private

  def subject
    @subject ||= @creation_block.call
  end
end
