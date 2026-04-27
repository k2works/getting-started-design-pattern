import { describe, it, expect } from '@jest/globals';
import {
  TextObject,
  BritishTextObject,
  BritishTextObjectAdapter,
  Renderer,
} from '../src/adapter.js';

describe('Adapter パターン', () => {
  it('TextObject をそのまま Renderer で描画できる', () => {
    const text = new TextObject('Hello', 1.0, 'red');
    const renderer = new Renderer();
    const output = renderer.render(text);

    expect(output).toBe('Hello (1.0in, red)');
  });

  it('BritishTextObject は異なるインターフェースを持つ', () => {
    const british = new BritishTextObject('Hello', 25.4, 'red');
    expect(british.string).toBe('Hello');
    expect(british.sizeMm).toBe(25.4);
    expect(british.colour).toBe('red');
  });

  it('Adapter で BritishTextObject を TextObject として扱える', () => {
    const british = new BritishTextObject('Hello', 25.4, 'red');
    const adapted = new BritishTextObjectAdapter(british);

    expect(adapted.text).toBe('Hello');
    expect(adapted.sizeInches).toBeCloseTo(1.0);
    expect(adapted.color).toBe('red');
  });

  it('Adapter を通して Renderer で描画できる', () => {
    const british = new BritishTextObject('World', 50.8, 'blue');
    const adapted = new BritishTextObjectAdapter(british);
    const renderer = new Renderer();

    expect(renderer.render(adapted)).toBe('World (2.0in, blue)');
  });

  it('Adapter を通じた変更が元のオブジェクトに反映される', () => {
    const british = new BritishTextObject('Old', 25.4, 'red');
    const adapted = new BritishTextObjectAdapter(british);

    adapted.text = 'New';
    adapted.sizeInches = 2.0;
    adapted.color = 'blue';

    expect(british.string).toBe('New');
    expect(british.sizeMm).toBeCloseTo(50.8);
    expect(british.colour).toBe('blue');
  });
});
