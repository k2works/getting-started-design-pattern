require 'minitest/autorun'
require './task'
require './composite_task'
require './make_batter_task'
require './make_cake_task'

describe MakeBatterTask do
  before(:each) do
    @batter = MakeBatterTask.new
  end
  # バターを作るのに５分かかる
  it 'should take 5 minutes. ' do
    @batter.get_time_required.must_equal 5.0
  end
  # バターを作る工程は全部で３工程ある
  it 'should have 3 tasks' do
    @batter.total_number_basic_tasks.must_equal 3
  end
end

describe MakeCakeTask do
  before(:each) do
    @cake = MakeCakeTask.new
  end

  # ケーキを焼くのに２２分かかる
  it 'should take 22 minutes.' do
    @cake.get_time_required.must_equal 22.0
  end
  # ケーキを焼く工程のバターを作る工程の中の混ぜる工程の時間は３分である
  it 'should 3 minutes of mix task which is in making batter in making cake task.' do
    @cake[0][2].get_time_required.must_equal 3.0
  end
  # 冷凍工程の後に再度焼く工程を追加する
  it 'should be added bake task after frost task.' do
    @cake[5] = @cake[4]
    @cake[4] = @cake[3]
    @cake[3] = BakeTask.new

    @cake[3].name.must_equal 'Bake'
    @cake[4].name.must_equal 'Frost'
    @cake[5].name.must_equal 'Lick spoon'
  end
  # ケーキを焼く工程はバターを作る工程の親工程である
  it 'should be parent task of making batter task.' do
    @cake[0].name.must_equal 'Make batter'
    @cake[0].parent.name.must_equal 'Make cake'
  end
  # ケーキを焼く工程は全部で全部で７工程ある
  it 'should have 7 tasks' do
    @cake.total_number_basic_tasks.must_equal 7
  end
end