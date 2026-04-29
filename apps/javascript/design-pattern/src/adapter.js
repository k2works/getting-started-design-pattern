// Adapter パターン
// 互換性のないインターフェースを変換して接続する

export class TextObject {
  constructor(text, sizeInches, color) {
    this.text = text;
    this.sizeInches = sizeInches;
    this.color = color;
  }
}

export class BritishTextObject {
  constructor(string, sizeMm, colour) {
    this.string = string;
    this.sizeMm = sizeMm;
    this.colour = colour;
  }
}

export class BritishTextObjectAdapter {
  constructor(britishObject) {
    this._britishObject = britishObject;
  }

  get text() {
    return this._britishObject.string;
  }

  set text(value) {
    this._britishObject.string = value;
  }

  get sizeInches() {
    return this._britishObject.sizeMm / 25.4;
  }

  set sizeInches(value) {
    this._britishObject.sizeMm = value * 25.4;
  }

  get color() {
    return this._britishObject.colour;
  }

  set color(value) {
    this._britishObject.colour = value;
  }
}

export class Renderer {
  render(textObject) {
    return `${textObject.text} (${textObject.sizeInches.toFixed(1)}in, ${textObject.color})`;
  }
}
