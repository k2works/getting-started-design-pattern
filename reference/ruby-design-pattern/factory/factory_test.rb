require 'minitest/autorun'
require './frog'
require './duck'
require './water_lily'
require './algae'
require './tiger'
require './tree'
require './habitat'
require './duck_pond'
require './frog_pond'
require './duck_water_lily_pond'
require './frog_algae_pond'
require './organism_factory'

describe Pond do
  # 池には３匹のアヒルがいる
  it 'should have three ducks.' do
    output =<<EOS
アヒル動物0がガーガー鳴いています。
アヒル動物1がガーガー鳴いています。
アヒル動物2がガーガー鳴いています。
アヒル動物0は食事中です。
アヒル動物1は食事中です。
アヒル動物2は食事中です。
アヒル動物0は静かに眠っています。
アヒル動物1は静かに眠っています。
アヒル動物2は静かに眠っています。
EOS
    pond = DuckPond.new(3,Duck,0,nil)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のカエルがいる
  it 'should have three frogs.' do
    output =<<EOS
カエル動物0はゲロゲロと鳴いています。
カエル動物1はゲロゲロと鳴いています。
カエル動物2はゲロゲロと鳴いています。
カエル動物0は食事中です。
カエル動物1は食事中です。
カエル動物2は食事中です。
カエル動物0は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物1は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物2は眠りません。一晩中ゲロゲロ鳴いています。
EOS
    pond = FrogPond.new(3,Frog,0,nil)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のアヒルと１つのスイレンがいる
  it 'should be three ducks and a waterlily.' do
    output =<<EOS
スイレン植物0は浮きながら日光を浴びて育ちます。
アヒル動物0がガーガー鳴いています。
アヒル動物1がガーガー鳴いています。
アヒル動物2がガーガー鳴いています。
アヒル動物0は食事中です。
アヒル動物1は食事中です。
アヒル動物2は食事中です。
アヒル動物0は静かに眠っています。
アヒル動物1は静かに眠っています。
アヒル動物2は静かに眠っています。
EOS
    pond = DuckWaterLilyPond.new(3,Duck,1,WaterLily)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のカエルと１つの藻がいる
  it 'should have three frogs and a algae.' do
    output =<<EOS
藻植物0は日光を浴びて育ちます。
カエル動物0はゲロゲロと鳴いています。
カエル動物1はゲロゲロと鳴いています。
カエル動物2はゲロゲロと鳴いています。
カエル動物0は食事中です。
カエル動物1は食事中です。
カエル動物2は食事中です。
カエル動物0は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物1は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物2は眠りません。一晩中ゲロゲロ鳴いています。
EOS
    pond = FrogAlgaePond.new(3,Frog,1,Algae)
    proc{pond.simulate_one_day}.must_output output
  end

end

describe Habitat do
  # 生息環境には１匹のトラと４本の木がいる
  it 'should have a tiger and four trees.' do
    output =<<EOS
樹木植物0が高く育っています。
樹木植物1が高く育っています。
樹木植物2が高く育っています。
樹木植物3が高く育っています。
トラ動物0はガオーとほえています。
トラ動物0は食べたいものを何でも食べます。
トラ動物0は眠くなったら眠ります。
EOS
    jungle_organism_factory = OrganismFactory.new(Tree,Tiger)
    habitat = Habitat.new(1,4,jungle_organism_factory)
    proc{habitat.simulate_one_day}.must_output output
  end

  # 生息環境には２匹のアヒルと４つのスイレンがいる
  it 'should have two ducks and four waterlilies.' do
    output =<<EOS
スイレン植物0は浮きながら日光を浴びて育ちます。
スイレン植物1は浮きながら日光を浴びて育ちます。
スイレン植物2は浮きながら日光を浴びて育ちます。
スイレン植物3は浮きながら日光を浴びて育ちます。
アヒル動物0がガーガー鳴いています。
アヒル動物1がガーガー鳴いています。
アヒル動物0は食事中です。
アヒル動物1は食事中です。
アヒル動物0は静かに眠っています。
アヒル動物1は静かに眠っています。
EOS
    pond_organism_factory = OrganismFactory.new(WaterLily,Duck)
    habitat = Habitat.new(2,4,pond_organism_factory)
    proc{habitat.simulate_one_day}.must_output output
  end
end