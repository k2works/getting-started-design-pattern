require 'minitest/autorun'
require './array_iterator'
require './account'
require './portfolio'
require 'pathname'

describe ArrayIterator do
  # 配列の内容を順番に出力する
  it "should output of array's content." do
    array_in = ['red', 'green', 'blue']
    array_out = []
    i = ArrayIterator.new(array_in)
    while i.has_next?
      array_out << i.next_item
    end
    array_out.must_equal array_in
  end

  # 文字列を分割して出力する
  it "should output array's character split." do
    i = ArrayIterator.new('abc')
    array_out = []
    while i.has_next?
      array_out << i.next_item.chr
    end
    array_out.must_equal ['a','b','c']
  end

  # コードブロックで配列の内容を順番に出力する
  it "should output of array's content by code block." do
    a_in = [10, 20, 30]
    a_out = <<-EOS
10
20
30
EOS
    i = ArrayIterator.new(a_in)
    proc {i.for_each_element(a_in) {|element| puts element}}.must_output a_out
  end

  # eachメソッドを使ってコードブロックで配列の内容を順番に出力する
  it "should output of array's content by code block with each method." do
    a_in = [10, 20, 30]
    a_out = <<-EOS
10
20
30
    EOS
    proc {a_in.each {|element| puts element}}.must_output a_out
  end

  # 二つの配列をマージする
  it "should be merged two array's." do
    array1 = [1,2,3]
    array2 = [3,4,5]
    i = ArrayIterator.new(Array.new)
    i.merge(array1,array2).must_equal [1,2,3,3,4,5]
  end

  # eachメソッドを使ってコードブロックで安全に配列の内容を順番に出力する
  it "should output of array's content safely by code block with each method." do
    a_in = ['red', 'green', 'blue', 'purple']
    a_out = <<-EOS
red
blue
purple
    EOS
    i = ArrayIterator.new(a_in)
    a_in.delete('green')
    proc { i.change_resistant_for_each_element(a_in) do |element|
      puts(element)
      if element == 'green'
        element.delete(element)
      end
    end }.must_output a_out
  end
end

describe Portfolio do
  before(:each) do
    @portfolio = Portfolio.new
  end

  # ポートフォリの口座に$2000より多くの残高ある
  it "should have account which over 2000." do
    @portfolio.add_account(Account.new('Tom',1000))
    @portfolio.add_account(Account.new('Jerry',2001))
    @portfolio.any? {|account| account.balance > 2000}.must_equal true
  end

  # すべての口座の残高が$10以上ある
  it "should have all accounts which over 10." do
    @portfolio.add_account(Account.new('Tom',10))
    @portfolio.add_account(Account.new('Jerry',10))
    @portfolio.all? {|account| account.balance >= 10}.must_equal true
  end

end

describe String do
  # 有名な早口言葉から文字'p'で始まる全ての単語を検索する
  it "should output word which start from p in famus tongue twister." do
    out =<<-EOS
The word is Peter
The word is Piper
The word is picked
The word is peck
The word is pickled
The word is peppers
    EOS

    s = 'Peter Piper picked a peck of pickled peppers'
    proc{s.scan(/[Pp]\w*/) {|word| puts("The word is #{word}")}}.must_output out
  end
end

describe Hash do
  # ハッシュの各キーを出力する
  it 'should output key in hash.' do
    out =<<-EOS
name
eyes
sex
    EOS
    h = {'name'=>'russ', 'eyes'=>'blue','sex'=>'male'}
    proc {h.each_key { |key| puts(key)}}.must_output out
  end

  # ハッシュの各値を出力する
  it 'should output value in hash.' do
    out =<<-EOS
russ
blue
male
    EOS
    h = {'name'=>'russ', 'eyes'=>'blue','sex'=>'male'}
    proc {h.each_value { |value| puts(value)}}.must_output out
  end

  # ハッシュの内容を出力する
  it 'should output content of hash.' do
    out =<<-EOS
name russ
eyes blue
sex male
    EOS
    h = {'name'=>'russ', 'eyes'=>'blue','sex'=>'male'}
    proc {h.each {|key,value| puts("#{key} #{value}")}}.must_output out
  end
end

describe File do
  # ファイルの内容を出力する(外部イテレレータ)
  it 'should output file content.' do
    out = ''
    f = File.open('names.txt')
    while not f.eof?
      out << f.readline
    end
    f.close
    out.must_equal "hoge\npyo"
  end
  # ファイルの内容を出力する(内部イテレレータ)
  it 'should output file content.' do
    out = ''
    f = File.open('names.txt')
    f.each {|line| out << line}
    f.close
    out.must_equal "hoge\npyo"
  end
end

describe Pathname do
  before(:each) do
    @pn = Pathname.new('/usr/local/lib/ruby')
  end
  # パスのコンポートネントを走査する
  it 'should output path components.' do
    output =<<-EOS
File: usr
File: local
File: lib
File: ruby
    EOS
    proc{@pn.each_filename {|file| puts("File: #{file}")}}.must_output output
  end
end