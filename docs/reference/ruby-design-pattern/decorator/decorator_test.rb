require 'minitest/autorun'
require './simple_writer'
require './numbering_writer'
require './writer_decorator'
require './check_summing_writer'
require './time_stamping_writer'
require './numbering_writer_module'
require './time_stamping_writer_module'

describe SimpleWriter do
  # タイムスタンプ付きで出力される
  it 'should output with time stamp.' do
    input = 'Hello out there'
    output =<<-EOS
#{Time.new}: Hello out there
    EOS

    w = SimpleWriter.new('out')

    class << w

      alias old_write_line write_line

      def write_line(line)
        old_write_line("#{Time.new}: #{line}")
      end

    end

    w.write_line(input)
    w.close
    file = File.open('out')
    proc{puts file.read}.must_output output
    file.close
  end

  # タイムスタンプ付きで出力される
  it 'should output with time stamp.' do
    input = 'Hello out there'
    output =<<-EOS
1: #{Time.new}: Hello out there
    EOS

    w = SimpleWriter.new('out')
    w.extend(NumberingWriterModule)
    w.extend(TimeStampingWriterModule)

    w.write_line(input)
    w.close
    file = File.open('out')
    proc{puts file.read}.must_output output
    file.close
  end
end

describe NumberingWriter do
  # 行番号付きで出力される
  it 'should output with line number.' do
    input = 'Hello out there'
    output =<<-EOS
1: Hello out there
    EOS
    writer = NumberingWriter.new(SimpleWriter.new('final.txt'))
    writer.write_line(input)
    writer.close
    file = File.open('final.txt')
    proc{puts file.read}.must_output output
    file.close
  end
end

describe CheckSummingWriter do
  # タイムスタンプ付きで出力される
  it 'should output with time stamp.' do
    input = 'Hello out there'
    output =<<-EOS
1: #{Time.new}: Hello out there
    EOS
    writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('final2.txt'))))
    writer.write_line(input)
    writer.close
    file = File.open('final2.txt')
    proc{puts file.read}.must_output output
    file.close
  end

  # チェックサムが生成される
  it 'should generate checksum.' do
    input = 'Hello out there'
    output =<<-EOS
1: #{Time.new}: Hello out there
    EOS
    writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('final2.txt'))))
    writer.write_line(input)
    writer.close
    writer.check_sum.must_be_kind_of Fixnum
  end
end