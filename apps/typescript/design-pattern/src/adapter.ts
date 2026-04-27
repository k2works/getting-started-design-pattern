/**
 * Adapter パターン
 *
 * 互換性のないインターフェースを変換し、
 * 既存クラスを新しいインターフェースで利用可能にする。
 */

export interface TextObject {
  text: string;
  sizeInches: number;
  color: string;
}

export class BritishTextObject {
  string: string;
  sizeMm: number;
  colour: string;

  constructor(string: string, sizeMm: number, colour: string) {
    this.string = string;
    this.sizeMm = sizeMm;
    this.colour = colour;
  }
}

export class BritishTextObjectAdapter implements TextObject {
  private britishObject: BritishTextObject;

  constructor(britishObject: BritishTextObject) {
    this.britishObject = britishObject;
  }

  get text(): string {
    return this.britishObject.string;
  }

  get sizeInches(): number {
    return this.britishObject.sizeMm / 25.4;
  }

  get color(): string {
    return this.britishObject.colour;
  }
}

export class Renderer {
  render(textObject: TextObject): string {
    return `Rendering "${textObject.text}" at ${textObject.sizeInches.toFixed(2)} inches in ${textObject.color}`;
  }
}
