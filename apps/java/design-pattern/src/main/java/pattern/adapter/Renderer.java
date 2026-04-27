package pattern.adapter;

/**
 * レンダラー（クライアント）。
 * TextObject を受け取り、統一的にレンダリングする。
 */
public class Renderer {
    public String render(TextObject textObject) {
        return "text:" + textObject.getText()
                + " size:" + textObject.getSizeInches()
                + " color:" + textObject.getColor();
    }
}
