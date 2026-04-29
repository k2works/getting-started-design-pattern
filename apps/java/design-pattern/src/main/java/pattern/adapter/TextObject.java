package pattern.adapter;

/**
 * テキストオブジェクト（ターゲット）。
 * テキスト、サイズ（インチ）、色を持つ。
 */
public class TextObject {
    private final String text;
    private final double sizeInches;
    private final String color;

    public TextObject(String text, double sizeInches, String color) {
        this.text = text;
        this.sizeInches = sizeInches;
        this.color = color;
    }

    public String getText() {
        return text;
    }

    public double getSizeInches() {
        return sizeInches;
    }

    public String getColor() {
        return color;
    }
}
