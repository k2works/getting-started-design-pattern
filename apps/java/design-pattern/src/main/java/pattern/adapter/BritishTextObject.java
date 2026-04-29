package pattern.adapter;

/**
 * 英国式テキストオブジェクト（Adaptee）。
 * 英国式の命名規則を持つ: string, sizeMm, colour。
 */
public class BritishTextObject {
    private final String string;
    private final double sizeMm;
    private final String colour;

    public BritishTextObject(String string, double sizeMm, String colour) {
        this.string = string;
        this.sizeMm = sizeMm;
        this.colour = colour;
    }

    public String getString() {
        return string;
    }

    public double getSizeMm() {
        return sizeMm;
    }

    public String getColour() {
        return colour;
    }
}
