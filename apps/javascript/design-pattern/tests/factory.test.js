import { describe, it, expect } from '@jest/globals';
import {
  Duck, Frog, Tiger, WaterLily, Algae, Tree,
  Pond,
  OrganismFactory, Habitat,
} from '../src/factory.js';

describe('Factory パターン', () => {
  describe('生物クラス', () => {
    it('Duck が鳴く', () => {
      const duck = new Duck('ドナルド');
      expect(duck.speak()).toBe('ドナルド: ガーガー');
    });

    it('Frog が鳴く', () => {
      const frog = new Frog('ケロ太');
      expect(frog.speak()).toBe('ケロ太: ゲロゲロ');
    });

    it('WaterLily が成長する', () => {
      const lily = new WaterLily('蓮');
      expect(lily.grow()).toContain('水面に広がる');
    });
  });

  describe('Factory Method (Pond)', () => {
    it('カエルの池を作れる', () => {
      const pond = new Pond(2, 3, Frog, WaterLily);
      const result = pond.simulate();

      expect(result).toHaveLength(5);
      expect(result[0]).toContain('ゲロゲロ');
      expect(result[2]).toContain('水面に広がる');
    });

    it('虎のジャングルを作れる', () => {
      const jungle = new Pond(1, 2, Tiger, Tree);
      const result = jungle.simulate();

      expect(result).toHaveLength(3);
      expect(result[0]).toContain('ガオー');
      expect(result[1]).toContain('そびえ立つ');
    });
  });

  describe('Abstract Factory (Habitat)', () => {
    it('OrganismFactory でカエル + 藻の生態系を作れる', () => {
      const factory = new OrganismFactory(Frog, Algae);
      const habitat = new Habitat(2, 1, factory);
      const result = habitat.simulate();

      expect(result).toHaveLength(3);
      expect(result[0]).toContain('ゲロゲロ');
      expect(result[2]).toContain('繁殖する');
    });

    it('異なるファクトリで異なる生態系を作れる', () => {
      const pondFactory = new OrganismFactory(Duck, WaterLily);
      const jungleFactory = new OrganismFactory(Tiger, Tree);

      const pond = new Habitat(1, 1, pondFactory);
      const jungle = new Habitat(1, 1, jungleFactory);

      expect(pond.simulate()[0]).toContain('ガーガー');
      expect(jungle.simulate()[0]).toContain('ガオー');
    });
  });
});
