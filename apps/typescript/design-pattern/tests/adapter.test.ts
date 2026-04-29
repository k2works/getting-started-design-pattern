import {
  BritishTextObject,
  BritishTextObjectAdapter,
  Renderer,
} from '../src/adapter';

describe('Adapter パターン', () => {
  it('BritishTextObjectAdapter は text を返す', () => {
    const british = new BritishTextObject('Hello', 25.4, 'red');
    const adapter = new BritishTextObjectAdapter(british);
    expect(adapter.text).toBe('Hello');
  });

  it('BritishTextObjectAdapter は mm を inches に変換する', () => {
    const british = new BritishTextObject('Hello', 25.4, 'red');
    const adapter = new BritishTextObjectAdapter(british);
    expect(adapter.sizeInches).toBeCloseTo(1.0, 5);
  });

  it('BritishTextObjectAdapter は colour を color に変換する', () => {
    const british = new BritishTextObject('Hello', 25.4, 'red');
    const adapter = new BritishTextObjectAdapter(british);
    expect(adapter.color).toBe('red');
  });

  it('Renderer は TextObject を受け取って描画する', () => {
    const british = new BritishTextObject('World', 50.8, 'blue');
    const adapter = new BritishTextObjectAdapter(british);
    const renderer = new Renderer();
    const result = renderer.render(adapter);

    expect(result).toContain('World');
    expect(result).toContain('2.00');
    expect(result).toContain('blue');
  });

  it('BritishTextObject は元のプロパティを保持する', () => {
    const british = new BritishTextObject('Test', 100, 'green');
    expect(british.string).toBe('Test');
    expect(british.sizeMm).toBe(100);
    expect(british.colour).toBe('green');
  });
});
