package pattern.adapter;

/**
 * BritishTextObject を TextObject インターフェースに適合させるアダプター。
 * mm をインチに変換し、colour を color として公開する。
 */
public class BritishTextObjectAdapter extends TextObject {
    private static final double MM_PER_INCH = 25.4;
    private final BritishTextObject bto;

    public BritishTextObjectAdapter(BritishTextObject bto) {
        super(null, 0, null);
        this.bto = bto;
    }

    @Override
    public String getText() {
        return bto.getString();
    }

    @Override
    public double getSizeInches() {
        return bto.getSizeMm() / MM_PER_INCH;
    }

    @Override
    public String getColor() {
        return bto.getColour();
    }
}
